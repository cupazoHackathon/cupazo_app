# Resumen Ejecutivo - Cupazo Dashboard en Tiempo Real

## 🎯 Contexto del Proyecto

**Cupazo** es una plataforma de ofertas colaborativas donde vendedores crean ofertas (2x1, 3x2) y usuarios se agrupan para comprar. El dashboard del vendedor (`/seller`) muestra KPIs y actividad en **tiempo real usando Supabase Realtime**.

## 📊 Dashboard del Vendedor - Funcionalidades

### KPIs en Tiempo Real:
1. **Ventas Totales**: Suma de `transactions.amount_total` donde `payment_status = 'paid'` de grupos de ofertas del vendedor
2. **Matches Activos**: Conteo de `match_groups` con `status IN ('open', 'full')` de ofertas del vendedor  
3. **Por Despachar**: Grupos con transacciones pagadas pero `status != 'completed'`

### Actividad Reciente:
- Feed en tiempo real de: nuevos grupos, grupos completados, intereses en ofertas, usuarios uniéndose

## 🗄️ Schema de Base de Datos (Relevante)

```sql
-- Tablas principales para el dashboard
deals: id, user_id (FK), title, price, category, active
match_groups: id, deal_id (FK), status ('open'|'full'|'completed'|'cancelled'), created_at
match_group_members: id, group_id (FK), user_id (FK), joined_at
transactions: id, match_group_id (FK), amount_total, payment_status ('pending'|'paid'|'failed')
deal_interests: id, deal_id (FK), user_id (FK), status ('interested'|'maybe'), created_at
```

## ⚡ Implementación Actual

### Hook: `useRealtimeDashboard` 
**Archivo**: `features/dashboard/hooks/useRealtimeDashboard.ts`

**Funcionalidad**:
- Carga KPIs iniciales (ventas, matches activos, por despachar)
- Carga actividad reciente (últimos 20 eventos)
- Suscripciones en tiempo real a:
  - `match_groups` → Actualiza matches activos y por despachar
  - `transactions` → Actualiza ventas totales
  - `match_group_members` → Detecta nuevos miembros
  - `deal_interests` → Detecta nuevos intereses

**Uso**:
```typescript
const { kpis, recentActivity, loading } = useRealtimeDashboard(user?.id || null)
```

### Componente: `app/seller/page.tsx`
- Usa el hook `useRealtimeDashboard`
- Muestra 3 cards de KPIs
- Muestra feed de actividad reciente con timestamps relativos
- Integra `SmartSuggestions` (IA) y `DealList`

## 🔧 Configuración Necesaria en Supabase

### 1. Habilitar Realtime
En Supabase Dashboard → Database → Replication, activar para:
- `match_groups`
- `match_group_members`  
- `transactions`
- `deal_interests`

### 2. Row Level Security (RLS)
Políticas necesarias para que vendedores vean solo sus datos:

```sql
-- match_groups: vendedores ven solo grupos de sus ofertas
CREATE POLICY "Sellers view own match groups" ON match_groups FOR SELECT
USING (EXISTS (SELECT 1 FROM deals WHERE deals.id = match_groups.deal_id AND deals.user_id = auth.uid()));

-- transactions: vendedores ven transacciones de sus ofertas  
CREATE POLICY "Sellers view own transactions" ON transactions FOR SELECT
USING (EXISTS (
  SELECT 1 FROM match_groups 
  JOIN deals ON deals.id = match_groups.deal_id
  WHERE match_groups.id = transactions.match_group_id AND deals.user_id = auth.uid()
));

-- Similar para match_group_members y deal_interests
```

### 3. Índices Recomendados
```sql
CREATE INDEX idx_match_groups_deal_id ON match_groups(deal_id);
CREATE INDEX idx_transactions_match_group_id ON transactions(match_group_id);
CREATE INDEX idx_transactions_payment_status ON transactions(payment_status);
```

## 📁 Archivos Clave

```
app/seller/page.tsx                              # Dashboard principal
features/dashboard/hooks/useRealtimeDashboard.ts # Hook de tiempo real
features/dashboard/services/dashboard.service.ts # Servicio de KPIs
lib/supabase/client.ts                           # Cliente Supabase
SUPABASE_REALTIME_SETUP.md                       # Guía completa de setup
```

## 🔄 Flujo de Tiempo Real

1. Usuario carga dashboard → Hook carga datos iniciales
2. Hook establece suscripciones WebSocket a tablas
3. Cambio en BD → Supabase envía evento
4. Hook recibe evento → Actualiza estado React
5. Componente se re-renderiza → Usuario ve cambios sin refrescar

## 🐛 Troubleshooting Común

- **No recibe eventos**: Verificar Realtime habilitado y RLS configurado
- **Permission denied**: Verificar políticas RLS y que usuario esté autenticado
- **Ventas incorrectas**: Verificar JOIN correcto entre transactions → match_groups → deals

## ✅ Estado Actual

- ✅ Hook `useRealtimeDashboard` implementado
- ✅ Componente dashboard usando hook
- ✅ Cálculo correcto de KPIs
- ✅ Feed de actividad reciente
- ⚠️ **Pendiente**: Configurar RLS y Realtime en Supabase (ver `SUPABASE_REALTIME_SETUP.md`)

## 📚 Documentación Completa

- `CONTEXTO_COMPLETO_PROYECTO.md` - Documentación detallada completa
- `SUPABASE_REALTIME_SETUP.md` - Guía paso a paso de configuración
- `DATABASE_SCHEMA.md` - Schema completo de BD
- `viewsvendedor.md` - Vistas del panel vendedor

---

**Stack**: Next.js 14, React, TypeScript, Supabase (PostgreSQL + Realtime), Tailwind CSS, shadcn/ui


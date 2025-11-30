# Contexto Completo del Proyecto Cupazo - Dashboard en Tiempo Real

## 📋 Índice
1. [Descripción del Proyecto](#descripción-del-proyecto)
2. [Arquitectura de Base de Datos](#arquitectura-de-base-de-datos)
3. [Dashboard del Vendedor (Torre de Control)](#dashboard-del-vendedor)
4. [Implementación en Tiempo Real](#implementación-en-tiempo-real)
5. [Configuración de Supabase](#configuración-de-supabase)
6. [Estructura de Archivos](#estructura-de-archivos)
7. [Guías de Uso](#guías-de-uso)

---

## 🎯 Descripción del Proyecto

**Cupazo** es una plataforma de ofertas colaborativas donde:
- **Emprendedores (Sellers)** crean ofertas tipo 2x1, 3x2, precio por grupo
- **Usuarios (Buyers)** se agrupan para aprovechar ofertas colaborativas
- **IA** recomienda matches entre usuarios y optimiza ofertas
- **Dashboard en tiempo real** para que vendedores monitoreen su negocio

### Stack Tecnológico
- **Frontend**: Next.js 14+ (App Router), React, TypeScript
- **Backend**: Supabase (PostgreSQL + Realtime + Auth)
- **UI**: Tailwind CSS, shadcn/ui components
- **Estado**: React Hooks, Supabase Realtime Subscriptions

---

## 🗄️ Arquitectura de Base de Datos

### Tablas Principales

#### 1. `users`
Usuarios de la plataforma (buyers y sellers)
```sql
- id (uuid, PK)
- name (text)
- email (text)
- address (text)
- address_lat, address_lng (float8)
- reliability_score (int4, 1-5)
- role (text: 'buyer', 'seller', 'buyer_seller', 'admin')
- city (text)
- created_at (timestamptz)
```

#### 2. `deals`
Ofertas creadas por vendedores
```sql
- id (uuid, PK)
- user_id (uuid, FK → users.id) -- El vendedor
- title (text)
- description (text)
- type (text: '2x1', '3x2', 'group_price')
- max_group_size (int2)
- price (numeric)
- category (text: 'comida', 'ropa', 'tecnologia', etc.)
- location_lat, location_lng (float8)
- active (bool)
- image_url (text)
- created_at (timestamptz)
- expires_at (timestamptz)
```

#### 3. `match_groups`
Grupos colaborativos formados para un deal
```sql
- id (uuid, PK)
- deal_id (uuid, FK → deals.id)
- max_group_size (int2)
- status (text: 'open', 'full', 'completed', 'cancelled')
- created_at (timestamptz)
```

#### 4. `match_group_members`
Miembros de cada grupo
```sql
- id (uuid, PK)
- group_id (uuid, FK → match_groups.id)
- user_id (uuid, FK → users.id)
- role (text: 'leader', 'member')
- joined_at (timestamp)
- delivery_address (text)
- delivery_lat, delivery_lng (float8)
- status (text: 'confirmed', 'pending')
```

#### 5. `transactions`
Transacciones de pago
```sql
- id (uuid, PK)
- match_group_id (uuid, FK → match_groups.id)
- payer_user_id (uuid, FK → users.id)
- amount_total (numeric)
- platform_fee (numeric)
- delivery_fee (numeric)
- payment_status (text: 'pending', 'paid', 'failed')
- stripe_payment_id (text)
- created_at (timestamp)
```

#### 6. `deal_interests`
Intereses de usuarios en ofertas
```sql
- id (uuid, PK)
- deal_id (uuid, FK → deals.id)
- user_id (uuid, FK → users.id)
- status (text: 'interested', 'maybe', 'joined_group')
- preferred_time_window (text)
- created_at (timestamptz)
```

#### 7. `user_activity`
Log de actividad para IA
```sql
- id (uuid, PK)
- user_id (uuid, FK → users.id)
- deal_id (uuid, FK → deals.id, nullable)
- event_type (text: 'view_deal', 'click_deal', 'join_group', etc.)
- source (text: 'mobile_app', 'web')
- metadata (jsonb)
- created_at (timestamptz)
```

---

## 📊 Dashboard del Vendedor (Torre de Control)

### Ruta
`/seller` - Panel principal del emprendedor

### Funcionalidades

#### 1. KPIs en Tiempo Real
- **Ventas Totales**: Suma de `transactions.amount_total` donde `payment_status = 'paid'` y pertenecen a grupos de ofertas del vendedor
- **Matches Activos**: Conteo de `match_groups` con `status IN ('open', 'full')` de ofertas del vendedor
- **Por Despachar**: Grupos con transacciones pagadas pero `status != 'completed'`

#### 2. Sugerencias Inteligentes
- Componente `SmartSuggestions` que usa IA para recomendar mejoras
- Basado en análisis de rendimiento de ofertas

#### 3. Actividad Reciente
- Feed en tiempo real de eventos:
  - Nuevos grupos creados
  - Grupos completados
  - Intereses en ofertas
  - Usuarios uniéndose a grupos

#### 4. Ofertas Recientes
- Listado de ofertas del vendedor usando componente `DealList`

---

## ⚡ Implementación en Tiempo Real

### Hook Principal: `useRealtimeDashboard`

**Ubicación**: `features/dashboard/hooks/useRealtimeDashboard.ts`

**Funcionalidad**:
- Carga inicial de KPIs y actividad
- Suscripciones en tiempo real a cambios en:
  - `match_groups` → Actualiza KPIs de matches
  - `transactions` → Actualiza ventas totales
  - `match_group_members` → Detecta nuevos miembros
  - `deal_interests` → Detecta nuevos intereses

**Uso**:
```typescript
const { kpis, recentActivity, loading } = useRealtimeDashboard(user?.id || null)
```

**Retorna**:
```typescript
{
  kpis: {
    totalSales: number
    activeMatches: number
    toDispatch: number
  },
  recentActivity: Array<{
    id: string
    type: 'match' | 'group_completed' | 'interest' | 'transaction'
    message: string
    dealTitle?: string
    userName?: string
    timestamp: string
  }>,
  loading: boolean,
  refresh: () => void
}
```

### Cálculo de KPIs

#### Ventas Totales
```typescript
// 1. Obtener deals del vendedor
const deals = await supabase
  .from('deals')
  .select('id')
  .eq('user_id', sellerId)

// 2. Obtener grupos de esos deals
const groups = await supabase
  .from('match_groups')
  .select('id')
  .in('deal_id', dealIds)

// 3. Obtener transacciones pagadas de esos grupos
const transactions = await supabase
  .from('transactions')
  .select('amount_total')
  .in('match_group_id', groupIds)
  .eq('payment_status', 'paid')

// 4. Sumar amount_total
totalSales = transactions.reduce((sum, t) => sum + Number(t.amount_total), 0)
```

#### Matches Activos
```typescript
const count = await supabase
  .from('match_groups')
  .select('*', { count: 'exact', head: true })
  .in('deal_id', dealIds)
  .in('status', ['open', 'full'])
```

#### Por Despachar
```typescript
// Grupos con transacciones pagadas pero no completados
const paidGroups = await supabase
  .from('transactions')
  .select('match_group_id')
  .in('match_group_id', groupIds)
  .eq('payment_status', 'paid')

// Filtrar grupos no completados
const toDispatch = await supabase
  .from('match_groups')
  .select('*', { count: 'exact', head: true })
  .in('id', paidGroupIds)
  .neq('status', 'completed')
```

### Suscripciones en Tiempo Real

```typescript
// Suscripción a match_groups
const channel = supabase
  .channel('seller-match-groups')
  .on('postgres_changes', {
    event: '*', // INSERT, UPDATE, DELETE
    schema: 'public',
    table: 'match_groups',
    filter: `deal_id=in.(${dealIds.join(',')})`
  }, (payload) => {
    // Recargar KPIs cuando cambie un grupo
    loadKPIs()
    loadRecentActivity()
  })
  .subscribe()
```

---

## 🔧 Configuración de Supabase

### 1. Habilitar Realtime

**En Supabase Dashboard**:
1. Ve a **Database** → **Replication**
2. Activa Realtime para:
   - ✅ `match_groups`
   - ✅ `match_group_members`
   - ✅ `transactions`
   - ✅ `deal_interests`

**O vía SQL**:
```sql
ALTER PUBLICATION supabase_realtime ADD TABLE match_groups;
ALTER PUBLICATION supabase_realtime ADD TABLE match_group_members;
ALTER PUBLICATION supabase_realtime ADD TABLE transactions;
ALTER PUBLICATION supabase_realtime ADD TABLE deal_interests;
```

### 2. Row Level Security (RLS)

#### Política para `match_groups`
```sql
-- Vendedores ven solo grupos de sus ofertas
CREATE POLICY "Sellers can view their own match groups"
ON match_groups FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM deals
    WHERE deals.id = match_groups.deal_id
    AND deals.user_id = auth.uid()
  )
);
```

#### Política para `transactions`
```sql
-- Vendedores ven transacciones de sus ofertas
CREATE POLICY "Sellers can view transactions for their deals"
ON transactions FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM match_groups
    JOIN deals ON deals.id = match_groups.deal_id
    WHERE match_groups.id = transactions.match_group_id
    AND deals.user_id = auth.uid()
  )
);
```

#### Política para `match_group_members`
```sql
CREATE POLICY "Sellers can view members of their deal groups"
ON match_group_members FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM match_groups
    JOIN deals ON deals.id = match_groups.deal_id
    WHERE match_groups.id = match_group_members.group_id
    AND deals.user_id = auth.uid()
  )
);
```

#### Política para `deal_interests`
```sql
CREATE POLICY "Sellers can view interests in their deals"
ON deal_interests FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM deals
    WHERE deals.id = deal_interests.deal_id
    AND deals.user_id = auth.uid()
  )
);
```

### 3. Índices Recomendados

```sql
-- match_groups
CREATE INDEX idx_match_groups_deal_id ON match_groups(deal_id);
CREATE INDEX idx_match_groups_status ON match_groups(status);

-- transactions
CREATE INDEX idx_transactions_match_group_id ON transactions(match_group_id);
CREATE INDEX idx_transactions_payment_status ON transactions(payment_status);

-- match_group_members
CREATE INDEX idx_match_group_members_group_id ON match_group_members(group_id);

-- deal_interests
CREATE INDEX idx_deal_interests_deal_id ON deal_interests(deal_id);
CREATE INDEX idx_deal_interests_created_at ON deal_interests(created_at DESC);
```

---

## 📁 Estructura de Archivos

```
cupazo-webapp/
├── app/
│   └── seller/
│       └── page.tsx                    # Dashboard principal (Torre de Control)
│
├── features/
│   └── dashboard/
│       ├── hooks/
│       │   └── useRealtimeDashboard.ts # Hook principal para tiempo real
│       └── services/
│           └── dashboard.service.ts    # Servicio para cálculos de KPIs
│
├── lib/
│   └── supabase/
│       └── client.ts                   # Cliente de Supabase
│
├── components/
│   └── ui/                             # Componentes shadcn/ui
│
├── SUPABASE_REALTIME_SETUP.md         # Guía de configuración
└── CONTEXTO_COMPLETO_PROYECTO.md       # Este archivo
```

### Archivos Clave

#### `app/seller/page.tsx`
Componente principal del dashboard que:
- Usa `useRealtimeDashboard` para obtener datos
- Muestra KPIs en tiempo real
- Muestra actividad reciente
- Integra `SmartSuggestions` y `DealList`

#### `features/dashboard/hooks/useRealtimeDashboard.ts`
Hook que:
- Carga datos iniciales
- Establece suscripciones en tiempo real
- Actualiza estado cuando hay cambios
- Retorna KPIs y actividad reciente

#### `features/dashboard/services/dashboard.service.ts`
Servicio que:
- Calcula KPIs (ventas, matches, por despachar)
- Hace queries optimizadas a Supabase
- Maneja errores

---

## 🚀 Guías de Uso

### Para Desarrolladores

#### 1. Configurar Supabase
1. Lee `SUPABASE_REALTIME_SETUP.md`
2. Ejecuta los SQL de RLS
3. Habilita Realtime en las tablas
4. Crea los índices recomendados

#### 2. Variables de Entorno
```env
NEXT_PUBLIC_SUPABASE_URL=tu_url_de_supabase
NEXT_PUBLIC_SUPABASE_ANON_KEY=tu_anon_key
```

#### 3. Usar el Dashboard
El dashboard se actualiza automáticamente cuando:
- Se crea un nuevo grupo
- Se une un usuario a un grupo
- Se completa un pago
- Se muestra interés en una oferta

### Para Vendedores

El dashboard muestra:
- **Ventas Totales**: Dinero ganado (transacciones pagadas)
- **Matches Activos**: Grupos formándose actualmente
- **Por Despachar**: Órdenes pagadas listas para enviar
- **Actividad Reciente**: Eventos importantes en tiempo real

---

## 🔍 Troubleshooting

### Problema: No se reciben eventos en tiempo real
**Solución**:
1. Verifica que Realtime esté habilitado en Supabase Dashboard
2. Verifica que las políticas RLS permitan SELECT
3. Revisa la consola del navegador para errores
4. Verifica variables de entorno

### Problema: Error "permission denied"
**Solución**:
1. Verifica que las políticas RLS estén configuradas
2. Asegúrate de que el usuario esté autenticado
3. Verifica que `deals.user_id = auth.uid()`

### Problema: Las ventas no se calculan
**Solución**:
1. Verifica que `transactions.payment_status = 'paid'`
2. Verifica que los grupos pertenezcan a ofertas del vendedor
3. Revisa que `amount_total` sea un número válido

---

## 📝 Notas Importantes

1. **Realtime consume recursos**: Solo habilita en tablas necesarias
2. **RLS es crítico**: Sin RLS, vendedores podrían ver datos de otros
3. **Índices mejoran rendimiento**: Especialmente con muchas transacciones
4. **El hook se desuscribe automáticamente**: Cuando el componente se desmonta

---

## 🔄 Flujo de Datos

```
1. Usuario carga dashboard
   ↓
2. useRealtimeDashboard carga KPIs iniciales
   ↓
3. Se establecen suscripciones en tiempo real
   ↓
4. Cuando hay cambio en BD:
   - Supabase envía evento vía WebSocket
   - Hook recibe evento
   - Hook actualiza estado
   - Componente se re-renderiza
   ↓
5. Usuario ve datos actualizados sin refrescar
```

---

## 📚 Referencias

- **Documentación Supabase Realtime**: https://supabase.com/docs/guides/realtime
- **Documentación RLS**: https://supabase.com/docs/guides/auth/row-level-security
- **Archivo de configuración**: `SUPABASE_REALTIME_SETUP.md`
- **Schema de BD**: `DATABASE_SCHEMA.md`
- **Contexto del proyecto**: `READMECONTEXT.md`

---

## ✅ Checklist de Implementación

- [ ] Habilitar Realtime en tablas necesarias
- [ ] Configurar políticas RLS
- [ ] Crear índices recomendados
- [ ] Verificar variables de entorno
- [ ] Probar suscripciones en tiempo real
- [ ] Verificar cálculo de KPIs
- [ ] Probar actividad reciente
- [ ] Verificar que no haya errores en consola

---

**Última actualización**: Noviembre 2024
**Versión**: 1.0.0


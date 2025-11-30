# Configuración de Supabase para Dashboard en Tiempo Real

Esta guía explica cómo configurar Supabase para que el dashboard del vendedor funcione en tiempo real.

## 1. Habilitar Realtime en Supabase

### Paso 1: Habilitar Realtime en las Tablas

Ve a tu proyecto en Supabase Dashboard → **Database** → **Replication**

Habilita Realtime para las siguientes tablas:

- ✅ `match_groups`
- ✅ `match_group_members`
- ✅ `transactions`
- ✅ `deal_interests`
- ✅ `user_activity` (opcional, para actividad detallada)

**Cómo hacerlo:**
1. En el panel de Supabase, ve a **Database** → **Replication**
2. Para cada tabla, activa el toggle de **Realtime**
3. O usa SQL:

```sql
-- Habilitar Realtime en las tablas necesarias
ALTER PUBLICATION supabase_realtime ADD TABLE match_groups;
ALTER PUBLICATION supabase_realtime ADD TABLE match_group_members;
ALTER PUBLICATION supabase_realtime ADD TABLE transactions;
ALTER PUBLICATION supabase_realtime ADD TABLE deal_interests;
ALTER PUBLICATION supabase_realtime ADD TABLE user_activity;
```

## 2. Configurar Row Level Security (RLS)

### Políticas RLS para `match_groups`

Los vendedores solo deben ver los grupos de sus propias ofertas:

```sql
-- Política para SELECT: vendedores ven solo sus grupos
CREATE POLICY "Sellers can view their own match groups"
ON match_groups
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM deals
    WHERE deals.id = match_groups.deal_id
    AND deals.user_id = auth.uid()
  )
);

-- Política para UPDATE: vendedores pueden actualizar estado de sus grupos
CREATE POLICY "Sellers can update their own match groups"
ON match_groups
FOR UPDATE
USING (
  EXISTS (
    SELECT 1 FROM deals
    WHERE deals.id = match_groups.deal_id
    AND deals.user_id = auth.uid()
  )
);
```

### Políticas RLS para `transactions`

Los vendedores deben ver transacciones de sus ofertas:

```sql
-- Política para SELECT: vendedores ven transacciones de sus ofertas
CREATE POLICY "Sellers can view transactions for their deals"
ON transactions
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM match_groups
    JOIN deals ON deals.id = match_groups.deal_id
    WHERE match_groups.id = transactions.match_group_id
    AND deals.user_id = auth.uid()
  )
);
```

### Políticas RLS para `match_group_members`

```sql
-- Política para SELECT: vendedores ven miembros de grupos de sus ofertas
CREATE POLICY "Sellers can view members of their deal groups"
ON match_group_members
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM match_groups
    JOIN deals ON deals.id = match_groups.deal_id
    WHERE match_groups.id = match_group_members.group_id
    AND deals.user_id = auth.uid()
  )
);
```

### Políticas RLS para `deal_interests`

```sql
-- Política para SELECT: vendedores ven intereses en sus ofertas
CREATE POLICY "Sellers can view interests in their deals"
ON deal_interests
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM deals
    WHERE deals.id = deal_interests.deal_id
    AND deals.user_id = auth.uid()
  )
);
```

## 3. Verificar Estructura de Tablas

Asegúrate de que las tablas tengan los campos necesarios:

### `match_groups`
- ✅ `id` (uuid)
- ✅ `deal_id` (uuid, FK a deals)
- ✅ `status` (text: 'open', 'full', 'completed', 'cancelled')
- ✅ `payment_status` (text: 'pending', 'paid', 'failed') - **IMPORTANTE**
- ✅ `created_at` (timestamptz)

### `transactions`
- ✅ `id` (uuid)
- ✅ `match_group_id` (uuid, FK a match_groups)
- ✅ `amount_total` (numeric)
- ✅ `payment_status` (text: 'pending', 'paid', 'failed')
- ✅ `created_at` (timestamp)

### `match_group_members`
- ✅ `id` (uuid)
- ✅ `group_id` (uuid, FK a match_groups)
- ✅ `user_id` (uuid, FK a users)
- ✅ `joined_at` (timestamp)

### `deal_interests`
- ✅ `id` (uuid)
- ✅ `deal_id` (uuid, FK a deals)
- ✅ `user_id` (uuid, FK a users)
- ✅ `status` (text: 'interested', 'maybe', 'joined_group')
- ✅ `created_at` (timestamptz)

## 4. Índices Recomendados

Para mejorar el rendimiento de las consultas:

```sql
-- Índices para match_groups
CREATE INDEX idx_match_groups_deal_id ON match_groups(deal_id);
CREATE INDEX idx_match_groups_status ON match_groups(status);
CREATE INDEX idx_match_groups_payment_status ON match_groups(payment_status);

-- Índices para transactions
CREATE INDEX idx_transactions_match_group_id ON transactions(match_group_id);
CREATE INDEX idx_transactions_payment_status ON transactions(payment_status);

-- Índices para match_group_members
CREATE INDEX idx_match_group_members_group_id ON match_group_members(group_id);
CREATE INDEX idx_match_group_members_user_id ON match_group_members(user_id);

-- Índices para deal_interests
CREATE INDEX idx_deal_interests_deal_id ON deal_interests(deal_id);
CREATE INDEX idx_deal_interests_status ON deal_interests(status);
CREATE INDEX idx_deal_interests_created_at ON deal_interests(created_at DESC);
```

## 5. Verificar Configuración del Cliente

Asegúrate de que tu cliente de Supabase esté configurado correctamente:

```typescript
// lib/supabase/client.ts
import { createBrowserClient } from '@supabase/ssr'

export function createClient() {
    return createBrowserClient(
        process.env.NEXT_PUBLIC_SUPABASE_URL!,
        process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
    )
}
```

## 6. Probar la Configuración

### Test 1: Verificar Realtime está habilitado

En Supabase Dashboard → **Database** → **Replication**, verifica que las tablas tengan el toggle activado.

### Test 2: Verificar RLS

1. Inicia sesión como vendedor
2. Intenta hacer una query directa a `match_groups`
3. Deberías ver solo los grupos de tus ofertas

### Test 3: Probar Suscripción en Tiempo Real

Abre la consola del navegador y verifica que no haya errores de conexión. Los eventos deberían aparecer en tiempo real cuando:

- Se crea un nuevo grupo
- Se une un usuario a un grupo
- Se completa un pago
- Se muestra interés en una oferta

## 7. Troubleshooting

### Problema: No se reciben eventos en tiempo real

**Solución:**
1. Verifica que Realtime esté habilitado en las tablas
2. Verifica que las políticas RLS permitan SELECT
3. Revisa la consola del navegador para errores de conexión
4. Verifica que `NEXT_PUBLIC_SUPABASE_URL` y `NEXT_PUBLIC_SUPABASE_ANON_KEY` estén configurados

### Problema: Error "permission denied"

**Solución:**
1. Verifica que las políticas RLS estén correctamente configuradas
2. Asegúrate de que el usuario esté autenticado (`auth.uid()` no sea null)
3. Verifica que el `user_id` en `deals` coincida con `auth.uid()`

### Problema: Las ventas no se calculan correctamente

**Solución:**
1. Verifica que `transactions.payment_status = 'paid'`
2. Verifica que el JOIN con `match_groups` funcione correctamente
3. Revisa que `amount_total` sea un número válido

## 8. Notas Importantes

- ⚠️ **Realtime consume recursos**: No habilites Realtime en tablas que no lo necesiten
- ⚠️ **RLS es crítico**: Sin RLS correcto, los vendedores podrían ver datos de otros
- ⚠️ **Índices mejoran rendimiento**: Especialmente importante con muchas transacciones
- ⚠️ **payment_status en match_groups**: Asegúrate de que este campo exista o usa una lógica alternativa

## 9. Próximos Pasos

Una vez configurado:

1. El dashboard se actualizará automáticamente cuando:
   - Se cree un nuevo grupo
   - Se una un usuario a un grupo
   - Se complete un pago
   - Se muestre interés en una oferta

2. Los KPIs se actualizarán en tiempo real sin necesidad de refrescar la página

3. La actividad reciente mostrará eventos en tiempo real con timestamps relativos


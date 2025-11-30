 B. Funcionalidades que usan IA (OpenAI + Edge Functions + Supabase)

Recomendación personalizada de ofertas

Dado un usuario, su actividad y la lista de deals activos → ordenar las mejores ofertas para él.

Usa:

users, deals, deal_interests, user_activity

opcional: feature_embeddings, match_recommendations

👉 IA (Edge Function que llama a OpenAI para rankear)

Matching de usuarios para formar grupos

Dado un usuario interesado en una oferta → sugerir con quién emparejarlo (u otros grupos cercanos).

Toma en cuenta:

ubicación, distancia_km

gustos similares

confiabilidad

Usa:

users, deals, match_groups, match_group_members, match_recommendations, feature_embeddings

👉 IA (Edge Function + OpenAI / vector search)

Perfil inteligente del usuario (gustos)

A partir de user_activity + deal_interests → generar un embedding o resumen de qué le gusta.

Se guarda en feature_embeddings (entity_type='user').

👉 IA (OpenAI embeddings + cron/Edge Function)

Perfil inteligente de cada oferta

Convertir título + descripción + categoría de un deal en un vector.

Similaridad entre ofertas (“ofertas parecidas a esta”).

Guarda en feature_embeddings (entity_type='deal').

👉 IA (OpenAI embeddings)

Detección de usuarios confiables o sospechosos

Calcular o actualizar reliability_score según:

si completan grupos

si cancelan mucho

si hay reportes

IA puede aprender patrones de fraude o abuso.

👉 IA (modelo simple + reglas + opcional LLM para análisis)

Sugerencias inteligentes para emprendedores

IA que mire:

vistas, clics, conversiones de cada deal (user_activity, deal_interests, match_groups)

Y recomiende:

cuándo lanzar 2×1

qué precio colaborativo probar

qué categoría funciona mejor en cada ciudad

👉 IA (Edge Function que llama a OpenAI con datos agregados)

Resumen y explicación de rendimiento

Para el panel web del emprendedor:

“Tus mejores promos esta semana fueron…”

“Tus clientes en Lima prefieren X en horario Y…”

👉 IA (LLM generando texto a partir de métricas calculadas en Supabase)

🧩 C. Soporte general (puede ser sin IA o con IA opcional)

Soporte / FAQ básico → se puede hacer como:

sin IA: sección de ayuda normal

con IA: chatbot entrenado con tus docs de Cupazo

Notificaciones y recordatorios

“Tu grupo está casi lleno”, “te falta 1 persona para completar el 2×1”

👉 Lógica normal + opcional IA para priorizar mensajes

Resumen ultra corto

Supabase solo → todo lo CRUD (usuarios, ofertas, grupos, actividad, panel, seguridad).

Supabase + IA → recomendaciones, matching, perfiles inteligentes, score de confiabilidad y asesoría a emprendedores.



feature_embeddings (vectores de IA)

Representación vectorial de usuarios y deals para hacer similitud y recomendaciones.

id (uuid)
Identificador único del embedding.

entity_type (text)
Qué tipo de entidad es, ejemplos:

'user' → embedding de usuario

'deal' → embedding de oferta

entity_id (uuid)
ID de la entidad en su tabla original (users.id o deals.id).

embedding (vector)
Vector numérico (ej. vector(1536)) generado por OpenAI.
Resume gustos del usuario o características del deal.

source (text)
De dónde viene el embedding, ej.: 'openai', 'internal_model'.

updated_at (timestamptz)
Última vez que se recalculó este embedding.


match_recommendations (recomendaciones de matching)

Resultados del motor de IA que sugiere con quién emparejar a un usuario.

id (uuid)
Identificador único de la recomendación.

user_id (uuid)
Usuario base para el que estamos recomendando (ej. user_00043).

candidate_id (uuid)
Usuario candidato para hacer match con el anterior (ej. user_12395).

distance_km (float8)
Distancia aproximada entre ambos usuarios.

similarity (float8)
Score de similitud de gustos/perfil (0–1).

reliability_score (float8)
Confiabilidad del candidato (puede ser copia de users.reliability_score en el momento del cálculo).

role (text)
Rol del candidato en la recomendación, ej.: 'buyer', 'co-buyer', etc.

rank (int4)
Posición en el ranking (1 = mejor candidato, 2 = segundo, etc.).

created_at (timestamptz)
Cuándo se generó esta recomendación.

(Y tienes el índice único user_id + candidate_id para no duplicar.)


[10:57 a. m., 29/11/2025] +51 949 171 245: deal_interests (interés en una oferta)

Usuarios que han mostrado interés en un deal, aunque todavía no estén en un grupo.

id (uuid)
Identificador único del interés.

deal_id (uuid)
FK → deals.id. Oferta a la que le tiene interés.

user_id (uuid)
FK → users.id. Usuario interesado.

status (text)
Estado del interés, ejemplos:

'interested' → le gusta la oferta

'maybe' → la guardó pero no está seguro

'joined_group' → ya se unió a grupo (sirve para analítica)

preferred_time_window (text)
Franja horaria preferida del usuario para recibir / coordinar
(ej. 'mañana', 'tarde', '18:00-20:00').

created_at (timestamptz)
Fecha en que se registró el interés.
[11:07 a. m., 29/11/2025] +51 949 171 245: user_activity (actividad del usuario)

Log de eventos para tracking y para IA.

id (uuid)
Identificador único del evento.

user_id (uuid)
FK → users.id. Quién hizo la acción.

deal_id (uuid, nullable)
FK → deals.id. Sobre qué oferta fue la acción (si aplica).

event_type (text)
Tipo de evento, ejemplos:

'view_deal'

'click_deal'

'join_group'

'leave_group'

'search'

source (text)
De dónde viene el evento, ej.: 'mobile_app', 'web'.

metadata (jsonb)
Datos adicionales del evento, ej.:

{
  "screen": "home",
  "position": 3,
  "category": "comida"
}


created_at (timestamptz)
Fecha y hora del evento.




match_group_members (miembros del grupo)

Quiénes están en cada grupo y cómo se les entrega.

id (uuid)
Identificador único del registro.

group_id (uuid)
FK → match_groups.id. A qué grupo pertenece este miembro.

user_id (uuid)
FK → users.id. Usuario que se unió al grupo.

role (text)
Rol dentro del grupo, ejemplos:

'buyer' → comprador normal

'owner' → el que creó el grupo (opcional si quieres distinguirlo)

joined_at (timestamp)
Momento en que el usuario se unió al grupo.

delivery_address (text)
Dirección específica para entregar su parte (si difiere de la address principal).

delivery_lat (float8)
Latitud de la dirección de entrega.

delivery_lng (float8)
Longitud de la dirección de entrega.



match_groups (grupos por deal)

Grupos que se forman alrededor de una oferta (ej. un 2x1 específico).

id (uuid)
Identificador único del grupo.

deal_id (uuid)
FK → deals.id. De qué oferta es este grupo.

max_group_size (int2)
Tamaño máximo del grupo (normalmente igual al del deal).

status (text)
Estado del grupo, ejemplos:

'open' → aún se pueden unir

'full' → grupo completo, listo para pagar/entregar

'completed' → compra completada

'cancelled' → grupo cancelado

created_at (timestamptz)
Fecha en que se creó el grupo.



deals (ofertas)

Ofertas creadas por los emprendedores.

id (uuid)
Identificador único del deal.

user_id (uuid)
FK → users.id. Es el seller que creó la oferta.

title (text)
Título corto del deal (lo que ves en la tarjeta).

description (text)
Descripción detallada de la promo.

type (text)
Tipo de oferta, ejemplos: '2x1', '3x2', 'group_price'.

max_group_size (int2)
Tamaño máximo del grupo necesario para activar la oferta (2, 3, 4…).

price (numeric)
Precio total o precio por persona según el tipo de promo (MVP: define una sola lógica).

category (text)
Categoría principal: 'comida', 'ropa', 'tecnologia', etc.

location_lat (float8)
Latitud del lugar donde se recoge / entrega (punto base del deal).

location_lng (float8)
Longitud del lugar del deal.

active (bool)
true si la oferta está visible y vigente, false si está pausada o terminada.

created_at (timestamptz)
Fecha de creación del deal.




users (usuarios)

Quién es quién en la plataforma. Buyers y sellers.

id (uuid)
Identificador único del usuario.

name (text)
Nombre visible en la app.

email (text)
Correo para login, notificaciones y verificación.

address (text)
Dirección base del usuario (texto libre).

address_lat (float8)
Latitud de la dirección base (para calcular distancias).

address_lng (float8)
Longitud de la dirección base.

reliability_score (int4 / float)
Puntuación de confiabilidad (ej. 1–5). Sube/baja según comportamiento.

role (text)
Tipo de usuario, ejemplos:

'buyer' → solo compra

'seller' → solo vende

'buyer_seller' → hace ambas cosas

created_at (timestamptz)
Fecha de creación del usuario.

city (text)
Ciudad principal del usuario (para segmentar ofertas).
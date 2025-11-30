# Database Schema Documentation

Based on the provided diagrams, here is the detailed schema of the Supabase backend.

## Tables

### 1. `users`
Stores user profile information for both Buyers and Sellers.
- **id** (`uuid`): Primary Key.
- **name** (`text`): User's full name.
- **email** (`text`): User's email address.
- **address** (`text`): Main physical address.
- **address_lat** (`float8`): Latitude of the address.
- **address_lng** (`float8`): Longitude of the address.
- **reliability_score** (`int4`): Score (1-5) indicating user reliability.
- **role** (`text`): Role of the user (e.g., 'buyer', 'seller', 'admin').
- **created_at** (`timestamptz`): Timestamp of creation.
- **city** (`text`): City of residence.

### 2. `deals`
Stores the offers created by Sellers.
- **id** (`uuid`): Primary Key.
- **user_id** (`uuid`): Foreign Key to `users.id` (The Seller).
- **title** (`text`): Title of the deal.
- **description** (`text`): Detailed description.
- **type** (`text`): Type of promotion (e.g., '2x1', '3x2', 'group_price').
- **max_group_size** (`int2`): Maximum number of people for the group.
- **price** (`numeric`): Price of the deal.
- **category** (`text`): Category (e.g., 'food', 'clothing').
- **location_lat** (`float8`): Latitude of the deal location.
- **location_lng** (`float8`): Longitude of the deal location.
- **active** (`bool`): Whether the deal is currently active.
- **created_at** (`timestamptz`): Creation timestamp.
- **expires_at** (`timestamptz`): Expiration timestamp.
- **image_url** (`text`): URL of the deal's image.

### 3. `match_groups`
Represents a collaborative group formed for a specific deal.
- **id** (`uuid`): Primary Key.
- **deal_id** (`uuid`): Foreign Key to `deals.id`.
- **max_group_size** (`int2`): Target size of the group.
- **status** (`text`): Status of the group (e.g., 'open', 'completed', 'cancelled').
- **created_at** (`timestamptz`): Creation timestamp.

### 4. `match_group_members`
Links users to match groups.
- **id** (`uuid`): Primary Key.
- **group_id** (`uuid`): Foreign Key to `match_groups.id`.
- **user_id** (`uuid`): Foreign Key to `users.id`.
- **role** (`text`): Role in the group (e.g., 'leader', 'member').
- **joined_at** (`timestamp`): When the user joined.
- **delivery_address** (`text`): Specific delivery address for this group order.
- **delivery_lat** (`float8`): Latitude of delivery address.
- **delivery_lng** (`float8`): Longitude of delivery address.
- **status** (`text`): Member status (e.g., 'confirmed', 'pending').

### 5. `deal_interests`
Tracks user interest in deals ("Me interesa" / "Quizás").
- **id** (`uuid`): Primary Key.
- **deal_id** (`uuid`): Foreign Key to `deals.id`.
- **user_id** (`uuid`): Foreign Key to `users.id`.
- **status** (`text`): Type of interest (e.g., 'interested', 'maybe').
- **preferred_time_window** (`text`): User's preferred time.
- **created_at** (`timestamptz`): Creation timestamp.

### 6. `user_activity`
Logs user actions for AI analysis.
- **id** (`uuid`): Primary Key.
- **user_id** (`uuid`): Foreign Key to `users.id`.
- **deal_id** (`uuid`): Foreign Key to `deals.id` (optional).
- **event_type** (`text`): Type of event (e.g., 'view_deal', 'click_deal', 'search', 'view_category').
- **source** (`text`): Source of the event (e.g., 'mobile', 'web').
- **metadata** (`jsonb`): Additional data.
- **created_at** (`timestamptz`): Timestamp of the event.

### 7. `transactions`
Records payments and financial transactions.
- **id** (`uuid`): Primary Key.
- **match_group_id** (`uuid`): Foreign Key to `match_groups.id`.
- **payer_user_id** (`uuid`): Foreign Key to `users.id`.
- **amount_total** (`numeric`): Total amount paid.
- **platform_fee** (`numeric`): Fee taken by the platform.
- **delivery_fee** (`numeric`): Delivery fee.
- **payment_status** (`text`): Status (e.g., 'paid', 'pending', 'failed').
- **stripe_payment_id** (`text`): External payment ID.
- **created_at** (`timestamp`): Transaction timestamp.

### 8. `match_recommendations`
Stores AI-generated recommendations for matching users.
- **id** (`uuid`): Primary Key.
- **user_id** (`uuid`): User receiving the recommendation.
- **candidate_id** (`uuid`): Recommended user/candidate.
- **distance_km** (`float8`): Distance between users.
- **similarity** (`float8`): Similarity score.
- **reliability_score** (`float8`): Reliability score of the candidate.
- **role** (`text`): Recommended role.
- **rank** (`int4`): Ranking of the recommendation.
- **created_at** (`timestamptz`): Creation timestamp.

### 9. `group_messages`
Chat messages within a group.
- **id** (`uuid`): Primary Key.
- **group_id** (`uuid`): Foreign Key to `match_groups.id`.
- **sender_id** (`uuid`): Foreign Key to `users.id`.
- **content** (`text`): Message content.
- **is_system_message** (`bool`): If it's an automated system message.
- **created_at** (`timestamp`): Timestamp.

### 10. `feature_embeddings`
Vector embeddings for AI search and recommendations.
- **id** (`uuid`): Primary Key.
- **entity_type** (`text`): Type of entity (e.g., 'deal', 'user').
- **entity_id** (`uuid`): ID of the entity.
- **embedding** (`vector`): The vector embedding itself.
- **source** (`text`): Source of the embedding.
- **updated_at** (`timestamptz`): Last update timestamp.

## Database Requirements per View (Seller Dashboard)

This section maps the 5 key Seller Dashboard views to the database tables they interact with.

### 1. Dashboard Principal ("La Torre de Control")
*   **Purpose:** Real-time KPIs and activity feed.
*   **Primary Tables:**
    *   `transactions`: To calculate "Ventas Totales" (Total Sales).
    *   `match_groups`: To count "Matches Activos" (Active Matches) and "Por Despachar" (Pending Dispatch).
    *   `user_activity`: To populate the "Actividad Reciente" (Recent Activity) feed.
*   **Queries:**
    *   `SELECT sum(amount_total) FROM transactions WHERE payer_user_id = :seller_id` (Conceptual)
    *   `SELECT count(*) FROM match_groups WHERE status = 'open'`

### 2. Offer Builder ("Creador de Ofertas")
*   **Purpose:** Create and publish new deals.
*   **Primary Tables:**
    *   `deals`: **INSERT** new records here.
    *   `users`: Read seller's `id` to link the deal.
*   **Key Fields:** `title`, `price`, `type`, `max_group_size`, `location_lat`, `location_lng`.

### 3. Gestor de Matches (Kanban Board)
*   **Purpose:** Manage lifecycle of collaborative groups.
*   **Primary Tables:**
    *   `match_groups`: **SELECT** all groups for the seller's deals. **UPDATE** status (e.g., moving from Lobby to Dispatch).
    *   `match_group_members`: **SELECT** to show avatars of users in each group.
    *   `users`: **SELECT** `name`, `avatar_url`, `reliability_score` of members.
    *   `transactions`: **SELECT** to check `payment_status` (visual cue for "Paid").

### 4. Billetera & Finanzas (Wallet)
*   **Purpose:** View earnings and request withdrawals.
*   **Primary Tables:**
    *   `transactions`: **SELECT** history of payments.
    *   `payouts` (Proposed): To track withdrawal requests (currently mocked).
*   **Logic:**
    *   *Net Earnings* = `amount_total` - `platform_fee`.

### 5. Marketplace de Servicios B2B
*   **Purpose:** Buy services (Photography, Verification).
*   **Primary Tables:**
    *   `services` (Proposed): Catalog of available services (currently mocked in code).
    *   `service_orders` (Proposed): To track purchased services.
*   **Current State:** Data is currently static/mocked in `app/seller/services/page.tsx`. Future implementation will require these new tables.

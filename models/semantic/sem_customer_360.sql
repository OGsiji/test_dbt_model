-- One-row-per-customer view consumed by CRM, mobile profile, and marketing APIs
select
    user_id,
    email,
    full_name,
    first_name,
    last_name,
    phone,
    city,
    country,
    engagement_status,
    customer_segment,
    rfm_status,
    lifetime_value,
    lifetime_orders,
    completed_orders,
    cancelled_orders,
    first_order_at,
    last_order_at,
    created_at,
    last_login,
    -- days since last activity (for re-engagement triggers)
    extract(days from now() - last_order_at)::int   as days_since_last_order,
    extract(days from now() - last_login)::int       as days_since_last_login,
    case
        when lifetime_orders > 0
        then round(lifetime_value / lifetime_orders, 2)
        else 0
    end                                              as avg_order_value
from {{ ref('dim_users') }}

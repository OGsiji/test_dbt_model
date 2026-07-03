with orders as (
    select * from {{ ref('stg_orders') }}
),

users as (
    select * from {{ ref('stg_users') }}
),

payments as (
    select * from {{ ref('stg_payments') }}
),

order_agg as (
    select
        order_id,
        sum(line_total)     as items_subtotal,
        sum(quantity)       as total_items,
        count(*)            as line_count
    from {{ ref('stg_order_items') }}
    group by order_id
),

joined as (
    select
        o.order_id,
        o.user_id,
        u.full_name,
        u.email,
        u.city,
        u.country,
        o.order_status,
        o.total_amount,
        o.discount,
        o.shipping_fee,
        oa.items_subtotal,
        oa.total_items,
        oa.line_count,
        o.ordered_at,
        o.shipped_at,
        o.delivered_at,
        o.hours_to_ship,
        o.days_in_transit,
        o.is_cancelled_or_refunded,
        p.payment_method,
        p.payment_status,
        p.amount_collected,
        p.amount_refunded,
        p.processed_at          as payment_processed_at,
        date_trunc('month', o.ordered_at)::date as order_month,
        date_trunc('week',  o.ordered_at)::date as order_week,
        extract(dow from o.ordered_at)          as order_day_of_week
    from orders o
    left join users    u  on u.user_id    = o.user_id
    left join order_agg oa on oa.order_id = o.order_id
    left join payments  p  on p.order_id  = o.order_id
)

select * from joined

with users as (
    select * from {{ ref('stg_users') }}
),

order_stats as (
    select
        user_id,
        count(*)                                            as lifetime_orders,
        count(*) filter (where order_status = 'delivered') as completed_orders,
        count(*) filter (where order_status in ('cancelled','refunded')) as cancelled_orders,
        sum(total_amount) filter (where order_status = 'delivered') as lifetime_value,
        min(ordered_at)                                     as first_order_at,
        max(ordered_at)                                     as last_order_at
    from {{ ref('int_orders_enriched') }}
    group by user_id
),

final as (
    select
        u.user_id,
        u.email,
        u.email_normalized,
        u.first_name,
        u.last_name,
        u.full_name,
        u.phone,
        u.city,
        u.country,
        u.engagement_status,
        u.created_at,
        u.last_login,
        coalesce(os.lifetime_orders, 0)     as lifetime_orders,
        coalesce(os.completed_orders, 0)    as completed_orders,
        coalesce(os.cancelled_orders, 0)    as cancelled_orders,
        coalesce(os.lifetime_value, 0)      as lifetime_value,
        os.first_order_at,
        os.last_order_at,
        case
            when os.lifetime_value >= 500   then 'vip'
            when os.lifetime_value >= 200   then 'loyal'
            when os.lifetime_value >= 50    then 'repeat'
            when os.lifetime_value > 0      then 'new'
            else 'prospect'
        end                                 as customer_segment,
        case
            when os.last_order_at >= now() - interval '90 days'  then 'active'
            when os.last_order_at >= now() - interval '365 days' then 'at_risk'
            when os.last_order_at is not null                     then 'churned'
            else 'never_purchased'
        end                                 as rfm_status
    from users u
    left join order_stats os on os.user_id = u.user_id
)

select * from final

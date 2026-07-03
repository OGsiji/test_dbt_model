-- Daily/weekly/monthly revenue roll-up for dashboards and API
with daily as (
    select
        order_month,
        order_week,
        ordered_at::date                                            as order_date,
        order_status,
        count(distinct order_id)                                    as orders,
        count(distinct user_id)                                     as unique_customers,
        sum(total_amount)                                           as gross_revenue,
        sum(amount_collected)                                       as net_revenue,
        sum(amount_refunded)                                        as refunds,
        sum(discount)                                               as total_discounts,
        sum(shipping_fee)                                           as total_shipping,
        sum(total_items)                                            as units_sold,
        avg(total_amount)                                           as avg_order_value,
        count(*) filter (where is_cancelled_or_refunded)            as cancelled_orders
    from {{ ref('fct_orders') }}
    group by 1, 2, 3, 4
)

select * from daily

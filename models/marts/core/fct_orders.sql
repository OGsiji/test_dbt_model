with enriched as (
    select * from {{ ref('int_orders_enriched') }}
),

final as (
    select
        order_id,
        user_id,
        full_name           as customer_name,
        email               as customer_email,
        city                as customer_city,
        country             as customer_country,
        order_status,
        total_amount,
        discount,
        shipping_fee,
        items_subtotal,
        total_items,
        line_count,
        payment_method,
        payment_status,
        amount_collected,
        amount_refunded,
        ordered_at,
        shipped_at,
        delivered_at,
        payment_processed_at,
        order_month,
        order_week,
        order_day_of_week,
        hours_to_ship,
        days_in_transit,
        is_cancelled_or_refunded
    from enriched
)

select * from final

with payments as (
    select * from {{ ref('stg_payments') }}
),

orders as (
    select
        order_id,
        user_id,
        order_status,
        total_amount,
        ordered_at,
        order_month,
        order_week
    from {{ ref('int_orders_enriched') }}
),

final as (
    select
        p.payment_id,
        p.order_id,
        o.user_id,
        p.payment_method,
        p.payment_status,
        p.currency,
        p.amount,
        p.amount_collected,
        p.amount_refunded,
        p.gateway_ref,
        p.processed_at,
        o.ordered_at,
        o.order_month,
        o.order_week,
        date_trunc('month', p.processed_at)::date  as payment_month,
        date_trunc('week',  p.processed_at)::date  as payment_week,
        case
            when p.payment_status = 'completed' then 'revenue'
            when p.payment_status = 'refunded'  then 'refund'
            when p.payment_status = 'failed'    then 'failed_attempt'
            else 'pending'
        end                                         as ledger_type
    from payments p
    left join orders o on o.order_id = p.order_id
)

select * from final

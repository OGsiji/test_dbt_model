-- Payment amount must match the order total (within $0.01 rounding)
select
    p.payment_id,
    p.order_id,
    p.amount        as payment_amount,
    o.total_amount  as order_total
from {{ ref('fct_payments') }} p
join {{ ref('fct_orders') }}   o on o.order_id = p.order_id
where abs(p.amount - o.total_amount) > 0.01

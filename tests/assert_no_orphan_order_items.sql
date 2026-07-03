-- Every order item must belong to a known order
select oi.order_item_id
from {{ ref('fct_order_items') }} oi
left join {{ ref('fct_orders') }} o on o.order_id = oi.order_id
where o.order_id is null

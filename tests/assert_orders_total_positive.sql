-- Orders should never have a negative total
select order_id, total_amount
from {{ ref('fct_orders') }}
where total_amount < 0

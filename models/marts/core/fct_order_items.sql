with items as (
    select * from {{ ref('stg_order_items') }}
),

orders as (
    select
        order_id,
        user_id,
        order_status,
        ordered_at,
        order_month,
        order_week
    from {{ ref('int_orders_enriched') }}
),

products as (
    select
        product_id,
        product_name,
        sku,
        category_id,
        category_name,
        unit_cost
    from {{ ref('dim_products') }}
),

final as (
    select
        i.order_item_id,
        i.order_id,
        i.product_id,
        o.user_id,
        p.product_name,
        p.sku,
        p.category_id,
        p.category_name,
        i.quantity,
        i.unit_price,
        i.line_total,
        coalesce(p.unit_cost, 0) * i.quantity   as cost_of_goods,
        i.line_total - coalesce(p.unit_cost, 0) * i.quantity as gross_profit,
        o.order_status,
        o.ordered_at,
        o.order_month,
        o.order_week
    from items i
    left join orders   o on o.order_id   = i.order_id
    left join products p on p.product_id = i.product_id
)

select * from final

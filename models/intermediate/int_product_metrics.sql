with products as (
    select * from {{ ref('stg_products') }}
),

categories as (
    select * from {{ ref('stg_categories') }}
),

sales as (
    select
        oi.product_id,
        count(distinct o.order_id)      as total_orders,
        sum(oi.quantity)                as total_units_sold,
        sum(oi.line_total)              as total_revenue,
        avg(oi.unit_price)              as avg_selling_price,
        min(o.ordered_at)               as first_sold_at,
        max(o.ordered_at)               as last_sold_at
    from {{ ref('stg_order_items') }} oi
    join {{ ref('stg_orders') }} o on o.order_id = oi.order_id
    where o.order_status not in ('cancelled', 'refunded')
    group by oi.product_id
),

review_agg as (
    select
        product_id,
        count(*)                                    as review_count,
        round(avg(rating)::numeric, 2)              as avg_rating,
        count(*) filter (where sentiment = 'positive')  as positive_reviews,
        count(*) filter (where is_verified)             as verified_reviews
    from {{ ref('stg_reviews') }}
    group by product_id
),

joined as (
    select
        p.product_id,
        p.product_name,
        p.sku,
        p.unit_price,
        p.unit_cost,
        p.gross_margin,
        p.margin_pct,
        p.stock_qty,
        p.is_active,
        c.category_id,
        c.category_name,
        coalesce(s.total_orders, 0)         as total_orders,
        coalesce(s.total_units_sold, 0)     as total_units_sold,
        coalesce(s.total_revenue, 0)        as total_revenue,
        s.avg_selling_price,
        s.first_sold_at,
        s.last_sold_at,
        coalesce(r.review_count, 0)         as review_count,
        r.avg_rating,
        coalesce(r.positive_reviews, 0)     as positive_reviews,
        coalesce(r.verified_reviews, 0)     as verified_reviews
    from products p
    left join categories c  on c.category_id    = p.category_id
    left join sales      s  on s.product_id     = p.product_id
    left join review_agg r  on r.product_id     = p.product_id
)

select * from joined

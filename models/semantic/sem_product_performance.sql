-- Product-level KPIs consumed by catalogue and search APIs
select
    product_id,
    product_name,
    sku,
    category_id,
    category_name,
    unit_price,
    unit_cost,
    margin_pct,
    stock_qty,
    stock_status,
    is_active,
    sales_tier,
    rating_tier,
    total_orders,
    total_units_sold,
    total_revenue,
    avg_selling_price,
    review_count,
    avg_rating,
    positive_reviews,
    verified_reviews,
    -- computed score for ranking (web/mobile use)
    round(
        coalesce(avg_rating, 0) * 20
        + least(total_units_sold, 200) * 0.3
        + case when stock_status = 'in_stock' then 10 else 0 end
    , 2)                            as relevance_score
from {{ ref('dim_products') }}
where is_active = true

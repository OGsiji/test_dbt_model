with pm as (
    select * from {{ ref('int_product_metrics') }}
),

final as (
    select
        product_id,
        product_name,
        sku,
        unit_price,
        unit_cost,
        gross_margin,
        margin_pct,
        stock_qty,
        is_active,
        category_id,
        category_name,
        total_orders,
        total_units_sold,
        total_revenue,
        avg_selling_price,
        first_sold_at,
        last_sold_at,
        review_count,
        avg_rating,
        positive_reviews,
        verified_reviews,
        case
            when total_units_sold >= 100  then 'bestseller'
            when total_units_sold >= 20   then 'popular'
            when total_units_sold >= 1    then 'slow_mover'
            else 'never_sold'
        end                             as sales_tier,
        case
            when avg_rating >= 4.5 then 'top_rated'
            when avg_rating >= 3.5 then 'well_rated'
            when avg_rating >= 2.5 then 'mixed'
            when avg_rating is not null then 'low_rated'
            else 'unrated'
        end                             as rating_tier,
        case
            when stock_qty = 0      then 'out_of_stock'
            when stock_qty <= 10    then 'low_stock'
            else 'in_stock'
        end                             as stock_status
    from pm
)

select * from final

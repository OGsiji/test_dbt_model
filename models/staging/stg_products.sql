with source as (
    select * from {{ source('ecommerce', 'products') }}
),

renamed as (
    select
        id                                          as product_id,
        category_id,
        name                                        as product_name,
        sku,
        description                                 as product_description,
        price                                       as unit_price,
        cost                                        as unit_cost,
        round(price - coalesce(cost, 0), 2)         as gross_margin,
        case
            when cost > 0 then round((price - cost) / price * 100, 2)
            else null
        end                                         as margin_pct,
        stock                                       as stock_qty,
        is_active,
        created_at
    from source
)

select * from renamed

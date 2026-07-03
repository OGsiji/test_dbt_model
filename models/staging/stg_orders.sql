with source as (
    select * from {{ source('ecommerce', 'orders') }}
),

renamed as (
    select
        id                              as order_id,
        user_id,
        status                          as order_status,
        total_amount,
        discount,
        shipping_fee,
        total_amount + discount - shipping_fee  as subtotal_before_shipping,
        created_at                      as ordered_at,
        shipped_at,
        delivered_at,
        case
            when shipped_at is not null
            then extract(epoch from (shipped_at - created_at)) / 3600
        end                             as hours_to_ship,
        case
            when delivered_at is not null and shipped_at is not null
            then extract(epoch from (delivered_at - shipped_at)) / 86400
        end                             as days_in_transit,
        case
            when status in ('cancelled', 'refunded') then true
            else false
        end                             as is_cancelled_or_refunded
    from source
)

select * from renamed

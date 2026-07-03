with source as (
    select * from {{ source('ecommerce', 'payments') }}
),

renamed as (
    select
        id                  as payment_id,
        order_id,
        method              as payment_method,
        status              as payment_status,
        amount,
        currency,
        processed_at,
        gateway_ref,
        case
            when status = 'completed' then amount
            else 0
        end                 as amount_collected,
        case
            when status = 'refunded' then amount
            else 0
        end                 as amount_refunded
    from source
)

select * from renamed

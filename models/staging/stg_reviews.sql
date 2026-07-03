with source as (
    select * from {{ source('ecommerce', 'reviews') }}
),

renamed as (
    select
        id          as review_id,
        product_id,
        user_id,
        rating,
        title       as review_title,
        body        as review_body,
        verified    as is_verified,
        created_at  as reviewed_at,
        case
            when rating >= 4 then 'positive'
            when rating = 3  then 'neutral'
            else 'negative'
        end         as sentiment
    from source
)

select * from renamed

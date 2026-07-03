with source as (
    select * from {{ source('ecommerce', 'categories') }}
),

renamed as (
    select
        id                          as category_id,
        name                        as category_name,
        slug                        as category_slug,
        description                 as category_description,
        created_at                  as created_at
    from source
)

select * from renamed

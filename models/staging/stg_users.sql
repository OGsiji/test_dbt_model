with source as (
    select * from {{ source('ecommerce', 'users') }}
),

renamed as (
    select
        id                                              as user_id,
        email,
        lower(email)                                    as email_normalized,
        first_name,
        last_name,
        first_name || ' ' || last_name                 as full_name,
        phone,
        city,
        country,
        created_at,
        last_login,
        case
            when last_login is null then 'never'
            when last_login >= now() - interval '30 days' then 'active'
            when last_login >= now() - interval '90 days' then 'warm'
            else 'dormant'
        end                                             as engagement_status
    from source
)

select * from renamed

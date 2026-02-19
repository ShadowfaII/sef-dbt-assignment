with source as (
    select * from {{ ref('users') }}
),

renamed as (
    select 
        user_id,
        signup_date,
        city
    from source
)

select * from renamed
with source as (
    select * from {{ ref('orders') }}
),

renamed as (
    select 
        order_id,
        user_id,
        order_date,
        amount,
        status as order_status
    from source
)

select * from renamed
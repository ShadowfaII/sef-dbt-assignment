with source as (
    select * from {{ ref('payments') }}
),

renamed as (
    select
        payment_id,
        order_id,
        payment_method,
        payment_status
    from source
)

select * from renamed
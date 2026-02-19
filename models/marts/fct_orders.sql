with orders as (
    select * from {{ ref('stg_orders') }}
),

users as (
    select * from {{ ref('stg_users') }}
),

payments as (
    select * from {{ ref('stg_payments') }}
),

final as (
    select  
        orders.order_id,
        orders.order_date,
        orders.amount,
        orders.order_status,

        users.user_id,
        users.city,

        payments.payment_id,
        payments.payment_method,
        payments.payment_status

    from orders
    left join users on orders.user_id = users.user_id
    left join payments on orders.order_id = payments.order_id
)

select * from final
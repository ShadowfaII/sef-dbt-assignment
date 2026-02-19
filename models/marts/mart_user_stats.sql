with orders as (
    select * from {{ ref('fct_orders') }}
)

select
    user_id,
    city,
    count(order_id) as total_orders_placed,
    sum(amount) as lifetime_value,
    max(order_date) as last_order_date
from orders
group by 1, 2
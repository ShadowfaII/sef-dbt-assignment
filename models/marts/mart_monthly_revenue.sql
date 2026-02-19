with orders as (
    select * from {{ ref('fct_orders') }}
)

select 
    city,
    sum(amount) as total_revenue,
    count(order_id) as total_orders
from orders
where order_status = 'completed'
group by 1
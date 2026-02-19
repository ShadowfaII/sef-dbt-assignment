with orders as (
    select * from {{ ref('fct_orders') }}
)

select
    city,
    sum(amount) as total_revenue,
    count(order_id) as total_orders,
    round(avg(amount), 2) as avg_order_value
from orders
where order_status = 'completed'
group by 1
order by total_revenue desc
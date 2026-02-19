with orders as (
    select * from {{ ref('fct_orders') }}
)

select
    user_id,
    city,
    
    count(order_id) as total_orders,
    
    count(case when order_status = 'completed' then order_id end) as completed_orders,
    count(case when order_status = 'refunded' then order_id end) as refunded_orders,
    
    sum(case when order_status = 'completed' then amount else 0 end) as lifetime_value,
    
    max(order_date) as last_order_date
from orders
group by 1, 2
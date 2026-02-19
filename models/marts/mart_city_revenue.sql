with city_stats as (
    select
        city,
        count(case when order_status = 'completed' then 1 end) as orders_completed,
        sum(case when order_status = 'completed' then amount else 0 end) as revenue,
        count(case when order_status = 'refunded' then 1 end) as orders_refunded,
        sum(case when order_status = 'refunded' then amount else 0 end) as lost_revenue
    from {{ ref('fct_orders') }}
    group by 1
)

select * from city_stats
union all
select 'GRAND TOTAL', sum(orders_completed), sum(revenue), null, null from city_stats
union all
select 'LOST REVENUE', null, null, sum(orders_refunded), sum(lost_revenue) from city_stats
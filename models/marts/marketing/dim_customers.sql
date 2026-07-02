with customers as (

     select * from {{ ref('stg_jaffle_shop__customers') }}

),

orders as ( 

    select * from {{ ref('stg_jaffle_shop__orders') }}

),

customer_amounts as (

    select
        o.customer_id,
        sum(o.amount) as total_amount
    from {{ ref('fct_orders') }} as o
    group by o.customer_id  

),

customer_orders as (

    select
        o.customer_id,
        ca.total_amount,
        min(o.order_date) as first_order_date,
        max(o.order_date) as most_recent_order_date,
        count(o.order_id) as number_of_orders
    from orders as o
        left outer join customer_amounts as ca on o.customer_id = ca.customer_id
    group by o.customer_id,ca.total_amount

),



final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce (customer_orders.number_of_orders, 0) as number_of_orders,
        coalesce (customer_orders.total_amount, 0) as total_amount
    from customers

    left join customer_orders on customers.customer_id = customer_orders.customer_id

)

select * from final
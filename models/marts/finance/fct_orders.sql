with payment as (

     select * from {{ ref('stg_stripe__payments') }}

),

orders as ( 

    select * from {{ ref('stg_jaffle_shop__orders') }}

),

final as (

   select o.order_id,o.customer_id,
   sum(case when p.status = 'success' then p.amount end) as amount   
	from orders as o
		left outer join payment as p on
			o.order_id=p.order_id
    group by o.order_id,o.customer_id

)

select * from final
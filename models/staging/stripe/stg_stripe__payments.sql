select 
orderid as order_id
,paymentmethod
,status
,amount/100 as amount
from raw.stripe.payment
--Data Segmentation -> Grouping the data by specific range

--Making segments of products into cost range
with product_segments as(
Select
product_key,
product_name,
cost,
case when cost < 100 then 'Below 100'
	when cost between 100 and 500 then '100-500'
	when cost between 500 and 1000 then '500-1000'
	else 'Above 1000' 
End cost_range
from gold.dim_products)
Select
cost_range,
count(product_key) as no_of_products
from product_segments
group by cost_range;

--Grouping customers based on their spending behaviour
--If lifespan is at least 12 months and spendings are > 5000 then status is VIP
--If lifespan is at least 12 months and spendings are < 5000 then status is Regular
--For anything else status is New
with customer_behaviour as (
Select
c.customer_key,
SUM(s.sales_amount) as total_spending,
Datediff(month,min(s.order_date),max(s.order_date)) as lifespan,
case when Datediff(month,min(s.order_date),max(s.order_date)) >= 12
	 AND SUM(s.sales_amount) >5000 then 'VIP'
	 when Datediff(month,min(s.order_date),max(s.order_date)) >= 12
	 AND SUM(s.sales_amount) <=5000 then 'Regular'
	 else 'New' end as Customer_status
from gold.fact_sales s left join gold.dim_customers c on s.customer_key = c.customer_key
group by c.customer_key)
select 
Customer_status,
Count(Customer_status) as customeer_status
from customer_behaviour
group by Customer_status;

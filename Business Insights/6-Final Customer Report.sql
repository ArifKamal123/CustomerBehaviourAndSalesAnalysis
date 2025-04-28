--Building customer report
/*
================
-- BASE QUERY
=============== */
create view  gold.report_customers as
with base_query as (
Select
s.order_number,
s.product_key,
s.order_date,
s.sales_amount,
s.quantity,
s.customer_key,
c.customer_number,
Concat(c.first_name,' ',c.last_name) as customer_name,
datediff(year,c.birthdate,getdate()) as age
from gold.fact_sales s left join gold.dim_customers c on s.customer_key = c.customer_key)
,customer_aggregation as (
/*
================
Customer Aggregation: Summarizes key matrics at customer level
=============== */
select 
	customer_key,
	customer_number,
	customer_name,
	age,
	Count(distinct order_number) as total_orders,
	SUM(sales_amount) as total_sales,
	SUM(quantity) as total_quantity,
	Count(distinct product_key) as total_products,
	Max(order_date) as last_order_date,
	Datediff(month,min(order_date),max(order_date)) as lifespan
from base_query
group by
	customer_key,
	customer_number,
	customer_name,
	age)
SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
Case 
	 when age < 20 then 'Below 20'
	 when age between 20 and 29 then '20-29'
	 when age between 30 and 39 then '30-39'
	 when age between 40 and 49 then '40-49'
	 else '50 and Above	'
END as age_group,
Case 
	when lifespan >= 12 and total_sales > 5000 then 'VIP'
	when lifespan >= 12 and total_sales < 5000 then 'Regular'
	else 'New' 
END as customer_segment,
	last_order_date,
	datediff(month,last_order_date,getdate()) as recency,
	total_orders,
	total_sales,
	total_quantity,
	total_products,	
	lifespan,
Case
	when total_orders = 0 then 0
	else total_sales/total_orders
END as avg_order_value,
Case
	when lifespan = 0 then 0
	else total_sales / lifespan
end as avg_monthly_spendings
from customer_aggregation
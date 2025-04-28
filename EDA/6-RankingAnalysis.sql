--Ranking Analysis -> order the values of dimension by measuer- TOP N Performers|Bottom N Performers

--Top 5 Products with the highest revenue

Select TOP 5
p.product_name,
Sum(s.sales_amount) RevenueGenerated
from gold.fact_sales s left join gold.dim_products p on s.product_key = p.product_key
group by p.product_name
order by RevenueGenerated DESC
;

--5 worst performing products in terms of sales
Select TOP 5
p.product_name,
Sum(s.sales_amount) RevenueGenerated
from gold.fact_sales s left join gold.dim_products p on s.product_key = p.product_key
group by p.product_name
order by RevenueGenerated ;

--Top 5 sub  categories with the highest revenue

Select TOP 5
p.subcategory,
Sum(s.sales_amount) RevenueGenerated
from gold.fact_sales s left join gold.dim_products p on s.product_key = p.product_key
group by p.subcategory
order by RevenueGenerated DESC
;

--5 worst performing subcategories in terms of sales
Select TOP 5
p.subcategory,
Sum(s.sales_amount) RevenueGenerated
from gold.fact_sales s left join gold.dim_products p on s.product_key = p.product_key
group by p.subcategory
order by RevenueGenerated ;

--Top 10 Customers with the highest revenue

Select TOP 10
c.first_name,
Sum(s.sales_amount) RevenueGenerated
from gold.fact_sales s left join gold.dim_customers c on s.customer_key = c.customer_key
group by c.first_name
order by RevenueGenerated DESC
;

-- 3 customers with lowest orders placed
Select top 3
c.first_name,
Count(distinct s.order_number) as total_orders
from gold.fact_sales s 
Left join gold.dim_customers c 
on s.customer_key = c.customer_key
group by c.first_name
order by total_orders;

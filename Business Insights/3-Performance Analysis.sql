--Performance Analysis ->comparing the current value to target value

--Analyzing the yearly performance of products by comparing their sales
-- to both the average sales performance of the product and the previous yearly sales
with yearly_product_sales AS (
Select 
Year(s.order_date) order_year,
p.product_name,
SUM(sales_amount) as current_sales
from gold.fact_sales s 
left join gold.dim_products p on s.product_key = p.product_key
where year(s.order_date) is not null
group by year(s.order_date),p.product_name
)
Select order_year,
product_name,
current_sales,
AVG(current_sales) over(partition by product_name) as avg_sales,
current_sales - avg(current_sales) over(partition by product_name) as avg_diff,
Case
	when current_sales - avg(current_sales) over(partition by product_name) > 0 then 'Above Avg'
	when current_sales - avg(current_sales) over(partition by product_name) < 0 then 'Below Avg'
	else 'Avg'
End as avg_change,
--Year-by-year analysis
Lag(current_sales) over(partition by product_name order by order_year) as prev_year,
current_sales - Lag(current_sales) over(partition by product_name order by order_year) as diff_py,
Case
	when current_sales - Lag(current_sales) over(partition by product_name order by order_year) > 0 then 'Increasing'
	when current_sales - Lag(current_sales) over(partition by product_name order by order_year) < 0 then 'Decreasing'
	else 'No Change'
End as py_change
from yearly_product_sales;
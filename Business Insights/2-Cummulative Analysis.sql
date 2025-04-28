--Cummulative Analysis -> Aggregating data over time

--Calculating sales over month and the running total of sales over time

Select
order_date,
total_sales,
Sum(total_sales) over(partition by order_date order by order_date) as running_total
from
(
Select 
DATETRUNC (month,order_date) as order_date,
Sum(sales_amount) as total_sales
from gold.fact_sales
where order_date is not null
group by DATETRUNC(month,order_date)) t


--Moving Averages of the price
Select
order_date,
avg_price,
Avg(avg_price) over(partition by order_date order by order_date) as moving_average_price
from
(
Select 
DATETRUNC (month,order_date) as order_date,
avg(price) as avg_price
from gold.fact_sales
where order_date is not null
group by DATETRUNC(month,order_date)) t
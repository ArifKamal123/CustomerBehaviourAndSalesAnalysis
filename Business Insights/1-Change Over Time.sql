--Changes Over Time Analytics -> Analyze measure over time

--Calculating Sales over time (Yearly) with different attributes 

Select Year(order_date) as YearNo,
Sum(sales_amount) as total_sales,
COUNT(Distinct customer_key) as Total_Customers,
Sum(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by Year(order_date)
order by Year(order_date); --2013 is the best sales year

--Monthly

Select 
DATETRUNC(Month,order_date) as order_date,
Sum(sales_amount) as total_sales,
COUNT(Distinct customer_key) as Total_Customers,
Sum(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by DATETRUNC(Month,order_date)
order by DATETRUNC(Month,order_date); --December is the best sales Month and feb is the worst



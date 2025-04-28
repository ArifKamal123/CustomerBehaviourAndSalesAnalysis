--Measures Exploration

--Finding the total sales

Select SUM(sales_amount) as TotalSales
from gold.fact_sales;

--Total items sold
Select SUM(quantity) as TotalItemsSold
from gold.fact_sales;

--Finding the average selling price
SELECT AVG(price) as Average_Price FROM gold.fact_sales;

--Finding totat number of orders

SELECT COUNT(order_number) as TotalOrders FROM gold.fact_sales;
--But if we look at the distinct orders we get a different number
SELECT Count(distinct order_number) as Total_Orders FROM gold.fact_sales;
--Lets check
select * from gold.fact_sales; -- We see that an order containing multiple items has been spread out to the number 
--items in the order. It means the correct way to identify total orders is to use distinct

--Finding the total number of customers
Select Count(customer_key) as total_customers from gold.dim_customers;

--Finding the total number of customers that has placed an order
Select Count(distinct c.customer_key) as Total_customers from gold.dim_customers c 
join gold.fact_sales s on c.customer_key = s.customer_key
where s.order_number is not null; --Matches the above query means that our every customer has placed at least one order

--Generating Report
Select 'Total_Sales' as measure_name, SUM(sales_amount) as measure_value
from gold.fact_sales
UNION ALL
Select 'Total_Items_Sold' as measure_name,SUM(quantity) as measure_value
from gold.fact_sales
UNION ALL
Select 'Average Selling Price' as measure_name, AVG(price) as measure_value
FROM gold.fact_sales
UNION ALL
Select 'Total_Orders' as measure_name, Count(distinct order_number) as measure_value
FROM gold.fact_sales
UNION ALL
Select 'Total_Customers' as measure_name, Count(customer_key) as measure_name 
from gold.dim_customers
UNION ALL
Select 'Total Nr Products' as measure_name, 
Count(distinct product_name) as measure_value 
from gold.dim_products
;








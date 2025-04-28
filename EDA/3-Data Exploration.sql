--Date Exploration

--Identifying the first and last order dates

select min(order_date) as first_order_date,

	max(order_date) as last_order_date,
	
	DATEDIFF(year,min(order_date),max(order_date)) as YearOfSales

		from gold.fact_sales;

--Finding the youngest and oldest customers
select Datediff(YEAR,min(birthdate),getdate()) as YoungestCustomer,

	datediff(year,max(birthdate),GETDATE()) as OldestCustomer

		from gold.dim_customers;
--Data Exploration

--Explore Objects
select * from INFORMATION_SCHEMA.TABLES;

--Explore Columns
select * from INFORMATION_SCHEMA.COLUMNS;

--Checking specific objects
select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'dim_customers'

select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'dim_products'

select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'fact_sales'
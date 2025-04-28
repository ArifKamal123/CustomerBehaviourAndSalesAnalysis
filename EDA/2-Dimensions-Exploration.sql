--Dimension Exploration -> identifying unique values or categories to recognize how data can be grouped or segmented


-- Checking customer territories
Select distinct country from gold.dim_customers;  -- Customers come from six different countries

-- Checking all the categories (Major Divisions or categories)

select distinct category from gold.dim_products -- We have 4 major categories

-- Checking all the categories (Sub Divisions or categories)

select distinct subcategory from gold.dim_products -- We have 36 sub categories

--Exploring further categories
select distinct category,subcategory,product_name 
from gold.dim_products
order by 1,2,3;   --Total Products are 295



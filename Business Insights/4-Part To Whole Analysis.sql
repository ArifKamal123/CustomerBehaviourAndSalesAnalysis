--Part to whole analysis

With category_sales as (
Select
category,
SUM(sales_amount) as total_sales
from gold.fact_sales f left join gold.dim_products p  on  p.product_key= f.product_key
group by category)
select
category,
total_sales,
Sum(total_sales) over() as overall_sales,
Concat(ROUND(Cast(total_sales as float) / SUM(total_sales)over()*100,2),'%') Pct
from category_sales
order by pct desc;
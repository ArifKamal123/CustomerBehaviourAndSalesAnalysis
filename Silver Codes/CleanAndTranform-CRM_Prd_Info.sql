--Cleaning and tranforming prd_info
Select 
prd_id,
prd_key,
prd_cost,
prd_line,
prd_nm,
prd_start_dt,
prd_end_dt
from bronze.crm_prd_info

--Checking for nulls and duplicates in Primary key
select prd_id,
count(*)
from bronze.crm_prd_info
group by prd_id
having count(*) > 1 or prd_id is null; -- prd_id is fine


--Adding Category Id
--Checking the Cat_id from the px_cat
select distinct id from bronze.erp_px_cat_g1v2; --Shows that the id is the first five characters from the prd_key
--Also the id contains _ separation unlike prd_key where - is used for separation


--Checking for white spaces in prd_nm
select prd_nm
from bronze.crm_prd_info
where prd_nm != TRIM(prd_nm); --Fine

--Checking for nulls and negative numbers in Cost column
select prd_cost
from bronze.crm_prd_info
where prd_cost < 0 or prd_cost is null; --We have nulls but not negative values

--Checking the prd_start and end date
--Checking invalid orders
select *
from bronze.crm_prd_info
where prd_end_dt < prd_start_dt; -- We got the end date older than the start date for some products





--Tranformation and inserting
insert into silver.crm_prd_info (
prd_id,
cat_id,
prd_key,
prd_cost,
prd_line,
prd_nm,
prd_start_dt,
prd_end_dt
)
Select 
prd_id,
Replace(SUBSTRING(prd_key,1,5),'-','_') as cat_id, --Extracting the cat_id.
SUBSTRING(prd_key,7,Len(prd_key)) as prd_key, --Extracting product key for sales details
ISNULL(prd_cost,0) as prd_cost,
Case UPPER(Trim(prd_line))
	 When 'M' Then 'Mountain'
	 When 'R' Then 'Road'
	 When 'S' Then 'Other Sales'
	 When 'T' Then 'Touring'
	 Else 'n/a'
END as prd_line,
prd_nm,
Cast(prd_start_dt as Date) as prd_start_dt,
--To fix the end and start dates we simply makes the prd_start_date of the next product the prd_end_dt of the current and subtract 1
-- to make it less than the prd_start_dt of the next prdct
--Also leave the nulls in the end date as the product is still in use
Lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)-1 as prd_end_dt 
from bronze.crm_prd_info

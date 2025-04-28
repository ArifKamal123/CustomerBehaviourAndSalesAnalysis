--Data Cleaning and Transformation cust_info
--Check for nulls and duplicates in primary key
--Expectation: No Result

select 
cst_id,
count(*)
from bronze.crm_cust_info
group by cst_id
having count(*) > 1 OR cst_id is NULL;
--We got duplicate for cst_id which means it is not unique and also containing nulls

--Rank the duplicate records from latest to oldest for cst_id 29466
Select *,
ROW_NUMBER() over(partition by cst_id order by cst_create_date desc) as Flag_Last
from bronze.crm_cust_info
where cst_id =29466
;

--Check for Unwanted spaces
select cst_firstname
from bronze.crm_cust_info
where cst_firstname != Trim(cst_firstname); --List all those firstnames with white spaces either at the end or the start

select cst_lastname
from bronze.crm_cust_info
where cst_lastname != Trim(cst_lastname); 



select cst_gndr
from bronze.crm_cust_info
where cst_gndr != Trim(cst_gndr); --No extra spaces

--Tranformations
Insert into silver.crm_cust_info
(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_gndr,
	cst_marital_status,
	cst_create_date
)
Select 
cst_id,
cst_key,
TRIM(cst_firstname) as cst_firstname,
TRIM(cst_lastname) as cst_lastname,
Case when Upper(Trim(cst_gndr)) = 'M' then 'Male'
	when Upper(Trim(cst_gndr)) = 'F' then 'Female'  
	else 'n/a'    --Converting M and F to meaningful name and 'n/a' for null (just an assumption for project requirements)
END cst_gndr,
Case when Upper(Trim(cst_marital_status)) = 'M' then 'Married'
	when Upper(Trim(cst_marital_status)) = 'S' then 'Single'  
	else 'n/a'    --Converting M and F to meaningful name and 'n/a' for null (just an assumption for project requirements)
END cst_marital_status,
cst_create_date
from 
(
	Select *,
	row_number() over(partition by cst_id order by cst_create_date desc) as Flag_Last
	from bronze.crm_cust_info
	where cst_id is not null --Removing the nulls from cst_id
) t  where Flag_Last = 1 --Removing Duplicates by selecting the latest value


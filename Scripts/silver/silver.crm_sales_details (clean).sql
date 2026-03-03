/*
-- Description: Quality Assurance suite for Sales data. 
-- Purpose: Identifies records failing business rules before/after Silver transformation.

*/
-- Key Formatting (Trailing spaces)
select *
from bronze.crm_sales_details
where sls_ord_num != trim(sls_ord_num)   

select *
from bronze.crm_sales_details
where sls_cust_id  not in (
select cst_id
from silver.crm_cust_info
) 

-- Temporal Logic (Logical date sequences)

select 
nullif(sls_due_dt,0) sls_due_dt
from bronze.crm_sales_details
where sls_due_dt<=0 
or len(sls_due_dt) != 8
or sls_due_dt>20500101
or sls_due_dt<19000101


select *
from bronze.crm_sales_details
where sls_order_dt>sls_ship_dt or sls_order_dt>sls_due_dt

--  Calculation Accuracy (Sales/Price/Quantity mismatch)

select sls_sales as sls_sales_old,
case
when sls_sales is null or sls_sales<=0 or sls_sales != sls_quantity* abs(sls_price) 
then sls_quantity* abs(sls_price)
else sls_sales
end sls_sales,
sls_quantity,
sls_price as sls_price_old,
case
when sls_price is null or sls_price<=0 
then sls_sales/ nullif(sls_quantity,0)
else sls_price
end sls_price
from bronze.crm_sales_details
where sls_sales != sls_quantity* sls_price
or sls_price is null or sls_quantity is null or sls_sales is null
or sls_price<=0 or sls_quantity<=0 or sls_sales<=0
order by sls_price,sls_sales,sls_quantity

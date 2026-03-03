/*
-- Description: Cleanses ERP Customer data (AZ12) for the Silver Layer.
-- Source System: ERP_AZ12
*/
-- Remove prefix if present
select 
case
when cid like 'NAS%' then substring(cid,4,len(cid))
else cid
end cid,
BDATE,
GEN
from bronze.erp_cust_az12

--Identify Out Of Range Date--

select BDATE
FROM silver.erp_cust_az12
WHERE BDATE > GETDATE()

-- Normalize gender values
select
gen,
case 
when upper(trim(gen)) in('F','Female') then 'Female'
when upper(trim(gen)) in('M','Male') then 'Male'
else 'n/a'
end GEN
from bronze.erp_cust_az12



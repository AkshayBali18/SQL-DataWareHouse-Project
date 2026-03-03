/*
-- Description: Standardizes ERP Location data (A101) for the Silver Layer.
-- Source: bronze.erp_loc_a101
-- Target: silver.erp_loc_a101
*/

insert into silver.erp_loc_a101(cid,CNTRY)


select replace(cid,'-','') cid,                          ---Compare PK=FK if not then match them---
case when CNTRY = 'DE' then 'Germany'
when trim(CNTRY) in('US','USA') then 'United States'
when trim(CNTRY) = '' or CNTRY is null then 'n/a'
else trim(CNTRY)                                         -- Normalize and Handle missing or blank country codes
end cntry
from
bronze.erp_loc_a101



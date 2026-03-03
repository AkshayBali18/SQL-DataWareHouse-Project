/*
-- Object Name: dim_products (View)
-- Description: Consolidated Products Master record merging CRM, ERP Tables.
*/
--Using Current Data(Removing Historic Data)
-- so selected only product end date are NULL
select prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt
from silver.crm_prd_info
where prd_end_dt is null

--Joining sutaible table which are connected
select prd_id,
pi.cat_id,
pi.prd_key,
pi.prd_nm,
pi.prd_cost,
pi.prd_line,
pi.prd_start_dt,
pc.cat,
pc.subcat,
pc.maintenance
from silver.crm_prd_info pi
left join silver.erp_px_cat_g1v2  pc
on pi.cat_id = pc.id
where prd_end_dt is null

--Checking No duplicate Primary Key 
select prd_key,count(*)
from(
select prd_id,
pi.cat_id,
pi.prd_key,
pi.prd_nm,
pi.prd_cost,
pi.prd_line,
pi.prd_start_dt,
pc.cat,
pc.subcat,
pc.maintenance
from silver.crm_prd_info pi
left join silver.erp_px_cat_g1v2  pc
on pi.cat_id = pc.id
where prd_end_dt is null
)t group by prd_key
having count(*)>1

--Normalizing Data(Giving Readable Names)
select 
prd_id as product_id,
pi.prd_key as product_number,
pi.prd_nm as product_name,
pi.cat_id as category_id,
pc.cat as category,
pc.subcat as subcategory,
pc.maintenance,
pi.prd_cost AS cost,
pi.prd_line AS product_line,
pi.prd_start_dt as start_date
from silver.crm_prd_info pi
left join silver.erp_px_cat_g1v2  pc
on pi.cat_id = pc.id
where prd_end_dt is null

--If Table is Dimension Category then make surrogate key
select 
row_number() over(order by pi.prd_start_dt,pi.prd_key) as product_key,
prd_id as product_id,
pi.prd_key as product_number,
pi.prd_nm as product_name,
pi.cat_id as category_id,
pc.cat as category,
pc.subcat as subcategory,
pc.maintenance,
pi.prd_cost AS cost,
pi.prd_line AS product_line,
pi.prd_start_dt as start_date
from silver.crm_prd_info pi
left join silver.erp_px_cat_g1v2  pc
on pi.cat_id = pc.id
where prd_end_dt is null

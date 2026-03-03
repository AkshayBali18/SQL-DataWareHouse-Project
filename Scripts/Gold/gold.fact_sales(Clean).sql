/*
-- Description: Final transformation for the Sales Fact table.
-- Source: silver.crm_sales_details
-- Dependencies: gold.dim_customer, gold.dim_products
*/
--Joining sutaible table which are connected

select sls_ord_num,
sls_cust_id,
sls_prd_key
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity ,
sls_price price
from silver.crm_sales_details sd
left join gold.dim_customer c
on sd.sls_cust_id=c.customer_id
left join gold.dim_products p
on sd.sls_prd_key=p.product_number
order by sls_ord_num

--Replace forien Key to Sarrogate Key from Joined Table
--
select ,
c.customer_key,--Sarrogate Key of customer view
p.product_key,--Sarrogate Key of product view
sls_order_dt ,
sls_ship_dt ,
sls_due_dt ,
sls_sales ,
sls_quantity ,
sls_price price
from silver.crm_sales_details sd
left join gold.dim_customer c
on sd.sls_cust_id=c.customer_id
left join gold.dim_products p
on sd.sls_prd_key=p.product_number
order by sls_ord_num
--Normalizing Data(Giving Readable Names)
select sls_ord_num as order_number,
c.customer_key,
p.product_key,
sls_order_dt as order_date,
sls_ship_dt as ship_date,
sls_due_dt as due_date,
sls_sales as sales,
sls_quantity as quantity,
sls_price price
from silver.crm_sales_details sd
left join gold.dim_customer c
on sd.sls_cust_id=c.customer_id
left join gold.dim_products p
on sd.sls_prd_key=p.product_number



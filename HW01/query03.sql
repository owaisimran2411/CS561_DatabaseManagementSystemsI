-- Query03
-- For each customer, find the "most favorite" product (the product that the customer
-- purchased the most) and the "least favorite" product (the product that the customer
-- purchased the least)

-- Calculate sales of each product, customer pair
with products_count_per_customer as (
	select
		cust, prod, sum(quant) as quant
	from
		sales
	group by
		cust, prod
),

-- get the min and max from each set of customer
min_max_cust as (
	select
		cust, min(quant) as min_prod, max(quant) as max_prod
	from
		products_count_per_customer
	group by
		cust
),

-- aggregating min count with cust table (least favourite product)
least_fav_prod as (
	select 
		pc.cust, pc.prod
	from
		products_count_per_customer as pc, min_max_cust as lf
	where
		pc.quant=lf.min_prod and pc.cust=lf.cust
),

-- aggregating max count with cust table (most favourite product)
most_fav_prod as (
	select 
		pc.cust, pc.prod
	from
		products_count_per_customer as pc, min_max_cust as mf
	where
		pc.quant=mf.max_prod and pc.cust=mf.cust
)

-- aggregating both products
select
	lf.cust as CUSTOMER,
	mf.prod as MOST_FAV_PROD,
	lf.prod as LEAST_FAV_PROD
from
	least_fav_prod as lf, most_fav_prod as mf
where
	lf.cust = mf.cust
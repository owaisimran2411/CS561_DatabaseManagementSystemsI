-- Query04
-- For each customer and product combination, show the average sales quantities for the
-- four seasons, Spring, Summer, Fall and Winter in four separate columns - Spring being
-- the 3 months of March, April and May; and Summer the next 3 months (June, July and
-- August); and so on - ignore the YEAR component of the dates (i.e., 10/25/2016 is
-- considered the same date as 10/25/2017, etc.). Additionally, compute the average for the
-- "whole" year (again ignoring the YEAR component, meaning simply compute AVG) along
-- with the total quantities (SUM) and the counts (COUNT)

-- fall sale average
with fall as (
	select
		ROUND(avg(quant)) as average,
		cust,
		prod,
		count(quant) as count,
		sum(quant) as sum
	from
		sales
	where month in (09, 10, 11)
	group by
		cust, prod
),
-- spring sale average
spring as (
	select
		ROUND(avg(quant)) as average,
		cust,
		prod,
		count(quant) as count,
		sum(quant) as sum
	from
		sales
	where month in (03, 04, 05)
	group by
		cust, prod
),
-- summer sale average
summer as (
	select
		ROUND(avg(quant)) as average,
		cust,
		prod,
		count(quant) as count,
		sum(quant) as sum
	from
		sales
	where month in (06, 07, 08)
	group by
		cust, prod
),
-- winter sale average
winter as (
	select
		ROUND(avg(quant)) as average,
		cust,
		prod,
		count(quant) as count,
		sum(quant) as sum
	from
		sales
	where month in (12, 01, 02)
	group by
		cust, prod
)

-- aggregating all tables
select
	su.cust as customer,
	su.prod as product,
	sp.average as spring_avg,
	su.average as summer_avg,
	fa.average as fall_avg,
	wi.average as winter_avg,
	(su.sum+wi.sum+sp.sum+fa.sum)/4 as total,
	(su.count+wi.count+sp.count+fa.count) as count 
from
	summer as su,
	winter as wi,
	spring as sp,
	fall as fa
where
	su.cust=wi.cust and su.cust=sp.cust and su.cust=fa.cust and
	wi.cust=sp.cust and wi.cust=fa.cust and
	sp.cust=fa.cust and
	su.prod=wi.prod and su.prod=wi.prod and su.prod=fa.prod and
	wi.prod=sp.prod and wi.prod=fa.prod and
	sp.prod=fa.prod
order by su.cust
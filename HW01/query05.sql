-- Query05
-- For each product, output the maximum sales quantities for each quarter in 4 separate
-- columns. Like the first report, display the corresponding dates (i.e., dates of those
-- corresponding maximum sales quantities). Ignore the YEAR component of the dates (i.e.,
-- 10/25/2016 is considered the same date as 10/25/2017, etc.).

-- getting total sales for each day
with dsales as (
	select
		prod,
		day,
		month,
		year,
		date,
		sum(quant) as dsale
	from
		sales
	group by
		day, month, year, prod, date
	order by year, month, day
),

-- max sale in q01
q01_max as (
	select
		prod,
		max(dsale) as max
	from
		dsales
	where 
		month=01 or month=02 or month=03
	group by
		prod
),

-- max sale in q02
q02_max as (
	select
		prod,
		max(dsale) as max
	from
		dsales
	where 
		month=04 or month=05 or month=06
	group by
		prod
),

-- max sale in q03
q03_max as (
	select
		prod,
		max(dsale) as max
	from
		dsales
	where 
		month=07 or month=08 or month=09
	group by
		prod
),

-- max sale in q04
q04_max as (
	select
		prod,
		max(dsale) as max
	from
		dsales
	where 
		month=10 or month=11 or month=12
	group by
		prod
),
-- aggregating all q sales for products
q as (
	select
		p.prod,
		p.max as q1,
		q.max as q2,
		r.max as q3,
		s.max as q4
	from
		q01_max as p,
		q02_max as q,
		q03_max as r,
		q04_max as s
	where
		p.prod=q.prod and p.prod=r.prod and p.prod=s.prod and
		q.prod=r.prod and q.prod=s.prod and
		r.prod=s.prod
),
-- getting date for q1 quant
q1 as (
	select
		l.prod,
		r.date as q1d,
		l.q1,
		l.q2,
		l.q3,
		l.q4
	from
		q as l, dsales as r
	where
		l.prod=r.prod and l.q1=r.dsale
),
-- getting date for q2 quant
q2 as (
	select
		l.prod,
		l.q1,
		l.q1d,
		l.q2,
		r.date as q2d,
		l.q3,
		l.q4
	from
		q1 as l, dsales as r
	where
		l.prod=r.prod and l.q2=r.dsale
),
-- getting date for q3 quant
q3 as (
	select
		l.prod,
		l.q1,
		l.q1d,
		l.q2,
		l.q2d,
		l.q3,
		r.date as q3d,
		l.q4
	from
		q2 as l, dsales as r
	where
		l.prod=r.prod and l.q3=r.dsale
)
-- getting date for q4 quant
select
	l.prod as product,
	l.q1 as q1_max,
	l.q1d as date,
	l.q2 as q2_max,
	l.q2d as date,
	l.q3 as q3_max,
	l.q3d as date,
	l.q4 as q4_max,
	r.date as date
from
	q3 as l, dsales as r
where
	l.prod=r.prod and l.q3=r.dsale
order by
	product
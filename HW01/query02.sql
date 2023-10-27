-- Query02
-- For each year and month combination, find the "busiest" and the "slowest" day (those
-- days with the most and the least total sales quantities of products sold) and the
-- corresponding total sales quantities (i.e., SUMs).

-- table with sales for each day, month, year combination
with dsales as (
	select 
		sum(quant)as sales,
		day,
		month,
		year,
		date
	from 
		sales
	group by
		day, month, year, date
	order by year, month, day
),

-- getting minimum and maximum sales for each month
b_s_days as (
	select
		min(sales) as s_day_sales,
		max(sales) as b_day_sales,
		month,
		year
	from
		dsales
	group by
		month, year
	order by year, month
),

-- aggregating slowest day info with b_s_days
s_day as (
	select 
		l.year,
		l.month,
		r.day,
		l.s_day_sales,
		l.b_day_sales
	from
		b_s_days as l, dsales as r
	where
		l.month=r.month and l.year=r.year and l.s_day_sales=r.sales
),

-- aggregating busiest_day info with b_s_days
b_day as (
	select
		l.year,
		l.month,
		r.day as busiest_day,
		l.b_day_sales as busiest_total_q,
		l.day as slowest_day,
		l.s_day_sales as slowest_total_q
	from
		s_day as l, dsales as r
	where
		l.month=r.month and l.year=r.year and l.b_day_sales=r.sales
)
select * from b_day
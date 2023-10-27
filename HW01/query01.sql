-- Query01
-- For each customer, compute the minimum and maximum sales quantities along with the
-- corresponding products (purchased), dates (i.e., dates of those minimum and maximum
-- sales quantities) and the states in which the sale transactions took place. If there are >1
-- occurrences of the min or max, display all.
-- For the same customer, compute the average sales quantity

-- getting min, max, avg for each product,customer pair
with min_max as (
	select
		cust,
		prod,
		min(quant) as min_q,
		max(quant) as max_q,
		avg(quant) as avg_q
	from
		sales
	group by 
		cust, prod
	order by cust
),

-- getting information of sales with min_quant
min_merg as (
	select
		r.cust,
		r.min_q,
		r.prod,
		l.date,
		l.state,
		r.avg_q,
		r.max_q
	from
		sales as l, min_max as r
	where
		l.cust=r.cust and l.quant=r.min_q
	order by cust
),

-- getting information of sales with max_quant
max_merg as (
	select
		l.cust as customer,
		l.min_q as min_q,
		l.prod as min_prod,
		l.date as min_date,
		l.state as st,
		l.max_q as max_q,
		r.prod as max_prod,
		r.date as max_date,
		r.state as st,
		l.avg_q as avg_q
	from
		sales as r, min_merg as l
	where
		r.cust=l.cust and r.quant=l.max_q
	order by customer
)

select * from max_merg
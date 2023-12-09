with avgs as (
	select
		cust, prod, state, round(avg(quant), 0) as cust_avg
	from
		sales
	group by
		cust, prod, state
	order by
		cust, prod, state
),
other_cust_avg as (
	select
		l.cust, l.prod, l.state, round(avg(r.quant), 0) as other_cust_avg
	from
		avgs l, sales r
	where 
		l.prod=r.prod and l.cust!=r.cust and l.state=r.state
	group by
		l.cust, l.prod, l.state
),
other_prod_avg as (
	select
		l.cust, l.prod, l.state, round(avg(r.quant), 0) as other_prod_avg
	from
		avgs l, sales r
	where 
		l.prod!=r.prod and l.cust=r.cust and l.state=r.state
	group by
		l.cust, l.prod, l.state
),
other_state_avg as (
	select
		l.cust, l.prod, l.state, round(avg(r.quant), 0) as other_state_avg
	from
		avgs l, sales r
	where
		l.prod=r.prod and l.cust=r.cust and l.state!=r.state
	group by
		l.cust, l.prod, l.state
)

select
	m.cust as customer, m.prod as product, m.state, m.cust_avg as product_avg, c.other_cust_avg, p.other_prod_avg, s.other_state_avg
from
	avgs m, other_cust_avg c, other_prod_avg p, other_state_avg s
where
	m.cust=c.cust and m.prod=c.prod and m.state=c.state and
	m.cust=p.cust and m.prod=p.prod and m.state=p.state and
	m.cust=s.cust and m.prod=s.prod and m.state=s.state and
	c.cust=p.cust and c.prod=p.prod and c.state=p.state and
	c.cust=s.cust and c.prod=s.prod and c.state=s.state and
	p.cust=s.cust and p.prod=s.prod and p.state=s.state
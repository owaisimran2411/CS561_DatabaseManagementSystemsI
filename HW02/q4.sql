with quant_pr_NJ as (
	select
		s.cust, s.prod, s.quant, s.date
	from
		sales s
	where
		s.state='NJ'
),
max_quant_per_cust as (
	SELECT s1.cust,
		MAX(s1.quant) AS first_max,
		MAX(s2.quant) AS second_max,
		MAX(s3.quant) AS third_max
	FROM quant_pr_NJ s1
	LEFT JOIN quant_pr_NJ s2 ON s1.cust = s2.cust AND s1.quant > s2.quant
	LEFT JOIN quant_pr_NJ s3 ON s2.cust = s3.cust AND s2.quant > s3.quant
	GROUP BY s1.cust
),

max_items as (
	select
		l.cust, r.quant, r.prod, r.date
	from
		max_quant_per_cust l, quant_pr_NJ r
	where
		l.cust=r.cust and (l.first_max=r.quant or l.second_max=r.quant or l.third_max=r.quant)
)

select
	cust as customer, quant as quantity, prod as product, date
from 
	max_items
order by cust, quant desc
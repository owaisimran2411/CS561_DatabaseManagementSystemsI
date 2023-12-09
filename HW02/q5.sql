with base as (
	select
		distinct prod, quant
	from
		sales
	order by prod, quant
),
pos as (
	select
		b.prod, b.quant, count(s.quant) as pos
	from
		base b
	left join
		sales s
	on 
		b.prod=s.prod and b.quant >= s.quant
	group by
		b.prod, b.quant
),
med_pos_t as (
	select
		s.prod, ceil(count(s.quant)/2) as med_pos
	from
		sales s 
	group by
		s.prod
	
),
med_pos as (
	select
		p.prod, min(p.pos) as med_pos
	from
		med_pos_t m, pos p
	where
		m.prod=p.prod and p.pos>=m.med_pos
	group by
		p.prod
),
t1 as (
	select
		l.prod, l.quant
	from
		pos l, med_pos r
	where
		l.prod=r.prod and l.pos>=r.med_pos
)

select
	t1.prod as product, min(t1.quant) as median_quant
from
	t1
group by
	t1.prod

drop table if exists months;
create table if not exists months (
	month integer
);
insert into months values (1);
insert into months values (2);
insert into months values (3);
insert into months values (4);
insert into months values (5);
insert into months values (6);
insert into months values (7);
insert into months values (8);
insert into months values (9);
insert into months values (10);
insert into months values (11);
insert into months values (12);

with before_m as (
	select 
		m1.month, m2.month before_mo
	from
		months m1
	left join
		months m2
	on
		m1.month-1 = m2.month
),
after_m as (
	select 
		m1.month, m2.month after_mo
	from
		months m1
	left join
		months m2
	on
		m1.month+1 = m2.month
),
month_c as (
	select
		c.month, b.before_mo, a.after_mo
	from
		before_m b, after_m a, months c
	where
		b.month=c.month and c.month=a.month
),
curr_avg as (
	select
		l.cust, l.prod, l.month, round(avg(l.quant)) as curr_avg
	from
		sales l
	group by
		l.cust, l.prod, l.month
	order by
		l.cust, l.prod, l.month
),
prev_avg as (
	select
		l.cust, l.prod, l.month, round(avg(l.quant)) as prev_avg
	from
		sales l, month_c r
	where
		l.month=r.before_mo
	group by
		l.cust, l.prod, l.month
	order by
		l.cust, l.prod, l.month
),
next_avg as (
	select
		l.cust, l.prod, l.month, round(avg(l.quant)) as next_avg
	from
		sales l, month_c r
	where
		l.month=r.after_mo
	group by
		l.cust, l.prod, l.month
	order by
		l.cust, l.prod, l.month
),
curr_prev_j as (
	select
		l.cust, l.prod, l.month, r.prev_avg, l.curr_avg
	from
		curr_avg l
	left join
		prev_avg r
	on
		l.cust=r.cust and l.prod=r.prod and l.month=r.month+1
),
curr_prev_next_j as (
	select
		l.cust, l.prod, l.month, l.prev_avg, l.curr_avg, r.next_avg
	from
		curr_prev_j l
	left join
		next_avg r
	on
		l.cust=r.cust and l.prod=r.prod and l.month=r.month-1
),
reference_t as (
	select 
		cust, prod, month, coalesce(prev_avg, 0) as prev_avg, curr_avg, coalesce(next_avg, 0) as next_avg
	from 
		curr_prev_next_j
),
final_output as (
	select
		l.cust as customer, l.prod as product, l.month as month, count(r.quant) as sales_count_between_avgs
	from
		reference_t l, sales r
	where
		r.month=r.month and
		(r.quant between l.prev_avg and l.next_avg) or (r.quant between l.next_avg and l.prev_avg)
	group by
		l.cust, l.prod, l.month
)
select * from final_output
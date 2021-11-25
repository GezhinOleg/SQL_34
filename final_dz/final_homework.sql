--1
/*� ����� ������� ������ ������ ���������?*/

/*
 * ��������� ������� ���������� �� ������ � ������ ������ ��, � ������� ���������� airport_code ������ 1
 */
select city "�����"
from airports
group by city 
having count(airport_code) > 1;

--2
/*� ����� ���������� ���� �����, ����������� ��������� � ������������ ���������� ��������?*/
-- - ���������
/*
 * ��������� �������� ��� �������� � ����� ������� ���������� (� ������� ���������� � ����������� ������).
 * ����� � �������� ������� ����������� ������� ������������ ��������.
 * �������� ������ �������� ��� ��������� �� ������ � �������� ��������
 */

select distinct 
	a.airport_name "��������"
from airports a  
join flights f on a.airport_code = f.departure_airport 
where f.aircraft_code = (
	select a.aircraft_code 
	from aircrafts a 
	order by a."range" desc limit 1
);

-- 3	������� 10 ������ � ������������ �������� �������� ������	- �������� LIMIT
/*
 * ������� ������ �� �����, ������� �������� (���� actual_departure ���������)
 * �������� ������������� � ������� ���������.
 * �������, ���������� �� �������� � ����������� ������
 */
select 
	f.flight_id,
	f.scheduled_departure,
	f.actual_departure,
	f.actual_departure - f.scheduled_departure "��������"
from flights f
where f.actual_departure is not null
order by "��������" desc
limit 10;

-- 4	���� �� �����, �� ������� �� ���� �������� ���������� ������?	- ������ ��� JOIN
/*
 * Left join, �.�. ����� ������ ��������� ������.
 * ������ ������� tickets �.�. ������� ������ ����������� � �������� ����� �����.
 */
select 
	case when count(b.book_ref) > 0 then '��'
	else '���'
	end "������� ������ ��� ��",
	count(b.book_ref) "�� ����������" 
from bookings b 
join tickets t on t.book_ref = b.book_ref 
left join boarding_passes bp on bp.ticket_no = t.ticket_no 
where bp.boarding_no is null;

-- 5	������� ��������� ����� ��� ������� �����, �� % ��������� � ������ ���������� ���� � ��������.
-- �������� ������� � ������������� ������ - ��������� ���������� ���������� ���������� ���������� �� ������� ��������� �� ������ ����. 
-- �.�. � ���� ������� ������ ���������� ������������� ����� - ������� ������� ��� �������� �� ������� ��������� �� ���� ��� ����� ������ ������ �� ����.	
-- - ������� �������
-- - ���������� ��� cte
/*
 * CTE boarded �������� ���������� �������� ���������� ������� �� ������� �����
 * ����������� actual_departure is not null ��� ����, ����� ����������� ��� ���������� �����
 * CTE max_seats_by_aircraft �������� ���������� ���� � �������
 * � �������� ������� ��� CTE ��������� �� aircraft_code
 * ��� �������� ������������� ����� ����������� ������� ������� c ����������� �� ��������� ����������� � ������� ������ ������������ � ������� date. 
 */
with boarded as (
	select 
		f.flight_id,
		f.flight_no,
		f.aircraft_code,
		f.departure_airport,
		f.scheduled_departure,
		f.actual_departure,
		count(bp.boarding_no) boarded_count
	from flights f 
	join boarding_passes bp on bp.flight_id = f.flight_id 
	where f.actual_departure is not null
	group by f.flight_id 
),
max_seats_by_aircraft as(
	select 
		s.aircraft_code,
		count(s.seat_no) max_seats
	from seats s 
	group by s.aircraft_code 
)
select 
	b.flight_no,
	b.departure_airport,
	b.scheduled_departure,
	b.actual_departure,
	b.boarded_count,
	m.max_seats - b.boarded_count free_seats, 
	round((m.max_seats - b.boarded_count) / m.max_seats :: dec, 2) * 100 free_seats_percent,
	sum(b.boarded_count) over (partition by (b.departure_airport, b.actual_departure::date) order by b.actual_departure) "������������ ����������"
from boarded b 
join max_seats_by_aircraft m on m.aircraft_code = b.aircraft_code;

-- 6	������� ���������� ����������� ��������� �� ����� ��������� �� ������ ����������.	- ���������
-- - �������� ROUND
/*
 * ������������ ��������� ��� ��������� ������ ����� ������� (���������, ������� �� ������� ��� ��������)
 * � �������� ������� ������������ ����������� �� ���� model
 */
select 
	a.model "������ ��������",
	count(f.flight_id) "���������� ������",
	round(count(f.flight_id) /
		(select 
			count(f.flight_id)
		from flights f 
		where f.actual_departure is not null
		)::dec * 100, 4) "� ��������� �� ������ �����"
from aircrafts a 
join flights f on f.aircraft_code = a.aircraft_code 
where f.actual_departure is not null
group by a.model;

-- 7	���� �� ������, � ������� �����  ��������� ������ - ������� �������, ��� ������-������� � ������ ��������?	
-- - CTE
/*
 * � CTE prices ���������� ��������� ������� �� ����: ������������ ��� ������� � ����������� ��� �������.
 * ����� �� ���� ���������� ��� ��������� � ������������ � ���� ������ �� ������� ��������� - ��� �������
 * CTE eco_busi. ���������� ����������� �� ��������� ����� b_min_amount � e_max_amount
 * ����� ���� CTE ��������� � ��������� ������ � ����������, ����� ������� �� ��� ������ ����������� � ��������.
 * ���� �� ����, ��� ��������� ������, ����� ������ ���
 */
with eco_busi as (
	with prices as(
		select  
			f.flight_id,
			case when tf.fare_conditions  = 'Business' then min(tf.amount) end b_min_amount,
			case when tf.fare_conditions  = 'Economy' then max(tf.amount) end e_max_amount
		from ticket_flights tf 
		join flights f on tf.flight_id = f.flight_id 
		group by 
			f.flight_id, tf.fare_conditions
	)
	select 
		p.flight_id,
		min(p.b_min_amount),
		max(p.e_max_amount)
	from prices p
		group by p.flight_id
	having min(p.b_min_amount) < max(p.e_max_amount)
	)
select 
	e.flight_id,
	a.city depatrure_city,
	a2.city arrival_city
from eco_busi e 
join flights f on e.flight_id = f.flight_id 
join airports a on f.departure_airport = a.airport_code
join airports a2 on f.arrival_airport = a2.airport_code

/*
 * ���� ������� ������� ��������� ������ ����� �������� ��� ����� �����
 * CTE max_min_by_city ��������� ����������� ��������� �� ������ ������ � ������������ �� �������
 * � ������������ �� ������ ����������� � �������� � �� ������ ������.
 * ���������� ��� ������������ �� ������� ������, ������� �������� ������� � �������� �� ���� �������
 * � ���� ������. � �������� ������� ��������� ������ �� ������, � ������� min(b_min_amount) < max(e_max_amount).
 * ����� ����� ���, ��� ��� � � ���� ������ ������ ������ ������ �������
 */
with max_min_by_city as(
	select 
		a.city dep_city,
		a2.city arr_city,
		tf.fare_conditions,
		case when tf.fare_conditions  = 'Business' then min(tf.amount) end b_min_amount,
		case when tf.fare_conditions  = 'Economy' then max(tf.amount) end e_max_amount
	from flights f 
	join ticket_flights tf on tf.flight_id = f.flight_id 
	join airports a on f.departure_airport = a.airport_code
	join airports a2 on f.arrival_airport = a2.airport_code
	group by (1, 2), 3
)
select 
	dep_city "��", 
	arr_city "�", 
	min(b_min_amount) "������� �� ������", 
	max(e_max_amount) "�������� �� ������"
from max_min_by_city
group by (1, 2)
having min(b_min_amount) < max(e_max_amount);

-- 8	����� ������ �������� ��� ������ ������?	
-- - ��������� ������������ � ����������� FROM
-- - �������������� ��������� �������������
-- - �������� EXCEPT
/*
 * ������ ������������� ��� ��������� �������, ����� �������� ���� �����
 * ��� ������ � ������������� ��� ��������� ������ ����������� � ������ ��������
 * � �������� ������� ������� ��������� ������������ ���� �������, � �������� �� �����������
 * ����� �� ���� ������ ������, ������� ���� � �������������.
 */
create view dep_arr_city as
select distinct 
	a.city departure_city,
	a2.city arrival_city
from flights f 
join airports a on f.departure_airport = a.airport_code 
join airports a2 on f.arrival_airport = a2.airport_code;

select distinct 
	a.city departure_city,
	a2.city arrival_city 
from airports a, airports a2 
where a.city != a2.city
except 
select * from dep_arr_city

-- 9	��������� ���������� ����� �����������, ���������� ������� �������, �������� � ���������� ������������ ���������� ���������  
-- � ���������, ������������� ��� ����� *	- �������� RADIANS ��� ������������� sind/cosd
-- - CASE 
/*
 * ����� ��� ���� ����� ������� ����������.
 * ���� "�������?" ����������� �� ������� ����, ��� ������������ ��������� ����� �������� ������ ��������� ��������.
 * ���������� ����� �������� ����� �� ������� �� ������� �� ����� ����������� �� ����
 */
select distinct 
	ad.airport_name "��",
	aa.airport_name "�",
	a."range" "��������� ��������",
	round((acos(sind(ad.latitude) * sind(aa.latitude) + cosd(ad.latitude) * cosd(aa.latitude) * cosd(ad.longitude - aa.longitude)) * 6371)::dec, 2) "����������",		
	case when 
		a."range" <
		acos(sind(ad.latitude) * sind(aa.latitude) + cosd(ad.latitude) * cosd(aa.latitude) * cosd(ad.longitude - aa.longitude)) * 6371 
		then '���!'
		else '��!'
		end "�������?"
from flights f
join airports ad on f.departure_airport = ad.airport_code
join airports aa on f.arrival_airport = aa.airport_code
join aircrafts a on a.aircraft_code = f.aircraft_code 

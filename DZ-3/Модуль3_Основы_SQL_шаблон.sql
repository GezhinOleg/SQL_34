--=============== ������ 3. ������ SQL =======================================
--= �������, ��� ���������� ���������� ������ ���������� � ������� ����� PUBLIC===========
SET search_path TO public;

--======== �������� ����� ==============

--������� �1
--�������� ��� ������� ���������� ��� ����� ����������, 
--����� � ������ ����������.

SELECT c.first_name || ' ' || c.last_name "customer", address.address, city.city, country.country
FROM customer
JOIN address USING(address_id)
JOIN city USING(city_id)
INNER JOIN country ON country.country_id = city.country_id

--������� �2
--� ������� SQL-������� ���������� ��� ������� �������� ���������� ��� �����������.

SELECT s.store_id, 
	count(c.customer_id) "customer_count"
FROM customer c
INNER JOIN store s using(store_id)
GROUP BY s.store_id ;


--����������� ������ � �������� ������ �� ��������, 
--� ������� ���������� ����������� ������ 300-��.
--��� ������� ����������� ���������� �� ��������������� ������� 
--� �������������� ������� ���������.

SELECT store.store_id, count(customer.customer_id)  "customer_count"
FROM customer
INNER JOIN store using(store_id)
GROUP BY store.store_id 
HAVING COUNT(customer.customer_id) >300;


-- ����������� ������, ������� � ���� ���������� � ������ ��������, 
--� ����� ������� � ��� ��������, ������� �������� � ���� ��������.

SELECT s.store_id, c2.city, s2.first_name || ' ' || s2.last_name "manager", COUNT(customer_id)
FROM customer c
INNER JOIN store s using(store_id)
INNER JOIN address a on a.address_id = s.address_id 
INNER JOIN city c2 on c2.city_id = a.city_id
INNER JOIN staff s2 on s.manager_staff_id = s2.staff_id 
GROUP BY  1, 2, 3
HAVING COUNT(c.customer_id) >300;





--������� �3
--�������� ���-5 �����������, 
--������� ����� � ������ �� �� ����� ���������� ���������� �������

SELECT count(r.rental_id), c.first_name ||' ' || c.last_name "customer"
FROM rental r 
INNER JOIN customer c using(customer_id)
GROUP BY r.customer_id, 2
ORDER BY COUNT(r.rental_id) DESC
LIMIT 5



--������� �4
--���������� ��� ������� ���������� 4 ������������� ����������:
--  1. ���������� �������, ������� �� ���� � ������
--  2. ����� ��������� �������� �� ������ ���� ������� (�������� ��������� �� ������ �����)
--  3. ����������� �������� ������� �� ������ ������
--  4. ������������ �������� ������� �� ������ ������

SELECT c.first_name || ' ' || c.last_name "customer_name",
	COUNT(r.rental_id),
	SUM(p.amount),
	MIN(p.amount),
	MAX(p.amount)
FROM customer c 
LEFT JOIN rental r using(customer_id)
LEFT JOIN payment p using(customer_id)
GROUP BY c.customer_id;

--������� �5
--��������� ������ �� ������� ������� ��������� ����� �������� ������������ ���� ������� ����� �������,
 --����� � ���������� �� ���� ��� � ����������� ���������� �������. 
 --��� ������� ���������� ������������ ��������� ������������.
 
SELECT c.city, c2.city 
FROM city c 
CROSS JOIN city c2
WHERE c.city_id != c2.city_id;



--������� �6
--��������� ������ �� ������� rental � ���� ������ ������ � ������ (���� rental_date)
--� ���� �������� ������ (���� return_date), 
--��������� ��� ������� ���������� ������� ���������� ����, �� ������� ���������� ���������� ������.
 
SELECT c.first_name || ' ' || c.last_name customer_name,
	avg(r.return_date::date - r.rental_date::date) avg_days
FROM rental r 
INNER JOIN customer c USING(customer_id)
GROUP BY c.customer_id 
ORDER BY customer_name;



--======== �������������� ����� ==============

--������� �1
--���������� ��� ������� ������ ������� ��� ��� ����� � ������ � �������� ����� ��������� ������ ������ �� �� �����.

SELECT   f.title,
	COUNT(r.rental_id),
	SUM(p.amount) 
FROM rental r 
INNER JOIN inventory i USING(inventory_id)
INNER JOIN film f ON i.film_id = f.film_id
INNER JOIN payment p ON p.rental_id = r.rental_id 
GROUP BY f.film_id;







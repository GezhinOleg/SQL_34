--=============== МОДУЛЬ 3. ОСНОВЫ SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите для каждого покупателя его адрес проживания, 
--город и страну проживания.

SELECT c.first_name || ' ' || c.last_name "customer", address.address, city.city, country.country
FROM customer
JOIN address USING(address_id)
JOIN city USING(city_id)
INNER JOIN country ON country.country_id = city.country_id

--ЗАДАНИЕ №2
--С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.

SELECT s.store_id, 
	count(c.customer_id) "customer_count"
FROM customer c
INNER JOIN store s using(store_id)
GROUP BY s.store_id ;


--Доработайте запрос и выведите только те магазины, 
--у которых количество покупателей больше 300-от.
--Для решения используйте фильтрацию по сгруппированным строкам 
--с использованием функции агрегации.

SELECT store.store_id, count(customer.customer_id)  "customer_count"
FROM customer
INNER JOIN store using(store_id)
GROUP BY store.store_id 
HAVING COUNT(customer.customer_id) >300;


-- Доработайте запрос, добавив в него информацию о городе магазина, 
--а также фамилию и имя продавца, который работает в этом магазине.

SELECT s.store_id, c2.city, s2.first_name || ' ' || s2.last_name "manager", COUNT(customer_id)
FROM customer c
INNER JOIN store s using(store_id)
INNER JOIN address a on a.address_id = s.address_id 
INNER JOIN city c2 on c2.city_id = a.city_id
INNER JOIN staff s2 on s.manager_staff_id = s2.staff_id 
GROUP BY  1, 2, 3
HAVING COUNT(c.customer_id) >300;





--ЗАДАНИЕ №3
--Выведите ТОП-5 покупателей, 
--которые взяли в аренду за всё время наибольшее количество фильмов

SELECT count(r.rental_id), c.first_name ||' ' || c.last_name "customer"
FROM rental r 
INNER JOIN customer c using(customer_id)
GROUP BY r.customer_id, 2
ORDER BY COUNT(r.rental_id) DESC
LIMIT 5



--ЗАДАНИЕ №4
--Посчитайте для каждого покупателя 4 аналитических показателя:
--  1. количество фильмов, которые он взял в аренду
--  2. общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа)
--  3. минимальное значение платежа за аренду фильма
--  4. максимальное значение платежа за аренду фильма

SELECT c.first_name || ' ' || c.last_name "customer_name",
	COUNT(r.rental_id),
	SUM(p.amount),
	MIN(p.amount),
	MAX(p.amount)
FROM customer c 
LEFT JOIN rental r using(customer_id)
LEFT JOIN payment p using(customer_id)
GROUP BY c.customer_id;

--ЗАДАНИЕ №5
--Используя данные из таблицы городов составьте одним запросом всевозможные пары городов таким образом,
 --чтобы в результате не было пар с одинаковыми названиями городов. 
 --Для решения необходимо использовать декартово произведение.
 
SELECT c.city, c2.city 
FROM city c 
CROSS JOIN city c2
WHERE c.city_id != c2.city_id;



--ЗАДАНИЕ №6
--Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date)
--и дате возврата фильма (поле return_date), 
--вычислите для каждого покупателя среднее количество дней, за которые покупатель возвращает фильмы.
 
SELECT c.first_name || ' ' || c.last_name customer_name,
	avg(r.return_date::date - r.rental_date::date) avg_days
FROM rental r 
INNER JOIN customer c USING(customer_id)
GROUP BY c.customer_id 
ORDER BY customer_name;



--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Посчитайте для каждого фильма сколько раз его брали в аренду и значение общей стоимости аренды фильма за всё время.

SELECT   f.title,
	COUNT(r.rental_id),
	SUM(p.amount) 
FROM rental r 
INNER JOIN inventory i USING(inventory_id)
INNER JOIN film f ON i.film_id = f.film_id
INNER JOIN payment p ON p.rental_id = r.rental_id 
GROUP BY f.film_id;







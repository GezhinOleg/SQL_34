--=============== ������ 2. ������ � ������ ������ =======================================
--= �������, ��� ���������� ���������� ������ ���������� � ������� ����� PUBLIC===========
SET search_path TO public;

--======== �������� ����� ==============

--������� �1
--�������� ���������� �������� �������� �� ������� �������

select distinct district from address

--������� �2
--����������� ������ �� ����������� �������, ����� ������ ������� ������ �� �������, 
--�������� ������� ���������� �� "K" � ������������� �� "a", � �������� �� �������� ��������

select district from address
WHERE (district LIKE 'K%a' and district NOT LIKE '% %')

--������� �3
--�������� �� ������� �������� �� ������ ������� ���������� �� ��������, ������� ����������� 
--� ���������� � 17 ����� 2007 ���� �� 19 ����� 2007 ���� ������������, 
--� ��������� ������� ��������� 1.00.
--������� ����� ������������� �� ���� �������.

/*select payment_id, payment_date, amount from payment
where amount > 1.0 and payment_date >= '2007-03-17' and payment_date <= '2007-03-20'
ORDER BY payment_date;*/
select payment_id, payment_date, amount from payment
where amount > 1.0 and payment_date between '2007-03-17' and '2007-03-20'
ORDER BY payment_date;



--������� �4
-- �������� ���������� � 10-�� ��������� �������� �� ������ �������.

select payment_id, payment_date, amount from payment
ORDER BY amount DESC LIMIT 10;

--������� �5
--�������� ��������� ���������� �� �����������:
--  1. ������� � ��� (� ����� ������� ����� ������)
--  2. ����������� �����
--  3. ����� �������� ���� email
--  4. ���� ���������� ���������� ������ � ���������� (��� �������)
--������ ������� ������� ������������ �� ������� �����.

select first_name||' '|| last_name as "������� � ���", email as "����������� �����",
       CHARACTER_LENGTH(email) as "����� email", last_update::date as "����"
       from customer;

--������� �6
--�������� ����� �������� �������� �����������, ����� ������� Kelly ��� Willie.
--��� ����� � ������� � ����� �� ������� �������� ������ ���� ���������� � ������� �������.

select upper(last_name), upper(first_name) 
       from customer      
where first_name = 'Kelly' or first_name = 'Willie';


--======== �������������� ����� ==============

--������� �1
--�������� ����� �������� ���������� � �������, � ������� ������� "R" 
--� ��������� ������ ������� �� 0.00 �� 3.00 ������������, 
--� ����� ������ c ��������� "PG-13" � ���������� ������ ������ ��� ������ 4.00.

select film_id, title, description, rating, rental_rate
       from film
      where rating = 'R' and rental_rate between 0.00 and 3.00 or rating = 'PG-13' and rental_rate >= 4.00
     order by rental_rate;

--������� �2
--�������� ���������� � ��� ������� � ����� ������� ��������� ������.

select film_id, title, description
       from film
       ORDER BY CHARACTER_LENGTH(description) LIMIT 3;

/*select film_id, title, description, CHARACTER_LENGTH(description) as len
       from film
       ORDER BY len LIMIT 3;*/

--������� �3
-- �������� Email ������� ����������, �������� �������� Email �� 2 ��������� �������:
--� ������ ������� ������ ���� ��������, ��������� �� @, 
--�� ������ ������� ������ ���� ��������, ��������� ����� @.





--������� �4
--����������� ������ �� ����������� �������, �������������� �������� � ����� ��������: 
--������ ����� ������ ���� ���������, ��������� ���������.





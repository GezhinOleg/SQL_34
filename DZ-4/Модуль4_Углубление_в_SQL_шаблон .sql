--=============== МОДУЛЬ 4. УГЛУБЛЕНИЕ В SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--База данных: если подключение к облачной базе, то создаете новые таблицы в формате:
--таблица_фамилия, 
--если подключение к контейнеру или локальному серверу, то создаете новую схему и в ней создаете таблицы.


-- Спроектируйте базу данных для следующих сущностей:
-- 1. язык (в смысле английский, французский и тп)
-- 2. народность (в смысле славяне, англосаксы и тп)
-- 3. страны (в смысле Россия, Германия и тп)


--Правила следующие:
-- на одном языке может говорить несколько народностей
-- одна народность может входить в несколько стран
-- каждая страна может состоять из нескольких народностей

 
--Требования к таблицам-справочникам:
-- идентификатор сущности должен присваиваться автоинкрементом
-- наименования сущностей не должны содержать null значения и не должны допускаться дубликаты в названиях сущностей
 
--СОЗДАНИЕ ТАБЛИЦЫ ЯЗЫКИ

CREATE TABLE languages (
	language_id serial primary key,
	"name" varchar(20) unique not null
);


--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ ЯЗЫКИ

INSERT INTO languages("name")
VALUES
	('Русский'),
	('Английский'),
	('Немецкий'),
                    ('Испанский'),
	('Армянский'),
	('Татарский');

--СОЗДАНИЕ ТАБЛИЦЫ НАРОДНОСТИ

CREATE TABLE nations (
	nation_id serial PRIMARY KEY,
	title varchar(40) UNIQUE NOT NULL 
);

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ НАРОДНОСТИ

INSERT INTO nations(title) 
VALUES
	('Русские'),
	('Англичане'),
	('Немцы'),
                    ('Испанцы'),
	('Армяне'),
	('Татары');

--СОЗДАНИЕ ТАБЛИЦЫ СТРАНЫ

CREATE TABLE countries (
	country_id serial PRIMARY KEY,
	"name"  varchar(40) UNIQUE NOT NULL 
);

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СТРАНЫ

INSERT INTO countries(title) 
VALUES
	('Российская Федерация'),
	('Англия'),
	('Германия'),
                    ('Испания'),
	('Армения');


--СОЗДАНИЕ ПЕРВОЙ ТАБЛИЦЫ СО СВЯЗЯМИ

CREATE TABLE CountriesNations(
	country_id integer references countries NOT NULL ,
	nation_id integer references nations NOT NULL ,
	constraint pkCountriesNations PRIMARY KEY (country_id, nation_id)
);

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ
INSERT INTO countriesnations 
VALUES
	(1,1),
	(2,2),
	(3,3),
	(4,4),
	(5,5),
                    (1,5),
	(1,6);


--СОЗДАНИЕ ВТОРОЙ ТАБЛИЦЫ СО СВЯЗЯМИ

CREATE TABLE LanguagesNations(
	language_id integer references languages NOT NULL,
	nation_id integer references nations NOT NULL,
	constraint pkLanguagesNations PRIMARY KEY (language_id, nation_id)
);

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ

INSERT INTO languagesnations 
VALUES
	(1,1),
	(2,2),
	(3,3),
	(4,4),
	(5,5),
	(6,6);

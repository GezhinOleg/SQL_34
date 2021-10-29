--=============== ������ 4. ���������� � SQL =======================================
--= �������, ��� ���������� ���������� ������ ���������� � ������� ����� PUBLIC===========
SET search_path TO public;

--======== �������� ����� ==============

--������� �1
--���� ������: ���� ����������� � �������� ����, �� �������� ����� ������� � �������:
--�������_�������, 
--���� ����������� � ���������� ��� ���������� �������, �� �������� ����� ����� � � ��� �������� �������.


-- ������������� ���� ������ ��� ��������� ���������:
-- 1. ���� (� ������ ����������, ����������� � ��)
-- 2. ���������� (� ������ �������, ���������� � ��)
-- 3. ������ (� ������ ������, �������� � ��)


--������� ���������:
-- �� ����� ����� ����� �������� ��������� �����������
-- ���� ���������� ����� ������� � ��������� �����
-- ������ ������ ����� �������� �� ���������� �����������

 
--���������� � ��������-������������:
-- ������������� �������� ������ ������������� ���������������
-- ������������ ��������� �� ������ ��������� null �������� � �� ������ ����������� ��������� � ��������� ���������
 
--�������� ������� �����

CREATE TABLE languages (
	language_id serial primary key,
	"name" varchar(20) unique not null
);


--�������� ������ � ������� �����

INSERT INTO languages("name")
VALUES
	('�������'),
	('����������'),
	('��������'),
                    ('���������'),
	('���������'),
	('���������');

--�������� ������� ����������

CREATE TABLE nations (
	nation_id serial PRIMARY KEY,
	title varchar(40) UNIQUE NOT NULL 
);

--�������� ������ � ������� ����������

INSERT INTO nations(title) 
VALUES
	('�������'),
	('���������'),
	('�����'),
                    ('�������'),
	('������'),
	('������');

--�������� ������� ������

CREATE TABLE countries (
	country_id serial PRIMARY KEY,
	"name"  varchar(40) UNIQUE NOT NULL 
);

--�������� ������ � ������� ������

INSERT INTO countries(title) 
VALUES
	('���������� ���������'),
	('������'),
	('��������'),
                    ('�������'),
	('�������');


--�������� ������ ������� �� �������

CREATE TABLE CountriesNations(
	country_id integer references countries NOT NULL ,
	nation_id integer references nations NOT NULL ,
	constraint pkCountriesNations PRIMARY KEY (country_id, nation_id)
);

--�������� ������ � ������� �� �������
INSERT INTO countriesnations 
VALUES
	(1,1),
	(2,2),
	(3,3),
	(4,4),
	(5,5),
                    (1,5),
	(1,6);


--�������� ������ ������� �� �������

CREATE TABLE LanguagesNations(
	language_id integer references languages NOT NULL,
	nation_id integer references nations NOT NULL,
	constraint pkLanguagesNations PRIMARY KEY (language_id, nation_id)
);

--�������� ������ � ������� �� �������

INSERT INTO languagesnations 
VALUES
	(1,1),
	(2,2),
	(3,3),
	(4,4),
	(5,5),
	(6,6);

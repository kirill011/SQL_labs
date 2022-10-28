USE laba
GO



--1. ���� ����� ���� ������ � ���� ��������� ���������.  � ������� ���������� SQL ������� ���������� ��������� ��������������� ������ ��� �������� � ����,
--��������� ��������� �������� ����������� ����������� (NOT NULL, UNIQUE, � �.�.). ���������� ����� ����� ������ � ������������ �������� ����������� �����������. 
--��� ������������ ������ (��� �������� ������� ������ ��� ��� ����������� ������� ������) ������������ ���� �������������� � ������ ���� �������� � ���������������
--�� ���� � ��������� �������.


CREATE TABLE pokupatel(
		id int PRIMARY KEY,
		familiya nvarchar(50) NOT NULL,
		rayon_p nvarchar(50) NOT NULL,
		skidka int NOT NULL,
);


CREATE TABLE magazin(
		id int PRIMARY KEY,
		nazvanie nvarchar(50) NOT NULL,
		rayon_r nvarchar(50) NOT NULL, 
		kommisionnie int NOT NULL,
);


CREATE TABLE knigi(
		id int PRIMARY KEY,
		nazvanie nvarchar(50) NOT NULL,
		stoimost int NOT NULL, 
		sklad nvarchar(50) NOT NULL,
		kolvo int NOT NULL,
);


CREATE TABLE pokupka(
		nomer_zakaza int NOT NULL,
		[data] datetime NOT NULL,
		prodavec int NOT NULL,
		pokupatel int NOT NULL,
		kniga int NOT NULL,
		kolvo int NOT NULL,
		summa int NOT NULL,
		FOREIGN KEY(prodavec) REFERENCES magazin(id),
		FOREIGN KEY(pokupatel) REFERENCES pokupatel (id),
		FOREIGN KEY(kniga) REFERENCES knigi(id)
);


--2. ������ � ����� ��������� ������� ���������� ������. ������������ ������-���� �� ���������� INSERT.

INSERT INTO pokupatel(id, familiya, rayon_p, skidka) 
VALUES
(1, '������','�������������',0),
(2, '�������','����������',15),
(3, '�������','���������',14),
(4, '�������','�������������',16),
(5, '���������','����������',15),
(6, '������','���������',16),
(7, '�������','����������',2),
(8, '�����','�����������',20),
(9, '����������','���������',3),
(10, '�������','����������',7);

INSERT INTO magazin(id, nazvanie, rayon_r , kommisionnie) 
VALUES
(1, '�����-�����','�����������', 7),
(2, '������','�������������', 8),
(3, '���-���','���������', 7),
(4, '������','�������������', 5),
(5, '�����-�����','���������', 6),
(6, '���������','�����������', 7),
(7, '��� �����','����������', 6),
(8, '�����-�����','����������', 9),
(9, '���������','�����������', 8),
(10, '�������','�������������', 9);

INSERT INTO knigi(id, nazvanie,sklad,kolvo,stoimost) 
VALUES
(1, '����� ������','���������', 27, 4000),
(2, '����� �����','�������������', 60, 600),
(3, '���� �� ���','���������', 59, 300),
(4, '��� ��������� �� ���','�����������', 19, 320),
(5, '����� ���� ������','�������������', 34, 450),
(6, '������� ��������� ������������','����������', 5, 6000),
(7, '����������� �����','����������', 40, 340),
(8, '����� � ���','�������������', 45, 800),
(9, '��� �����','�����������', 60, 340),
(10, '��� �����','����������',10, 300);

INSERT INTO pokupka(nomer_zakaza, [data], prodavec, pokupatel, kniga, kolvo, summa) 
VALUES
(1, '03.09.21', 4, 5, 1, 1, 4000),
(2, '27.06.21', 1, 6, 1, 1, 4000),
(3, '01.08.20', 2, 7, 1, 2, 8000),
(4, '20.08.20', 1, 1, 10, 1, 300),
(5, '20.10.20', 6, 3, 10, 1, 300),
(6, '14.08.21', 7, 7, 5, 13, 5650),
(7, '22.09.21', 9, 9, 8, 3, 2400),
(8, '24.11.21', 10, 5, 6, 1, 6000),
(9, '15.11.21', 10, 5, 7, 6, 2040),
(10, '14.03.21', 2, 6, 3, 1, 300);


--3. ��������� �������� SELECT ������� ������ ��� ������ ���� ����� ������ �������. ��������� ������������ �����. 
--��� ������������� ���������� ��������� �������� ����������� INSERT, UPDATE, DELETE. 

SELECT * FROM pokupatel;
SELECT * FROM magazin;
SELECT * FROM knigi;
SELECT * FROM pokupka;

--4.	������� ������� ��� ������:
--a)	���� ��������� �������� � ���������� ����;

SELECT DISTINCT nazvanie, stoimost FROM knigi

--b)	���� ��������� �������, � ������� ��������� ����������;

SELECT DISTINCT rayon_p FROM pokupatel

--c)	���� ��������� �������, ����� ������������� �������.

SELECT DISTINCT DATENAME(m ,[data]) FROM pokupka


--5. ������� ������� ��� ��������� ���������� �:
--a)	�������� � ������� ������ ���� �����������, ����������� � ������������� ������;

SELECT familiya, skidka FROM pokupatel 
WHERE pokupatel.rayon_p = '�������������';


--b)	��������� ��������� ����������� ��� ���������� �������;

SELECT nazvanie FROM magazin
WHERE magazin.rayon_r = '����������' OR magazin.rayon_r = '���������'

--c)	���������  � ��������� ����, � ������� ����������� ����� Windows( ����� ), ��� ������� ����� 20000 ( 2000 ) ���.
--      ����� ����������� ������������ �� �������� � �������� ���� ����.

SELECT nazvanie, stoimost FROM knigi
WHERE nazvanie LIKE ('%�����%') OR stoimost > 2000 
ORDER BY nazvanie ASC, stoimost DESC

--6. ��� ������ ������� ������� ��������� ������:
--a)	������� ���������� � �������� ��������, ��� ������������� �������;

SELECT familiya, magazin.nazvanie FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
JOIN magazin ON magazin.id = pokupka.prodavec

--b)	����, ������� ����������, ������, �������� � ���������� ��������� ����

SELECT [data], familiya, skidka, knigi.nazvanie, pokupka.kolvo FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
JOIN knigi ON knigi.id = pokupka.kniga

--7. ����������:
--a)	����� ������, ������� ���������� � ���� ��� �������, � ������� ���� ������� ���� �� ����� �� ������� ��� 60000 ( 6000 ) ���.

SELECT nomer_zakaza, familiya, [data] FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
WHERE summa >= 6000

--b)	�������, ��������� ����������� � ����� ������ �� ����� ����� ������. ������� ������� ����������, �����, ����. ���������� ����������;

SELECT familiya, rayon_p, [data] FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
JOIN magazin ON magazin.id = pokupka.prodavec
WHERE MONTH(pokupka.[data]) >= 3

--c)	��������, ������������� � ����� ������, ����� ��������������, ��� �������� ����� ��, � ���� ������ �� 10 �� 15 %;

SELECT nazvanie FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
JOIN magazin ON magazin.id = pokupka.prodavec
WHERE pokupatel.skidka >= 10 AND pokupatel.skidka <= 15 AND rayon_r != '�������������' 

--d)	������ �� ������� ���� (��������, ����� �������������, ����������), ������������� � ������ ������������� � ������������ � ������ ����� 10 ����. 
--      �������� ������ � ��������� � ������������� �� �����������. 

SELECT knigi.nazvanie, rayon_r, pokupka.kolvo, stoimost FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
JOIN magazin ON magazin.id = pokupka.prodavec
JOIN knigi ON knigi.id = pokupka.kniga
WHERE knigi.sklad = magazin.rayon_r AND (knigi.kolvo - pokupka.kolvo) > 10
ORDER BY stoimost ASC, knigi.nazvanie, rayon_r, pokupka.kolvo


--8. ������� ������ ��� ����������� ���� �������� ������� � ��������� ��������� �������,
--����� �� �������� �������� �����, ������������ ����������� ( � ������ ������). ������� ����� ��������.

UPDATE pokupka
SET summa = (SELECT p.kolvo * stoimost - p.kolvo * stoimost * skidka / 100 FROM pokupka as p
				JOIN pokupatel ON pokupatel.id = p.pokupatel
				JOIN knigi ON knigi.id = p.kniga
				WHERE pokupka.nomer_zakaza = p.nomer_zakaza)

--9.	��������� ������� � ������� � ������� ��������, ���������� �������� ������������, ���������� ���������.
--������� ������ ��� ��������������� ���������� ����� ������� ������������� ����������.

ALTER TABLE pokupka ADD kommisionnie INT

UPDATE pokupka
SET pokupka.kommisionnie = (SELECT magazin.kommisionnie FROM pokupka as p
				JOIN magazin ON magazin.id = p.prodavec
				WHERE p.nomer_zakaza = pokupka.nomer_zakaza)
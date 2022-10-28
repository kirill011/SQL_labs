USE laba
GO


--10.	��������� �������� IN (NOT IN)  ����������� ��������� �������:

--a)	����� �����������, ������� �� �������� ���� � ��������� �������������� ������ � ���� ������;

SELECT familiya FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
JOIN magazin ON magazin.id = pokupka.prodavec
WHERE rayon_r NOT IN (SELECT rayon_r FROM pokupka
							JOIN magazin ON magazin.id = pokupka.prodavec
							WHERE rayon_r = '�������������' AND MONTH([data]) = 6)

--b)	����� �����������, ���������� ����� � ���( ������� ) �� �����, ������� ��� ����� �������( ������ ) � ��� �� ������;

SELECT DISTINCT familiya FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
WHERE [data] IN (SELECT [data] FROM pokupka WHERE MONTH([data]) = 8) AND familiya != '������' 
	AND summa > (SELECT SUM(summa) FROM pokupka JOIN pokupatel ON pokupatel.id = pokupka.pokupatel WHERE familiya = '������' AND MONTH([data]) = 8)


--11. ��������� �������� ALL-ANY ����������� ��������� �������:

--a)	���������� ����������, �������� ����������� ������ ����� ���, ��� ������� ����� �� ����� �� ����� 50000 (5000)���.

SELECT DISTINCT familiya FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
WHERE skidka < ANY (SELECT skidka FROM pokupka
						JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
					WHERE summa > 5000)
AND summa > 5000

--b)	����� ����������, ����������� ����� ������� ���������� ����;

SELECT DISTINCT familiya FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
WHERE kolvo > ALL(SELECT p.kolvo FROM pokupka as p WHERE p.nomer_zakaza != pokupka.nomer_zakaza)

--c)	����� �� �����������, �� ���������� ���� � ��������� ������ ������, ����� ������� �� ����������� �����.

SELECT DISTINCT familiya FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
JOIN magazin ON magazin.id = pokupka.prodavec
WHERE rayon_p != rayon_r 
AND summa < ALL(SELECT p.summa from pokupka as p WHERE pokupka.nomer_zakaza != p.nomer_zakaza)

--12. ��������� �������� UNION �������� ������ ���������� ����������� � ������ ������������� ����.

SELECT rayon_p FROM pokupatel
UNION
SELECT sklad FROM knigi


--13. ��������� �������� EXISTS ( NOT EXISTS ) ����������� ������������� �������. 
--� ������, ���� ��� �������� ��������� �� ������ ����� �������� ������ ��������� �����, ��������� ������� ����� ���������� � �� ���������� ��������.

--a)	����� ���������� �������� ����� ������ � ��������� �������( �����-����� ) ��� ������� ( ������ );

SELECT DISTINCT familiya FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
JOIN magazin ON magazin.id = pokupka.prodavec
WHERE EXISTS(SELECT * FROM pokupka as p
				JOIN magazin ON magazin.id = p.prodavec
				WHERE nazvanie = '�����-�����' OR nazvanie = '������' AND p.nomer_zakaza = pokupka.nomer_zakaza)

--b)	����� �����������, ���������� ����� �� ���� ��������� ������ ������;

INSERT INTO pokupka(nomer_zakaza, [data], prodavec, pokupatel, kniga, kolvo, summa, kommisionnie)
VALUES
(11, '10.01.2021', 8, 7, 6, 5, 1300, 10);

SELECT DISTINCT familiya FROM pokupka as pk
JOIN pokupatel as p ON p.id = pokupatel
JOIN magazin ON magazin.id = prodavec
WHERE EXISTS(SELECT * FROM pokupka as pk1
				JOIN pokupatel as pok ON pok.id = pk1.pokupatel
				JOIN magazin ON magazin.id = pk1.prodavec
				WHERE rayon_r = rayon_p  AND pk.nomer_zakaza = pk1.nomer_zakaza AND rayon_p = ALL (SELECT rayon_r FROM pokupka
																										JOIN pokupatel ON pokupatel.id = pk1.pokupatel
																										JOIN magazin as mg ON mg.id = pk1.prodavec
																										WHERE mg.rayon_r = rayon_p))


SELECT * FROM pokupka
JOIN pokupatel as pok ON pok.id = pokupka.pokupatel
JOIN magazin ON magazin.id = pokupka.prodavec
WHERE rayon_r = rayon_p AND rayon_p = ALL (SELECT rayon_r FROM pokupka
													JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
													JOIN magazin as mg ON mg.id = pokupka.prodavec
													WHERE mg.rayon_r = rayon_p)

--c)	���������� �����������, ���������� �����, �� ����������� � �������� � ������������ ��������� ������������;

SELECT familiya FROM pokupka as pok
JOIN pokupatel as p ON p.id = pokupatel
JOIN magazin ON magazin.id = prodavec
WHERE NOT EXISTS (SELECT knigi.sklad as sklad FROM pokupka 
						JOIN pokupatel ON pokupatel.id = pokupatel
						JOIN magazin as mag ON magazin.id = prodavec
						JOIN knigi ON knigi.id = pokupka.kniga
						WHERE pok.nomer_zakaza = pokupka.nomer_zakaza AND magazin.kommisionnie = (SELECT MAX(kommisionnie) FROM magazin) AND sklad = mag.rayon_r )

--14.	����������� ������� � �������������� ���������� �������:

--a)	�������� ������� ��������� �������, ��������� � ��������� �������������� ������;

SELECT AVG(stoimost) FROM pokupka
JOIN magazin ON magazin.id = pokupka.prodavec
JOIn knigi ON knigi.id = pokupka.kniga
WHERE rayon_r = '�������������'

--b)	����� ���������� �����������, ���������� ����� � �������� ������� (�����-�����);

SELECT COUNT(pokupatel) FROM pokupka
JOIN magazin ON magazin.id = pokupka.prodavec
WHERE nazvanie = '�����-�����'

--c)	����� ����������� ������� ������ ���� �������;

SELECT familiya FROM pokupatel
WHERE skidka < (SELECT AVG(skidka) FROM pokupatel)

--d)	���������� ��������, � ������� �������� ����� ������ ����������� ��� � �������� ������"( �����-����� ).

INSERT INTO pokupka(nomer_zakaza, [data], prodavec, pokupatel, kniga, kolvo, summa, kommisionnie)
VALUES
(11, '10.01.2021', 4, 7, 6, 5, 1300, 10);

SELECT nazvanie FROM pokupka
JOIN magazin as mag ON mag.id = pokupka.prodavec
WHERE (SELECT COUNT(pokupatel) FROM pokupka
		JOIN magazin ON magazin.id = pokupka.prodavec
		WHERE nazvanie != '�����-�����' AND mag.nazvanie = nazvanie ) > (SELECT COUNT(pokupatel) FROM pokupka
							JOIN magazin as mg ON mg.id = pokupka.prodavec
							WHERE mg.nazvanie = '�����-�����')


--15.	��������� �������� ����������� ����������� ��������� �������:

--a)	������� ������ �� ��������� ��������� ����, ��������� � ������ ��������;

SELECT magazin.nazvanie, SUM(stoimost) FROM pokupka
JOIN magazin ON magazin.id = pokupka.prodavec
JOIn knigi ON knigi.id = pokupka.kniga
GROUP BY magazin.nazvanie


--b)	������� ����� � ��������� ��������� ���� ��������� ���� �� �������, ��� ����������� ��������;

SELECT magazin.rayon_r, SUM(stoimost) FROM pokupka
JOIN magazin ON magazin.id = pokupka.prodavec
JOIn knigi ON knigi.id = pokupka.kniga
GROUP BY magazin.rayon_r

--c)	�������� ������� ���������� � ����� ���� �������, ������������� ������ �����������;

SELECT familiya, SUM(summa) FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
GROUP BY familiya

--d)	���������� ��� ������� ��� ������ ���������� ����, ��������� ������������ �� �� ���������� ������.

SELECT DATENAME(dw, [data]), SUM(kolvo) FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
WHERE rayon_p != '���������'
GROUP BY DATENAME(dw, [data])
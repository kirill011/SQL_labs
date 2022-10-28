USE laba
GO


--10.	Используя операцию IN (NOT IN)  реализовать следующие запросы:

--a)	найти покупателей, которые не покупали книг в магазинах Нижегородского района в июне месяце;

SELECT familiya FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
JOIN magazin ON magazin.id = pokupka.prodavec
WHERE rayon_r NOT IN (SELECT rayon_r FROM pokupka
							JOIN magazin ON magazin.id = pokupka.prodavec
							WHERE rayon_r = 'Нижегородский' AND MONTH([data]) = 6)

--b)	найти покупателей, покупавших книги в мае( Августе ) на сумму, меньшую чем купил Потапов( Иванов ) в том же месяце;

SELECT DISTINCT familiya FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
WHERE [data] IN (SELECT [data] FROM pokupka WHERE MONTH([data]) = 8) AND familiya != 'Иванов' 
	AND summa > (SELECT SUM(summa) FROM pokupka JOIN pokupatel ON pokupatel.id = pokupka.pokupatel WHERE familiya = 'Иванов' AND MONTH([data]) = 8)


--11. Используя операции ALL-ANY реализовать следующие запросы:

--a)	определить покупателя, имеющего минимальную скидку среди тех, кто покупал книги на сумму не менее 50000 (5000)руб.

SELECT DISTINCT familiya FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
WHERE skidka < ANY (SELECT skidka FROM pokupka
						JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
					WHERE summa > 5000)
AND summa > 5000

--b)	найти покупателя, покупавшего самое большое количество книг;

SELECT DISTINCT familiya FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
WHERE kolvo > ALL(SELECT p.kolvo FROM pokupka as p WHERE p.nomer_zakaza != pokupka.nomer_zakaza)

--c)	какой из покупателей, не покупавших книг в магазинах своего района, делал покупки на минимальную сумму.

SELECT DISTINCT familiya FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
JOIN magazin ON magazin.id = pokupka.prodavec
WHERE rayon_p != rayon_r 
AND summa < ALL(SELECT p.summa from pokupka as p WHERE pokupka.nomer_zakaza != p.nomer_zakaza)

--12. Используя операцию UNION получить районы проживания покупателей и районы складирования книг.

SELECT rayon_p FROM pokupatel
UNION
SELECT sklad FROM knigi


--13. Используя операцию EXISTS ( NOT EXISTS ) реализовать нижеследующие запросы. 
--В случае, если для текущего состояния БД запрос будет выдавать пустое множество строк, требуется указать какие добавления в БД необходимо провести.

--a)	какие покупатели покупали книги только в магазинах “Наука”( Читай-город ) или “Знание” ( Азбука );

SELECT DISTINCT familiya FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
JOIN magazin ON magazin.id = pokupka.prodavec
WHERE EXISTS(SELECT * FROM pokupka as p
				JOIN magazin ON magazin.id = p.prodavec
				WHERE nazvanie = 'Читай-город' OR nazvanie = 'Азбука' AND p.nomer_zakaza = pokupka.nomer_zakaza)

--b)	найти покупателей, покупавших книги во всех магазинах своего района;

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

--c)	определить покупателей, покупавших книги, не продающиеся в магазине с максимальным значением комиссионных;

SELECT familiya FROM pokupka as pok
JOIN pokupatel as p ON p.id = pokupatel
JOIN magazin ON magazin.id = prodavec
WHERE NOT EXISTS (SELECT knigi.sklad as sklad FROM pokupka 
						JOIN pokupatel ON pokupatel.id = pokupatel
						JOIN magazin as mag ON magazin.id = prodavec
						JOIN knigi ON knigi.id = pokupka.kniga
						WHERE pok.nomer_zakaza = pokupka.nomer_zakaza AND magazin.kommisionnie = (SELECT MAX(kommisionnie) FROM magazin) AND sklad = mag.rayon_r )

--14.	Реализовать запросы с использованием агрегатных функций:

--a)	получить среднюю стоимость покупок, сделанных в магазинах Нижегородского района;

SELECT AVG(stoimost) FROM pokupka
JOIN magazin ON magazin.id = pokupka.prodavec
JOIn knigi ON knigi.id = pokupka.kniga
WHERE rayon_r = 'Нижегородский'

--b)	найти количество покупателей, покупавших книги в магазине “Наука” (Читай-город);

SELECT COUNT(pokupatel) FROM pokupka
JOIN magazin ON magazin.id = pokupka.prodavec
WHERE nazvanie = 'Читай-город'

--c)	найти покупателей имеющих скидку ниже средней;

SELECT familiya FROM pokupatel
WHERE skidka < (SELECT AVG(skidka) FROM pokupatel)

--d)	определить магазины, в которых покупало книги больше покупателей чем в магазине “Наука"( Читай-город ).

INSERT INTO pokupka(nomer_zakaza, [data], prodavec, pokupatel, kniga, kolvo, summa, kommisionnie)
VALUES
(11, '10.01.2021', 4, 7, 6, 5, 1300, 10);

SELECT nazvanie FROM pokupka
JOIN magazin as mag ON mag.id = pokupka.prodavec
WHERE (SELECT COUNT(pokupatel) FROM pokupka
		JOIN magazin ON magazin.id = pokupka.prodavec
		WHERE nazvanie != 'Читай-город' AND mag.nazvanie = nazvanie ) > (SELECT COUNT(pokupatel) FROM pokupka
							JOIN magazin as mg ON mg.id = pokupka.prodavec
							WHERE mg.nazvanie = 'Читай-город')


--15.	Используя средства группировки реализовать следующие запросы:

--a)	вывести данные по суммарной стоимости книг, купленных в каждом магазине;

SELECT magazin.nazvanie, SUM(stoimost) FROM pokupka
JOIN magazin ON magazin.id = pokupka.prodavec
JOIn knigi ON knigi.id = pokupka.kniga
GROUP BY magazin.nazvanie


--b)	вывести отчет о суммарной стоимости всех купленных книг по районам, где расположены магазины;

SELECT magazin.rayon_r, SUM(stoimost) FROM pokupka
JOIN magazin ON magazin.id = pokupka.prodavec
JOIn knigi ON knigi.id = pokupka.kniga
GROUP BY magazin.rayon_r

--c)	получить сводную информацию о сумме всех покупок, произведенных каждым покупателем;

SELECT familiya, SUM(summa) FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
GROUP BY familiya

--d)	определить для каждого дня недели количество книг, купленных покупателями не из Советского района.

SELECT DATENAME(dw, [data]), SUM(kolvo) FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
WHERE rayon_p != 'Советский'
GROUP BY DATENAME(dw, [data])
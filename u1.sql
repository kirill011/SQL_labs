USE laba
GO



--1. Дана схема базы данных в виде следующих отношений.  С помощью операторов SQL создать логическую структуру соответствующих таблиц для хранения в СУБД,
--используя известные средства поддержания целостности (NOT NULL, UNIQUE, и т.д.). Обосновать выбор типов данных и используемые средства поддержания целостности. 
--Для «связывания» таблиц (при создании внешних ключей или при последующей выборке данных) использовать поля «Идентификатор» в первых трех таблицах и соответствующие
--им поля в четвертой таблице.


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


--2. Ввести в ранее созданные таблицы конкретные данные. Использовать скрипт-файл из операторов INSERT.

INSERT INTO pokupatel(id, familiya, rayon_p, skidka) 
VALUES
(1, 'Иванов','Нижегородский',0),
(2, 'Смирнов','Московский',15),
(3, 'Соболев','Ленинский',14),
(4, 'Глухарёв','Автозаводский',16),
(5, 'Каменская','Сормовский',15),
(6, 'Шматко','Ленинский',16),
(7, 'Соколов','Московский',2),
(8, 'Рзаев','Канавинский',20),
(9, 'Кушнаренко','Ленинский',3),
(10, 'Бердыев','Сормовский',7);

INSERT INTO magazin(id, nazvanie, rayon_r , kommisionnie) 
VALUES
(1, 'Читай-город','Канавинский', 7),
(2, 'Азбука','Автозаводский', 8),
(3, 'Лит-рес','Ленинский', 7),
(4, 'Азбука','Нижегородский', 5),
(5, 'Читай-город','Советский', 6),
(6, 'Книгаград','Канавинский', 7),
(7, 'Дом книги','Московский', 6),
(8, 'Читай-город','Московский', 9),
(9, 'Дирижабль','Канавинский', 8),
(10, 'Читайна','Автозаводский', 9);

INSERT INTO knigi(id, nazvanie,sklad,kolvo,stoimost) 
VALUES
(1, 'Гарри Поттер','Приокский', 27, 4000),
(2, 'Белый огонь','Нижегородский', 60, 600),
(3, 'Горе от ума','Ленинский', 59, 300),
(4, 'Над пропастью во ржи','Канавинский', 19, 320),
(5, 'Общий курс физики','Нижегородский', 34, 450),
(6, 'Большая советская энциклопедия','Московский', 5, 6000),
(7, 'Капитанская дочка','Московский', 40, 340),
(8, 'Война и мир','Нижегородский', 45, 800),
(9, 'Сын полка','Канавинский', 60, 340),
(10, 'Том Сойер','Московский',10, 300);

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


--3. Используя оператор SELECT создать запрос для вывода всех строк каждой таблицы. Проверить правильность ввода. 
--При необходимости произвести коррекцию значений операторами INSERT, UPDATE, DELETE. 

SELECT * FROM pokupatel;
SELECT * FROM magazin;
SELECT * FROM knigi;
SELECT * FROM pokupka;

--4.	Создать запросы для вывода:
--a)	всех различных названий и стоимостей книг;

SELECT DISTINCT nazvanie, stoimost FROM knigi

--b)	всех различных районов, в которых проживают покупатели;

SELECT DISTINCT rayon_p FROM pokupatel

--c)	всех различных месяцев, когда производились покупки.

SELECT DISTINCT DATENAME(m ,[data]) FROM pokupka


--5. Создать запросы для получения инорфмации о:
--a)	фамилиях и размере скидки всех покупателей, проживающих в Нижегородском районе;

SELECT familiya, skidka FROM pokupatel 
WHERE pokupatel.rayon_p = 'Нижегородский';


--b)	названиях магазинов Сормовского или Советского районов;

SELECT nazvanie FROM magazin
WHERE magazin.rayon_r = 'Сормовский' OR magazin.rayon_r = 'Советский'

--c)	Названиях  и стоимости книг, в которых встречается слово Windows( огонь ), или стоящих более 20000 ( 2000 ) руб.
--      Вывод результатов организовать по названию и убыванию цены книг.

SELECT nazvanie, stoimost FROM knigi
WHERE nazvanie LIKE ('%огонь%') OR stoimost > 2000 
ORDER BY nazvanie ASC, stoimost DESC

--6. Для каждой покупки вывести следующие данные:
--a)	фамилию покупателя и название магазина, где производилась покупка;

SELECT familiya, magazin.nazvanie FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
JOIN magazin ON magazin.id = pokupka.prodavec

--b)	дату, фамилию покупателя, скидку, название и количество купленных книг

SELECT [data], familiya, skidka, knigi.nazvanie, pokupka.kolvo FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
JOIN knigi ON knigi.id = pokupka.kniga

--7. Определить:
--a)	номер заказа, фамилию покупателя и дату для покупок, в которых было продано книг на сумму не меньшую чем 60000 ( 6000 ) руб.

SELECT nomer_zakaza, familiya, [data] FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
WHERE summa >= 6000

--b)	покупки, сделанные покупателем в своем районе не ранее марта месяца. Вывести фамилию покупателя, район, дату. Произвести сортировку;

SELECT familiya, rayon_p, [data] FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
JOIN magazin ON magazin.id = pokupka.prodavec
WHERE MONTH(pokupka.[data]) >= 3

--c)	магазины, расположенные в любом районе, кроме Автозаводского, где покупали книги те, у кого скидка от 10 до 15 %;

SELECT nazvanie FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
JOIN magazin ON magazin.id = pokupka.prodavec
WHERE pokupatel.skidka >= 10 AND pokupatel.skidka <= 15 AND rayon_r != 'Автозаводский' 

--d)	данные по покупке книг (название, район складирования, количество), приобретенных в районе складирования и содержащихся в запасе более 10 штук. 
--      Включить данные о стоимости и отсортировать по возрастанию. 

SELECT knigi.nazvanie, rayon_r, pokupka.kolvo, stoimost FROM pokupka
JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
JOIN magazin ON magazin.id = pokupka.prodavec
JOIN knigi ON knigi.id = pokupka.kniga
WHERE knigi.sklad = magazin.rayon_r AND (knigi.kolvo - pokupka.kolvo) > 10
ORDER BY stoimost ASC, knigi.nazvanie, rayon_r, pokupka.kolvo


--8. Создать запрос для модификации всех значений столбца с суммарной величиной покупки,
--чтобы он содержал истинную сумму, оплачиваемую покупателем ( с учетом скидки). Вывести новые значения.

UPDATE pokupka
SET summa = (SELECT p.kolvo * stoimost - p.kolvo * stoimost * skidka / 100 FROM pokupka as p
				JOIN pokupatel ON pokupatel.id = p.pokupatel
				JOIN knigi ON knigi.id = p.kniga
				WHERE pokupka.nomer_zakaza = p.nomer_zakaza)

--9.	Расширить таблицу с данными о покупке столбцом, содержащим величину коммисионных, получаемых магазином.
--Создать запрос для автоматического заполнения этого столбца рассчитанными значениями.

ALTER TABLE pokupka ADD kommisionnie INT

UPDATE pokupka
SET pokupka.kommisionnie = (SELECT magazin.kommisionnie FROM pokupka as p
				JOIN magazin ON magazin.id = p.prodavec
				WHERE p.nomer_zakaza = pokupka.nomer_zakaza)
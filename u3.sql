USE laba
GO


--16.	����������� �������� ���������, ������������ ��������� ������ � out-��������, ���������� ���������� � ���������� 
--(�������, ����� ����������, ����, ����� � �������� �������� ��������� �������). ���������� ��������, ����� ���������� 
--�� ����� ������� � � ���� ������ ������ ���������� � ��������� ������� ���������� �������� �� ����.



CREATE PROCEDURE n16 
@idd int 
AS
BEGIN
DECLARE
@id int,
@info1 nvarchar(max),
@data nvarchar(max), 
@summa int
SET @id = @idd
SET @info1 = NULL
SET @summa = NULL
SET @data = NULL
select @info1 = familiya + ',' + rayon_p + ',' from pokupatel where pokupatel.id= @id
SELECT [data], Summa, idv
INTO #vremennaya 
FROM(SELECT pokupatel.id as idv, [data], pokupka.Summa as Summa,  row_number() OVER(PARTITION BY familiya ORDER BY [data] DESC) AS rn
		FROM pokupka
		LEFT JOIN magazin ON magazin.id = pokupka.prodavec
		RIGHT JOIN pokupatel ON pokupatel.id = pokupka.pokupatel
			) t WHERE t.rn = 1
IF NOT EXISTS(SELECT * FROM pokupka WHERE pokupatel = @id)
			PRINT @info1 + '������� �� ����'

SELECT 
	@data = cast([data] as char(20)), @summa = Summa 
	FROM #vremennaya WHERE #vremennaya.idv = @id
PRINT @info1 + CONVERT(NVARCHAR(max),@data) + ',' + CONVERT(NVARCHAR(max),@summa)
DROP TABLE #vremennaya
END
GO

EXEC n16 1 -- ���� �������
EXEC n16 2 -- ������ �������



--17.	�������� ������� ����������. �������� ��������� ����� (� ��������������� �������). ��� ���������� ������� ���������, 
--����� �� ������� ���������� ������ ������ ����� (� ������� ��������).


ALTER TABLE pokupatel ADD vozrast INT
ALTER TABLE knigi ADD kategoriya INT
GO




CREATE TRIGGER proverka
on pokupka
AFTER INSERT
AS
BEGIN
IF (SELECT COUNT(*) FROM pokupka as inserted JOIN pokupatel ON pokupatel.id = inserted.pokupatel JOIN knigi ON knigi.id = inserted.kniga WHERE kategoriya < vozrast) < (SELECT COUNT(*) FROM inserted) 
ROLLBACK TRAN
END
GO

INSERT INTO pokupatel(id, familiya, rayon_p, skidka, vozrast) 
VALUES
(11, '��������','�������������',0, 10),
(12, '�������','�������������',0, 20);

INSERT INTO knigi(id, nazvanie,sklad,kolvo,stoimost, kategoriya) 
VALUES
(11, '����� ���������� ��� �����','���������', 27, 300, 7),
(12, '����� ���������� ��� ��������','���������', 27, 400, 16)


INSERT INTO pokupka(nomer_zakaza, [data], prodavec, pokupatel, kniga, kolvo, summa) 
VALUES
(12, '03.09.21', 4, 11, 12, 1, 0); -- ����� ������

INSERT INTO pokupka(nomer_zakaza, [data], prodavec, pokupatel, kniga, kolvo, summa) 
VALUES
(13, '03.09.21', 4, 12, 11, 1, 0); -- ����������

GO
-- 18.	����������� ������� �����, ��� ��� ����� ������ � ������� �������, ���� ����� ������� �� �������, �� ��� ����������� 

ALTER TABLE pokupka ALTER COLUMN summa INT NULL
GO

CREATE TRIGGER podstanovka_summi
ON pokupka
AFTER INSERT
AS
BEGIN
UPDATE pokupka
SET summa = stoimost * pokupka.kolvo -stoimost * pokupka.kolvo * pokupatel.skidka/100  FROM pokupka 
JOIN magazin ON magazin.id = prodavec 
JOIN pokupatel ON pokupatel.id = pokupatel 
JOIN knigi ON knigi.id = kniga
WHERE summa IS NULL
END 
GO


INSERT INTO pokupka(nomer_zakaza, [data], prodavec, pokupatel, kniga, kolvo, summa) 
VALUES
(14, '03.09.21', 4, 12, 11, 1, NULL);

SELECT * FROM pokupka  -- ����� ����������
GO
--19.	������� ������������� (view), ���������� ����: ����� ������, ��� ����������, ������, �������� �����, ���� �����, ���������� � ���������.  

CREATE VIEW Preds AS
SELECT pokupka.nomer_zakaza as '����� ������',
	   familiya as '��� ����������',
	   skidka as '������',
	   knigi.nazvanie as '�������� �����',
	   stoimost as '���� �����',
	   pokupka.kolvo as '����������',
	   summa as '���������'
FROM pokupka 
JOIN magazin ON magazin.id = prodavec 
JOIN pokupatel ON pokupatel.id = pokupatel 
JOIN knigi ON knigi.id = kniga

GO

select * from Preds
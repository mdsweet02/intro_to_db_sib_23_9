USE [Дипломное_проектирование]
GO

CREATE VIEW vMy_view AS
SELECT
	rec.ФИО AS ФИО_Рецензента,
	b.наименование AS Имя_банка,
	b.Код_банка
FROM Банки AS b
JOIN Рецензенты_члены_ГАК AS rec ON b.Код_банка = rec.Код_банка
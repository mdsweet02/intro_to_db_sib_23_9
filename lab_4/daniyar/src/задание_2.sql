CREATE VIEW dbo.vЗадание_2
AS
SELECT
    p.код_рецензента          AS ИИН,
    rec.ФИО,
    COUNT(*)                  AS Количество_рецензий,
    COUNT(*) * 2000           AS Сумма_к_выплате_тг

FROM dbo.Проект				  AS p
JOIN dbo.Рецензенты_члены_ГАК AS rec ON rec.ИИН = p.код_рецензента

GROUP BY p.код_рецензента, rec.ФИО;

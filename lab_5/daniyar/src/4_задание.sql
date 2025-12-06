CREATE PROCEDURE dbo.процедура_4
    @код_рецензента        CHAR(12),   -- вход: код (ИИН) рецензента
    @количество_проектов   INT OUTPUT  -- выход: фактическое количество проектов
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        @количество_проектов = COUNT(*)
    FROM dbo.Проекты
    WHERE код_рецензента = @код_рецензента;
END;
GO

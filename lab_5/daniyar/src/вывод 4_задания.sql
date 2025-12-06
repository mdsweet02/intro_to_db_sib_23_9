DECLARE @cnt INT;

EXEC dbo.процедура_4
    @код_рецензента      = '103636310117',
    @количество_проектов = @cnt OUTPUT;

PRINT N'Количество рецензированных проектов: ' + CAST(@cnt AS NVARCHAR(10));

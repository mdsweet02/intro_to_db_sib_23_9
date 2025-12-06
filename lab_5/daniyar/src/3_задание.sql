CREATE PROCEDURE dbo.процедура_3
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @NextId INT;

    -- находим следующий код банка (максимальный + 1)
    SELECT @NextId = ISNULL(MAX(Код_банка), 0) + 1
    FROM dbo.Банки;

    WHILE @i <= 3
    BEGIN
        INSERT INTO dbo.Банки (Код_банка, наименование)
        VALUES (@NextId, N'Банк ' + CAST(@NextId AS NVARCHAR(10)));

        SET @i = @i + 1;
        SET @NextId = @NextId + 1;  -- следующий код
    END;
END;
GO

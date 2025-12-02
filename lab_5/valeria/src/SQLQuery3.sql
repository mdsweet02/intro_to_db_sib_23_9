CREATE OR ALTER PROCEDURE sp_InsertEmployees
AS
BEGIN
    DECLARE @i INT = 1;

    WHILE @i <= 3
    BEGIN
        INSERT INTO [Сотрудники] ([ФИО], [Код_подразделения])
        VALUES ('Новый сотрудник ' + CAST(@i AS NVARCHAR(10)), 1);

        SET @i = @i + 1;
    END
END;
GO
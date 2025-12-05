CREATE OR ALTER PROCEDURE InsertFourSteelMarks
AS
BEGIN
    DECLARE @i INT = 1;

    WHILE @i <= 4
    BEGIN
        INSERT INTO SteelMarks (MarkName)
        VALUES ('GeneratedMark_' + CAST(@i AS NVARCHAR(5)));
        SET @i = @i + 1;
    END;
END;
GO
CREATE FUNCTION dbo.ф_средний_балл_студента
(
    @Код_студента INT
)
RETURNS DECIMAL(4,2)
AS
BEGIN
    DECLARE @Балл DECIMAL(4,2);

    SELECT
        @Балл = [средний_балл_успеваемости]
    FROM dbo.Студенты
    WHERE [Код_студента] = @Код_студента;

    RETURN ISNULL(@Балл, 0);
END;
GO

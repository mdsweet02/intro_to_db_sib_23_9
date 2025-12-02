CREATE OR ALTER PROCEDURE sp_DocsDueToday
AS
BEGIN
    SELECT *
    FROM [Регистрация]
    WHERE [Дата_исполнения_по_закону] = CAST(GETDATE() AS DATE);
END;
GO
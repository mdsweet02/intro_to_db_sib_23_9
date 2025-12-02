CREATE OR ALTER PROCEDURE sp_GetApplicantAge
    @Код_заявителя INT
AS
BEGIN
    DECLARE @Возраст INT;

    SELECT @Возраст = YEAR(GETDATE()) - [Год_рождения]
    FROM [Анкета_заявителя]
    WHERE [Код_заявителя] = @Код_заявителя;

    SELECT @Возраст AS Возраст;
END;
GO
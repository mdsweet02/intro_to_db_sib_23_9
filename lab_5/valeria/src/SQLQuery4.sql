CREATE OR ALTER FUNCTION fn_GetApplicantAge(@Код_заявителя INT)
RETURNS INT
AS
BEGIN
    DECLARE @Возраст INT;

    SELECT @Возраст = YEAR(GETDATE()) - [Год_рождения]
    FROM [Анкета_заявителя]
    WHERE [Код_заявителя] = @Код_заявителя;

    RETURN @Возраст;
END;
GO
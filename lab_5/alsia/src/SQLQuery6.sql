USE Страхование;
GO

IF OBJECT_ID('GetContractSum', 'P') IS NOT NULL
    DROP PROCEDURE GetContractSum;
GO

CREATE PROCEDURE GetContractSum @НомерДоговора INT = NULL
AS
IF @НомерДоговора IS NULL
BEGIN
    PRINT 'Введите номер договора';
    RETURN;
END
ELSE
BEGIN
    SELECT Номер_договора, Сумма_страховки
    FROM Договора
    WHERE Номер_договора = @НомерДоговора;
END;
GO

PRINT 'До процедуры';
EXEC GetContractSum;         -- Без параметра
PRINT 'После возврата';
GO

EXEC GetContractSum 3;       -- С параметром
GO

USE Страхование;
GO

IF OBJECT_ID('CheckContractSum', 'P') IS NOT NULL
    DROP PROCEDURE CheckContractSum;
GO

CREATE PROCEDURE CheckContractSum @НомерДоговора INT
AS
IF (SELECT Сумма_страховки FROM Договора WHERE Номер_договора = @НомерДоговора) > 1000000
    RETURN 1;
ELSE
    RETURN 99;
GO
DECLARE @result INT;
EXEC @result = CheckContractSum 5;

IF @result = 1
    PRINT 'Сумма больше 1 000 000';
ELSE
    PRINT 'Сумма меньше или равна 1 000 000';
GO

USE Страхование;
GO

IF OBJECT_ID('GetClientInfo', 'P') IS NOT NULL
    DROP PROCEDURE GetClientInfo;
GO

CREATE PROCEDURE GetClientInfo @ИИНБИН CHAR(12)
AS
SELECT 
    ИИН_БИН,
    ФИО_Наименование,
    Признак_клиента,
    Адрес,
    Телефон,
    Лицевой_счет
FROM Клиенты
WHERE ИИН_БИН = @ИИНБИН;
GO
EXEC GetClientInfo '990101123456';
GO
USE Страхование;
GO

IF OBJECT_ID('dbo.fn_TotalPayments', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_TotalPayments;
GO

CREATE FUNCTION dbo.fn_TotalPayments (@ИИНБИН CHAR(12))
RETURNS DECIMAL(15,2)
AS
BEGIN
    DECLARE @Total DECIMAL(15,2);

    SELECT @Total = SUM(Сумма)
    FROM Перечисления
    WHERE ИИН_БИН = @ИИНБИН;

    RETURN ISNULL(@Total, 0);
END;
GO
SELECT dbo.fn_TotalPayments('990101123456') AS [Общая сумма выплат клиента];
GO
USE Страхование;
GO

IF OBJECT_ID('dbo.fn_ContractDuration', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_ContractDuration;
GO

CREATE FUNCTION dbo.fn_ContractDuration (@НомерДоговора INT)
RETURNS INT
AS
BEGIN
    DECLARE @days INT;

    SELECT @days = DATEDIFF(DAY, Дата_заключения, Срок_действия)
    FROM Договора
    WHERE Номер_договора = @НомерДоговора;

    RETURN @days;
END;
GO
SELECT dbo.fn_ContractDuration(1) AS [Длительность договора (дней)];
GO
USE Страхование;
GO

IF OBJECT_ID('dbo.fn_AgentReward', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_AgentReward;
GO

CREATE FUNCTION dbo.fn_AgentReward (@НомерДоговора INT)
RETURNS DECIMAL(15,2)
AS
BEGIN
    DECLARE @Reward DECIMAL(15,2);

    SELECT @Reward = (Д.Сумма_страховки * С.Процент_вознаграждения / 100)
    FROM Договора Д
    JOIN Страховщики С ON Д.Код_страховщика = С.Код_страховщика
    WHERE Д.Номер_договора = @НомерДоговора;

    RETURN ISNULL(@Reward, 0);
END;
GO
SELECT dbo.fn_AgentReward(1) AS [Вознаграждение страховщика];
GO
USE Страхование;
GO

SELECT 
    Д.Номер_договора,
    К.ФИО_Наименование AS Клиент,
    Д.Сумма_страховки,
    dbo.fn_TotalPayments(К.ИИН_БИН) AS [Выплаты клиента],
    dbo.fn_ContractDuration(Д.Номер_договора) AS [Дней действия],
    dbo.fn_AgentReward(Д.Номер_договора) AS [Вознаграждение страховщика]
FROM Договора Д
JOIN Клиенты К ON Д.ИИН_БИН = К.ИИН_БИН;
GO


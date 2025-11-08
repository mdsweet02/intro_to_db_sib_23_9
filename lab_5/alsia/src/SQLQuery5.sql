USE Страхование;
GO

IF EXISTS (SELECT name FROM sysobjects WHERE name = 'GetContractSum' AND type = 'P')
    DROP PROCEDURE GetContractSum;
GO
USE Страхование;
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
    SELECT Номер_договора, Сумма_страхования
    FROM Договора
    WHERE Номер_договора = @НомерДоговора;
END;
GO
USE Страхование;
GO
PRINT 'До процедуры';
EXECUTE GetContractSum;  -- Без параметра
PRINT 'После возврата';
GO
EXECUTE GetContractSum 3;  -- С параметром
GO
USE Страхование;
GO
USE Страхование;
GO

IF EXISTS (SELECT name FROM sysobjects WHERE name = 'CheckContractSum' AND type = 'P')
    DROP PROCEDURE CheckContractSum;
GO

CREATE PROCEDURE CheckContractSum @НомерДоговора INT
AS
IF (SELECT Сумма_страхования FROM Договора WHERE Номер_договора = @НомерДоговора) > 1000000
    RETURN 1;
ELSE
    RETURN 99;
GO

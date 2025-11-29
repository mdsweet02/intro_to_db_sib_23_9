
USE Страхование;
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'Delete_Contract' AND type = 'TR')
    DROP TRIGGER Delete_Contract;
GO
CREATE TRIGGER Delete_Contract
ON Договора
FOR DELETE
AS
BEGIN
    DELETE Перечисления
    FROM Перечисления, deleted
    WHERE Перечисления.Номер_договора = deleted.Номер_договора;
    PRINT 'Deleted related payments from Перечисления';
END;
GO

USE Страхование;
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'Update_Accumulated' AND type = 'TR')
    DROP TRIGGER Update_Accumulated;
GO
CREATE TRIGGER Update_Accumulated
ON Перечисления
FOR INSERT
AS
BEGIN
    -- Добавляем сумму перечисления к накопленной сумме договора
    UPDATE Договора
    SET Накопленная_сумма = Накопленная_сумма + i.Сумма
    FROM Договора d
    JOIN inserted i ON d.Номер_договора = i.Номер_договора;

    PRINT 'Updated accumulated amount in Договора';
END;
GO

USE Страхование;
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'Update_Insurance_Check' AND type = 'TR')
    DROP TRIGGER Update_Insurance_Check;
GO
CREATE TRIGGER Update_Insurance_Check
ON Договора
FOR UPDATE
AS
BEGIN
    DECLARE @old DECIMAL(15,2), @new DECIMAL(15,2);
    SELECT @old = Сумма_страховки FROM deleted;
    SELECT @new = Сумма_страховки FROM inserted;
    PRINT 'Old insurance amount = ' + CONVERT(VARCHAR(20), @old);
    PRINT 'New insurance amount = ' + CONVERT(VARCHAR(20), @new);
    IF (@new > @old * 1.2)
    BEGIN
        PRINT 'Increase too high, rollback!';
        ROLLBACK;
    END
    ELSE
        PRINT 'Insurance amount update is OK';
END;
GO

USE Страхование;
GO
CREATE VIEW ClientsByRegion
AS
SELECT ИИН_БИН, ФИО_Наименование, Код_района
FROM Клиенты;
GO
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'Update_ClientsByRegion' AND type = 'TR')
    DROP TRIGGER Update_ClientsByRegion;
GO
CREATE TRIGGER Update_ClientsByRegion
ON ClientsByRegion
INSTEAD OF UPDATE
AS
BEGIN
    PRINT 'Updating client in view...';
    UPDATE Клиенты
    SET ФИО_Наименование = i.ФИО_Наименование,
        Код_района = i.Код_района
    FROM Клиенты c
    JOIN inserted i ON c.ИИН_БИН = i.ИИН_БИН;
END;
GO

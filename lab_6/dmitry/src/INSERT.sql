CREATE OR ALTER TRIGGER trg_InsertMelt
ON Melts
AFTER INSERT
AS
BEGIN
    -- Логируем добавление новой плавки
    INSERT INTO MeltLog (MeltID, ActionType)
    SELECT MeltID, 'INSERT'
    FROM inserted;
END;
GO
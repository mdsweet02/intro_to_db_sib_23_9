CREATE OR ALTER TRIGGER trg_UpdateMeltTons
ON Melts
AFTER UPDATE
AS
BEGIN
    -- Проверяем, изменилось ли поле Tons
    IF UPDATE(Tons)
    BEGIN
        INSERT INTO MeltLog (MeltID, ActionType)
        SELECT MeltID, 'UPDATE'
        FROM inserted;
    END
END;
GO
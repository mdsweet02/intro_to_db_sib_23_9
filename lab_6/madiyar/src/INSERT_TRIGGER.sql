CREATE TRIGGER trg_Citizens_Update
ON Citizens
AFTER UPDATE
AS
BEGIN
    INSERT INTO Citizens_Log (IIN, FIO, ActionType, ActionDate)
    SELECT i.IIN, i.FIO, 'UPDATE', GETDATE()
    FROM inserted i;
END;
GO


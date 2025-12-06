CREATE TABLE Citizens_Log (
    LogID INT IDENTITY PRIMARY KEY,
    IIN VARCHAR(20),
    FIO NVARCHAR(100),
    ActionType NVARCHAR(20),
    ActionDate DATETIME
);
GO

CREATE TRIGGER trg_Citizens_Insert
ON Citizens
AFTER INSERT
AS
BEGIN
    INSERT INTO Citizens_Log (IIN, FIO, ActionType, ActionDate)
    SELECT IIN, FIO, 'INSERT', GETDATE()
    FROM inserted;
END;
GO


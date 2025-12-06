CREATE TABLE Citizens_Archive (
    IIN CHAR(12),
    FIO NVARCHAR(200),
    DeletedAt DATETIME
);
GO

CREATE TRIGGER trg_Citizens_Delete
ON Citizens
AFTER DELETE
AS
BEGIN
    INSERT INTO Citizens_Archive (IIN, FIO, DeletedAt)
    SELECT d.IIN, d.FIO, GETDATE()
    FROM deleted d;
END;
GO

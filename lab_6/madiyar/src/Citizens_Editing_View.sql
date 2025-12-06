CREATE VIEW View_CitizensSimple
AS
SELECT IIN, FIO, [Nationality code]
FROM Citizens;
GO

Триггер на VIEW (INSTEAD OF UPDATE):

CREATE TRIGGER trg_ViewCitizens_Update
ON View_CitizensSimple
INSTEAD OF UPDATE
AS
BEGIN
    UPDATE Citizens
    SET FIO = inserted.FIO,
        [Nationality code] = inserted.[Nationality code]
    FROM Citizens
    INNER JOIN inserted
        ON Citizens.IIN = inserted.IIN;
END;
GO

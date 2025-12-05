CREATE OR ALTER TRIGGER trg_DeleteSteelMark
ON SteelMarks
INSTEAD OF DELETE
AS
BEGIN
    -- ѕровер€ем, есть ли плавки с удал€емой маркой
    IF EXISTS (SELECT 1 FROM Melts WHERE MarkID IN (SELECT MarkID FROM deleted))
    BEGIN
        RAISERROR('Ќельз€ удалить марку стали: есть св€занные плавки!', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        -- ≈сли плавок нет, удал€ем марку стали
        DELETE FROM SteelMarks
        WHERE MarkID IN (SELECT MarkID FROM deleted);
    END
END;
GO
CREATE OR ALTER PROCEDURE GetMeltsByMarkAndFurnace
    @MarkID INT,
    @FurnaceID INT
AS
BEGIN
    SELECT *
    FROM Melts
    WHERE MarkID = @MarkID
      AND FurnaceID = @FurnaceID;
END;
GO
CREATE OR ALTER PROCEDURE GetElementRangeForMark
    @ElementID INT,
    @MarkID INT
AS
BEGIN
    SELECT 
        MarkID,
        ElementID,
        MinValue,
        MaxValue,
        (MaxValue - MinValue) AS Difference
    FROM MarkComponents
    WHERE ElementID = @ElementID
      AND MarkID = @MarkID;
END;
GO

CREATE OR ALTER FUNCTION dbo.GetAvgMeltQuantity(@MarkID INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @avg FLOAT;

    SELECT @avg = AVG(Tons)
    FROM Melts
    WHERE MarkID = @MarkID;

    RETURN @avg;
END;
GO
CREATE OR ALTER FUNCTION dbo.GetMeltsWithComponents(@MarkID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT m.MeltID, m.MeltDate, m.Tons, mc.ElementID, mc.Amount
    FROM Melts m
    JOIN MeltComponents mc ON m.MeltID = mc.MeltID
    WHERE m.MarkID = @MarkID
);
GO
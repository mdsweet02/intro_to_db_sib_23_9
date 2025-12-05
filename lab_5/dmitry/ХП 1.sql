CREATE OR ALTER PROCEDURE GetMarkComponentsSumIsOne
AS
BEGIN
    SELECT *
    FROM MarkComponents
    WHERE MinValue + MaxValue = 1;
END;
GO
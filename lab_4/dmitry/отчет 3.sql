CREATE OR ALTER VIEW V_MarkTotalsCurrentYear
AS
SELECT 
    sm.MarkID,
    sm.MarkName,
    SUM(m.Tons) AS TotalProduced
FROM Melts m
JOIN SteelMarks sm ON m.MarkID = sm.MarkID
WHERE YEAR(m.MeltDate) = YEAR(GETDATE())
GROUP BY sm.MarkID, sm.MarkName;
GO
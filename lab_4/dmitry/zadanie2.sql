CREATE OR ALTER VIEW V_MeltsFullInfo
AS
SELECT 
    m.MeltID,
    sm.MarkName,
    d.DeptName,
    f.FurnaceName,
    m.MeltDate,
    m.Tons
FROM Melts m
JOIN SteelMarks sm ON m.MarkID = sm.MarkID
JOIN Departments d ON m.DeptID = d.DeptID
JOIN Furnaces f ON m.FurnaceID = f.FurnaceID;
GO

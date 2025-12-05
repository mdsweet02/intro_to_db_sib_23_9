USE ChemLab;
GO
CREATE OR ALTER VIEW V_MeltSummaryByDepartment
AS
SELECT 
    d.DeptID AS DepartmentID,
    d.DeptName AS DepartmentName,
    m.MeltID,
    m.MarkID,
    m.FurnaceID,
    m.MeltDate,
    m.Tons AS Quantity
FROM Melts m
JOIN Departments d ON m.DeptID = d.DeptID;
GO

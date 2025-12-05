CREATE OR ALTER VIEW V_EmployeesDept
AS
SELECT 
    e.EmpID,
    e.FullName,
    e.DeptID
FROM Employees e;
GO
SELECT *
FROM V_MeltSummaryByDepartment
WHERE DepartmentID = 1 AND MONTH(MeltDate) = 1; -- если есть январь

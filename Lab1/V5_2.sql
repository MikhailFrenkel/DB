-- task1 
SELECT Name,
       GroupName
FROM AdventureWorks2012.HumanResources.Department
WHERE GroupName='Research and Development'
ORDER BY Name;

-- task2
SELECT MIN(SickLeaveHours) AS MinSickLeaveHours
From AdventureWorks2012.HumanResources.Employee;

-- task3
SELECT DISTINCT TOP (10)
  JobTitle,
  CASE CHARINDEX(' ', JobTitle)
    WHEN 0 THEN JobTitle
    ELSE SUBSTRING(JobTitle, 1, CHARINDEX(' ', JobTitle) - 1)
  END AS FirstWord
FROM AdventureWorks2012.HumanResources.Employee
ORDER BY JobTitle;
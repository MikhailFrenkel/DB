-- время работы каждого сотрудника
SELECT DISTINCT
  EmployeeDepartmentHistory.BusinessEntityID,
  JobTitle,
  Name,
  StartTime,
  EndTime
FROM HumanResources.EmployeeDepartmentHistory
JOIN HumanResources.Employee
  ON EmployeeDepartmentHistory.BusinessEntityID = Employee.BusinessEntityID
JOIN HumanResources.Shift
  ON EmployeeDepartmentHistory.ShiftID = Shift.ShiftID

  -- количество сотрудников в каждой группе отделов
SELECT
  GroupName,
  COUNT(*) AS EmpCount
FROM HumanResources.Department
JOIN HumanResources.EmployeeDepartmentHistory
  ON Department.DepartmentID = EmployeeDepartmentHistory.DepartmentID
JOIN HumanResources.Employee
  ON EmployeeDepartmentHistory.BusinessEntityID = HumanResources.Employee.BusinessEntityID
GROUP BY Department.GroupName

/* Вывести на экран почасовые ставки сотрудников,
 с указанием максимальной ставки для каждого отдела в столбце [MaxInDepartment].
  В рамках каждого отдела разбейте все ставки на группы, таким образом, 
  чтобы ставки с одинаковыми значениями входили в состав одной группы
*/
SELECT
  Name,
  Employee.BusinessEntityID,
  Rate,
  MAX(Rate) OVER (PARTITION BY Name) AS MaxInDepartment,
  DENSE_RANK() OVER (PARTITION BY Name ORDER BY Rate) AS RateGroup
FROM HumanResources.Department
JOIN HumanResources.EmployeeDepartmentHistory
  ON EmployeeDepartmentHistory.DepartmentID = Department.DepartmentID
JOIN HumanResources.Employee
  ON Employee.BusinessEntityID = EmployeeDepartmentHistory.BusinessEntityID
JOIN HumanResources.EmployeePayHistory
  ON Employee.BusinessEntityID = EmployeePayHistory.BusinessEntityID
GROUP BY Name,
         Employee.BusinessEntityID,
         EmployeePayHistory.Rate
ORDER BY Name;

-- a) добавьте в таблицу dbo.Employee поле EmpNum типа int;
ALTER TABLE dbo.Employee
ADD EmpNum INT

/*
b) объявите табличную переменную с такой же структурой как dbo.Employee и 
заполните ее данными из dbo.Employee. Поле VacationHours заполните из таблицы 
HumanResources.Employee. Поле EmpNum заполните последовательными номерами строк 
(примените оконные функции или создайте SEQUENCE);
*/
DECLARE @Var TABLE(
	BusinessEntityID INT NOT NULL,
	NationalIDNumber NVARCHAR(15) NOT NULL,
	LoginID NVARCHAR(256) NOT NULL,
	JobTitle NVARCHAR(50) NOT NULL,
	BirthDate DATE NOT NULL,
	MaritalStatus NCHAR(1) NOT NULL,
	Gender NCHAR(1) NOT NULL,
	HireDate DATE NOT NULL,
	VacationHours SMALLINT NOT NULL,
	SickLeaveHours SMALLINT NOT NULL,
	ModifiedDate DATETIME NOT NULL,
	EmpNum INT NOT NULL
);

INSERT INTO @Var (
	BusinessEntityID,
	NationalIDNumber,
	LoginID,
	JobTitle,
	BirthDate,
	MaritalStatus,
	Gender,
	HireDate,
	VacationHours,
	SickLeaveHours,
	ModifiedDate,
	EmpNum
) SELECT 
	BusinessEntityID,
	NationalIDNumber,
	LoginID,
	JobTitle,
	BirthDate,
	MaritalStatus,
	Gender,
	HireDate,
	(SELECT VacationHours FROM HumanResources.Employee WHERE HumanResources.Employee.BusinessEntityID = dbo.Employee.BusinessEntityID),
	SickLeaveHours,
	ModifiedDate,
	DENSE_RANK() OVER (ORDER BY BusinessEntityID)
FROM dbo.Employee

SELECT * FROM @Var

/*
c) обновите поля VacationHours и EmpNum в dbo.Employee данными из табличной переменной.
 Если значение в табличной переменной в поле VacationHours = 0 — оставьте старое значение;
*/
UPDATE dbo.Employee
SET dbo.Employee.VacationHours = Var.VacationHours
FROM @Var AS Var
WHERE Var.VacationHours != 0

UPDATE dbo.Employee
SET dbo.Employee.EmpNum = Var.EmpNum
FROM @Var AS Var

/*
d) удалите данные из dbo.Employee, EmailPromotion которых равен 0 в таблице Person.Person;
*/
DELETE dbo.Employee 
FROM dbo.Employee
JOIN Person.Person ON dbo.Employee.BusinessEntityID = Person.BusinessEntityID
WHERE Person.EmailPromotion = 0 

/*
e) удалите поле EmpName из таблицы, удалите все созданные ограничения и значения по умолчанию.
*/
ALTER TABLE dbo.Employee DROP COLUMN EmpNum
ALTER TABLE dbo.Employee DROP CONSTRAINT AK_Employee_NationalIDNumber_Unique
ALTER TABLE dbo.Employee DROP CONSTRAINT CHK_Employee_VacationHours_Positive
ALTER TABLE dbo.Employee DROP CONSTRAINT DF_Employee_VacationHours

-- f) удалите таблицу dbo.Employee.
DROP TABLE dbo.Employee
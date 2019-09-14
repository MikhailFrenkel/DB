/*	
a) �������� ������� dbo.Employee � ����� �� ���������� ��� HumanResources.Employee,
����� ����� OrganizationLevel, SalariedFlag, CurrentFlag, � ����� ����� ����� � ����� hierarchyid,
uniqueidentifier, �� ������� �������, ����������� � ��������
*/
CREATE TABLE dbo.Employee (
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
  CONSTRAINT PK_Employee_BusinessEntityID PRIMARY KEY CLUSTERED (BusinessEntityID)
)

  -- b) ��������� ���������� ALTER TABLE, �������� ��� ������� dbo.Employee ����������� UNIQUE ��� ���� NationalIDNumber
ALTER TABLE dbo.Employee 
ADD CONSTRAINT AK_Employee_NationalIDNumber_Unique UNIQUE (NationalIDNumber)

/*
c) ��������� ���������� ALTER TABLE, �������� ��� ������� dbo.Employee ����������� ��� ���� VacationHours,
 ����������� ���������� ����� ���� ���������� �������� ��� ������� 0;
*/
ALTER TABLE dbo.Employee
ADD CONSTRAINT CHK_Employee_VacationHours_Positive CHECK (VacationHours > 0)

/*
d) ��������� ���������� ALTER TABLE, �������� ��� ������� dbo.Employee 
����������� DEFAULT ��� ���� VacationHours, ������� �������� �� ��������� 144;
*/
ALTER TABLE dbo.Employee
ADD CONSTRAINT DF_Employee_VacationHours DEFAULT 144 FOR VacationHours

/*
e) ��������� ����� ������� ������� �� HumanResources.Employee � ����������� �� ������� �Buyer�.
 �� ���������� ��� ������� ���� VacationHours, ����� ��� ����������� ���������� �� ���������;
*/
INSERT INTO dbo.Employee (
	BusinessEntityID,
	NationalIDNumber,
	LoginID,
	JobTitle,
	BirthDate,
	MaritalStatus,
	Gender,
	HireDate,
	SickLeaveHours,
	ModifiedDate
) SELECT
	BusinessEntityID,
	NationalIDNumber,
	LoginID,
	JobTitle,
	BirthDate,
	MaritalStatus,
	Gender,
	HireDate,
	SickLeaveHours,
	ModifiedDate 
FROM HumanResources.Employee
WHERE JobTitle = 'Buyer'

/*
f) �������� ��� ���� ModifiedDate �� DATE � ��������� ���������� null �������� ��� ����.
*/
ALTER TABLE dbo.Employee
ALTER COLUMN ModifiedDate DATE NULL
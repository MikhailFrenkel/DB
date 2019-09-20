/*
Создайте scalar-valued функцию, которая будет принимать в качестве входного параметра id 
модели для продукта (Production.ProductModel.ProductModelID) и возвращать суммарную стоимость 
продуктов данной модели (Production.Product.ListPrice).
*/
CREATE FUNCTION [Production].[GetProductionSumOfPrice](@ProductModelID INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @result MONEY
	SELECT @result = SUM([Product].[ListPrice])
	FROM [Production].[Product]
	WHERE [Product].[ProductModelID] = @ProductModelID
	RETURN @result
END;
GO

/*
Создайте inline table-valued функцию, которая будет принимать в качестве 
входного параметра id заказчика (Sales.Customer.CustomerID), а возвращать 
2 последних заказа, оформленных заказчиком из Sales.SalesOrderHeader.
*/
CREATE FUNCTION [Sales].GetLastTwoOrdersByCustomerID(@CustomerID INT)
RETURNS TABLE AS RETURN (
	SELECT TOP(2)
		[SalesOrderID],
		[RevisionNumber],
		[OrderDate],
		[DueDate],
		[ShipDate],
		[Status],
		[OnlineOrderFlag],
		[SalesOrderNumber],
		[PurchaseOrderNumber],
		[AccountNumber],
		[CustomerID],
		[SalesPersonID],
		[TerritoryID],
		[BillToAddressID],
		[ShipToAddressID],
		[ShipMethodID],
		[CreditCardID],
		[CreditCardApprovalCode],
		[CurrencyRateID],
		[SubTotal],
		[TaxAmt],
		[Freight],
		[TotalDue],
		[Comment],
		[rowguid],
		[ModifiedDate]
	FROM [Sales].[SalesOrderHeader]
	WHERE [CustomerID] = @CustomerID
	ORDER BY [OrderDate] DESC
);
GO

/*
Вызовите функцию для каждого заказчика, применив оператор CROSS APPLY.
 Вызовите функцию для каждого заказчика, применив оператор OUTER APPLY.
*/
SELECT * FROM [Sales].[Customer] CROSS APPLY [Sales].[GetLastTwoOrdersByCustomerID]([CustomerID]);
SELECT * FROM [Sales].[Customer] OUTER APPLY [Sales].[GetLastTwoOrdersByCustomerID]([CustomerID]);
GO

/*
Измените созданную inline table-valued функцию, сделав ее multistatement table-valued 
(предварительно сохранив для проверки код создания inline table-valued функции).
*/
CREATE FUNCTION [Sales].[GetLastTwoOrdersByCustomerID](@CustomerID INT)
RETURNS @result TABLE(
	[SalesOrderID] INT NOT NULL,
	[RevisionNumber] TINYINT NOT NULL,
	[OrderDate] DATETIME NOT NULL,
	[DueDate] DATETIME NOT NULL,
	[ShipDate] DATETIME NULL,
	[Status] TINYINT NOT NULL,
	[OnlineOrderFlag] dbo.Flag NOT NULL,
	[SalesOrderNumber] NVARCHAR(23),
	[PurchaseOrderNumber] dbo.OrderNumber NULL,
	[AccountNumber] dbo.AccountNumber NULL,
	[CustomerID] INT NOT NULL,
	[SalesPersonID] INT NULL,
	[TerritoryID] INT NULL,
	[BillToAddressID] INT NOT NULL,
	[ShipToAddressID] INT NOT NULL,
	[ShipMethodID] INT NOT NULL,
	[CreditCardID] INT NULL,
	[CreditCardApprovalCode] VARCHAR(15) NULL,
	[CurrencyRateID] INT NULL,
	[SubTotal] MONEY NOT NULL ,
	[TaxAmt] MONEY NOT NULL,
	[Freight] MONEY NOT NULL,
	[TotalDue] INT NOT NULL,
	[Comment] NVARCHAR(128) NULL,
	[rowguid] UNIQUEIDENTIFIER ROWGUIDCOL  NOT NULL,
	[ModifiedDate] DATETIME NOT NULL
) AS BEGIN
	INSERT INTO @result
	SELECT TOP(2)
		[SalesOrderID],
		[RevisionNumber],
		[OrderDate],
		[DueDate],
		[ShipDate],
		[Status],
		[OnlineOrderFlag],
		[SalesOrderNumber],
		[PurchaseOrderNumber],
		[AccountNumber],
		[CustomerID],
		[SalesPersonID],
		[TerritoryID],
		[BillToAddressID],
		[ShipToAddressID],
		[ShipMethodID],
		[CreditCardID],
		[CreditCardApprovalCode],
		[CurrencyRateID],
		[SubTotal],
		[TaxAmt],
		[Freight],
		[TotalDue],
		[Comment],
		[rowguid],
		[ModifiedDate]
	FROM [Sales].[SalesOrderHeader]
	WHERE [CustomerID] = @CustomerID
	ORDER BY [OrderDate] DESC
	RETURN
END;
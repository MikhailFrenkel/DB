/*
a) Создайте представление VIEW, отображающее данные из таблиц Sales.CreditCard и Sales.PersonCreditCard. 
Сделайте невозможным просмотр исходного кода представления. Создайте уникальный кластерный индекс в 
представлении по полю CreditCardID.
*/
CREATE VIEW [Sales].[ViewExtCreditCard] (
	[CreditCardID],
	[CardType],
	[CardNumber],
	[ExpMonth],
	[ExpYear],
	[ModifiedDate],
	[BusinessEntityID],
	[PersonModifiedDate]
) WITH ENCRYPTION, SCHEMABINDING AS SELECT
	[CC].[CreditCardID],
	[CC].[CardType],
	[CC].[CardNumber],
	[CC].[ExpMonth],
	[CC].[ExpYear],	
	[CC].[ModifiedDate],
	[PCC].[BusinessEntityID],
	[PCC].[ModifiedDate]
FROM [Sales].[CreditCard] AS [CC] JOIN [Sales].[PersonCreditCard] AS [PCC]
ON [CC].[CreditCardID] = [PCC].[CreditCardID];

CREATE UNIQUE CLUSTERED INDEX [AK_ViewExtCreditCard_CreditCardID] ON [Sales].[ViewExtCreditCard] ([CreditCardID]);
GO

/*
b) Создайте три INSTEAD OF триггера для представления на операции INSERT, UPDATE, DELETE. 
Каждый триггер должен выполнять соответствующие операции в таблицах Sales.CreditCard и Sales.PersonCreditCard 
для указанного BusinessEntityID. Обновление должно происходить только в таблице Sales.CreditCard. 
Удаление строк из таблицы Sales.CreditCard производите только в том случае, если удаляемые строки больше не 
ссылаются на Sales.PersonCreditCard.
*/
CREATE TRIGGER [Sales].[TriggerViewExtCreditCardInsteadInsert] ON [Sales].[ViewExtCreditCard]
INSTEAD OF INSERT AS
BEGIN
	INSERT INTO [Sales].[CreditCard] ([CardNumber], [CardType], [ExpMonth], [ExpYear], [ModifiedDate])
	SELECT [CardNumber], [CardType], [ExpMonth], [ExpYear], [ModifiedDate]
	FROM [inserted]
	INSERT INTO [Sales].[PersonCreditCard] ([BusinessEntityID], [CreditCardID], [ModifiedDate])
	SELECT [inserted].[BusinessEntityID], [Sales].[CreditCard].[CreditCardID], GETDATE()
	FROM [inserted] JOIN [Sales].[CreditCard] ON [inserted].[CardNumber] = [Sales].[CreditCard].[CardNumber]
END;

CREATE TRIGGER [Sales].[TriggerViewExtCreditCardInsteadUpdate] ON [Sales].[ViewExtCreditCard]
INSTEAD OF UPDATE AS
BEGIN
	UPDATE [Sales].[CreditCard] SET
		[CardNumber] = [inserted].[CardNumber],
		[CardType] = [inserted].[CardType],
		[ExpMonth] = [inserted].[ExpMonth],
		[ExpYear] = [inserted].[ExpYear],
		[ModifiedDate] = [inserted].[ModifiedDate]
	FROM [inserted]
	WHERE [inserted].[CreditCardID] = [Sales].[CreditCard].[CreditCardID]
END;

CREATE TRIGGER [Sales].[TriggerViewExtCreditCardInsteadDelete] ON [Sales].[ViewExtCreditCard]
INSTEAD OF DELETE AS
BEGIN
	DELETE FROM [Sales].[PersonCreditCard] WHERE [BusinessEntityID] IN (SELECT [BusinessEntityID] FROM [deleted])
	DELETE FROM [Sales].[CreditCard] WHERE [CreditCardID] IN (SELECT [CreditCardID] FROM [deleted]) 
								AND [CreditCardID] NOT IN (SELECT [CreditCardID] FROM [Sales].[PersonCreditCard])
END;
GO

/*
c) Вставьте новую строку в представление, указав новые данные для CreditCard для существующего
 BusinessEntityID (например 1). Триггер должен добавить новые строки в таблицы Sales.CreditCard и 
 Sales.PersonCreditCard. Обновите вставленные строки через представление. Удалите строки.
*/
INSERT INTO [Sales].[ViewExtCreditCard] (
	[CardNumber],
	[CardType],
	[ExpMonth],
	[ExpYear],
	[BusinessEntityID],
	[ModifiedDate]
) VALUES ('8976685649', 'ViewCardType', 5, 2021, 1, GetDate());

UPDATE [Sales].[ViewExtCreditCard] SET
	[CardNumber] = '132456',
	[CardType] = 'Default',
	[ExpMonth] = 4,
	[ExpYear] = 2022
WHERE [CardNumber] = '8976685649';

DELETE FROM [Sales].[ViewExtCreditCard] WHERE [CardNumber] = '132456';
GO
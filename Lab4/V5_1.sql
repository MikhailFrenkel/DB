-- a) Создайте таблицу Sales.CreditCardHst, которая будет хранить информацию об изменениях в таблице Sales.CreditCard.
/*
Обязательные поля, которые должны присутствовать в таблице: ID — первичный ключ IDENTITY(1,1);
 Action — совершенное действие (insert, update или delete); ModifiedDate — дата и время, когда была совершена операция; 
 SourceID — первичный ключ исходной таблицы; UserName — имя пользователя, совершившего операцию. Создайте другие поля,
 если считаете их нужными.
*/
CREATE TABLE [Sales].[CreditCardHst] (
	[ID] INT IDENTITY(1, 1) PRIMARY KEY,
	[Action] CHAR(6) NOT NULL CHECK ([Action] IN('INSERT', 'UPDATE', 'DELETE')),
	[ModifiedDate] DATETIME NOT NULL,
	[SourceID] INT NOT NULL,
	[UserName] VARCHAR(50) NOT NULL
);

/*
b) Создайте один AFTER триггер для трех операций INSERT, UPDATE, DELETE для таблицы Sales.CreditCard. 
Триггер должен заполнять таблицу Sales.CreditCardHst с указанием типа операции в поле Action 
в зависимости от оператора, вызвавшего триггер.
*/
CREATE TRIGGER [Sales].[CreditCartAfterTrigger]
ON [Sales].[CreditCard]
AFTER INSERT, UPDATE, DELETE AS
	INSERT INTO [Sales].[CreditCardHst] ([Action], [ModifiedDate], [SourceID], [UserName])
	SELECT
		CASE WHEN [inserted].[CreditCardID] IS NULL THEN 'DELETE'
			 WHEN [deleted].[CreditCardID] IS NULL  THEN 'INSERT'
													ELSE 'UPDATE'
		END,
	GetDate(),
	COALESCE([inserted].[CreditCardID], [deleted].[CreditCardID]),
	User_Name()
	FROM [inserted] FULL OUTER JOIN [deleted]
	ON [inserted].[CreditCardID] = [deleted].[CreditCardID];

-- c) Создайте представление VIEW, отображающее все поля таблицы Sales.CreditCard.
CREATE VIEW [Sales].[ViewCreditCard] AS SELECT * FROM [Sales].[CreditCard];

/*
d) Вставьте новую строку в Sales.CreditCard через представление. Обновите вставленную строку. 
Удалите вставленную строку. Убедитесь, что все три операции отображены в Sales.CreditCardHst.
*/
INSERT INTO [Sales].[ViewCreditCard] ([CardNumber], [CardType], [ExpMonth], [ExpYear], [ModifiedDate])
VALUES (5615465414656541, 'CardType', 10, 2022, GetDate());

UPDATE [Sales].[CreditCard] SET [CardType] = 'Type' WHERE [CardNumber] = 5615465414656541;

DELETE [Sales].[CreditCard] WHERE [CardNumber] = 5615465414656541;

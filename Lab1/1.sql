CREATE DATABASE [Mikhail_Frenkel_DB];
GO

CREATE SCHEMA [scales];
GO

CREATE SCHEMA [persons];
GO

CREATE TABLE [scales].[Orders] (OrderNum INT NULL);

BACKUP DATABASE [Mikhail_Frenkel_DB] TO DISK='D:\�����\4 ����\��\Lab1\Mikhail_Frenkel_DB.bak';
GO

DROP DATABASE [Mikhail_Frenkel_DB];
GO

RESTORE DATABASE [Mikhail_Frenkel_DB] FROM DISK='D:\�����\4 ����\��\Lab1\Mikhail_Frenkel_DB.bak';
GO
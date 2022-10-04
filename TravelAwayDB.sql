USE [master]
GO
IF (EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE ('[' + name + ']' = N'TravelAwayDB'OR name = N'TravelAwayDB')))
DROP DATABASE TravelAwayDB
GO

CREATE DATABASE TravelAwayDB
GO
 
USE TravelAwayDB
GO
CREATE TABLE Customer(
 [EmailId]  VARCHAR (50) CONSTRAINT [chk_EmailId] CHECK ([EmailId] LIKE '%_@_%._%') PRIMARY KEY,
 [FirstName] VARCHAR (50) NOT NULL,
 [LastName] VARCHAR (50) NOT NULL,
 [Password] VARCHAR (16) NOT NULL,
 [DateOfBirth] DATE NOT NULL CHECK (DateOfBirth <= GETDATE()),
 [Address] VARCHAR (50) NOT NULL,
 [Gender] VARCHAR(10) CHECK ([Gender] = 'Male ' OR [Gender]='Female')  NOT NULL,
 [ContactNumber]  VARCHAR (10) NOT NULL,
)
GO
INSERT INTO Customer VALUES('xyz@gmail.com','albert','roy','Albert@1223','1990-03-02','mangalore mudipu','Male','9876543210')




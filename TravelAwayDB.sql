--DROP Scripts
USE [master]
GO

IF (EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE ('[' + name + ']' = N'TravelAwayDB'OR name = N'TravelAwayDB')))
DROP DATABASE TravelAwayDB

CREATE DATABASE TravelAwayDB
GO

USE TravelAwayDB
GO

IF OBJECT_ID('Packages')  IS NOT NULL
DROP TABLE Packages
GO

IF OBJECT_ID('Categories')  IS NOT NULL
DROP TABLE Categories
GO

IF OBJECT_ID('Users')  IS NOT NULL
DROP TABLE Users
GO

IF OBJECT_ID('Roles')  IS NOT NULL
DROP TABLE Roles
GO

IF OBJECT_ID('usp_RegisterUser')  IS NOT NULL
DROP PROC usp_RegisterUser
GO

IF OBJECT_ID('usp_AddCategory') IS NOT NULL
DROP PROC usp_AddCategory
GO

IF OBJECT_ID('usp_AddPackage')  IS NOT NULL
DROP PROC usp_AddPackage
GO


IF OBJECT_ID('usp_GetPackagesOnCategoryId')  IS NOT NULL
DROP PROC usp_GetPackagesOnCategoryId
GO


IF OBJECT_ID('ufn_GenerateNewPackageId')  IS NOT NULL
DROP FUNCTION ufn_GenerateNewPackageId
GO

IF OBJECT_ID('ufn_GetPackageDetails')  IS NOT NULL
DROP FUNCTION ufn_GetPackageDetails
GO

IF OBJECT_ID('ufn_GetAllPackageDetails')  IS NOT NULL
DROP FUNCTION ufn_GetAllPackageDetails
GO

IF OBJECT_ID('ufn_ValidateUserCredentials')  IS NOT NULL
DROP FUNCTION ufn_ValidateUserCredentials
GO

IF OBJECT_ID('ufn_CheckEmailId')  IS NOT NULL
DROP FUNCTION ufn_CheckEmailId
GO

IF OBJECT_ID('ufn_GetCategories')  IS NOT NULL
DROP FUNCTION ufn_GetCategories
GO

IF OBJECT_ID('ufn_GenerateNewCategoryId')  IS NOT NULL
DROP FUNCTION ufn_GenerateNewCategoryId
GO


CREATE TABLE Roles
(
	[RoleId] TINYINT CONSTRAINT pk_RoleId PRIMARY KEY IDENTITY,
	[RoleName] VARCHAR(20) CONSTRAINT uq_RoleName UNIQUE
)
GO 

CREATE TABLE Users
(
	
	
	[EmailId] VARCHAR(50) CONSTRAINT pk_EmailId PRIMARY KEY,
	[FirstName] VARCHAR(50) NOT NULL,
	[LastName] VARCHAR(50) NOT NULL,
	[ContactNumber] VARCHAR(10) NOT NULL,
	[UserPassword] VARCHAR(15) NOT NULL,
	[RoleId] TINYINT CONSTRAINT fk_RoleId REFERENCES Roles(RoleId),
	[Gender] CHAR CONSTRAINT chk_Gender CHECK(Gender='F' OR Gender='M') NOT NULL,
	[DateOfBirth] DATE CONSTRAINT chk_DateOfBirth CHECK(DateOfBirth<GETDATE()) NOT NULL,
	[Address] VARCHAR(200) NOT NULL
	
)
GO

CREATE TABLE Categories
(
	[CategoryId] VARCHAR(3) CONSTRAINT pk_CategoryId PRIMARY KEY,
	[CategoryName] VARCHAR(20) CONSTRAINT uq_CategoryName UNIQUE NOT NULL 
)
GO

CREATE TABLE Packages
(
	[PackageId] CHAR(4) CONSTRAINT pk_PackageId PRIMARY KEY CONSTRAINT chk_PackageId CHECK(PackageId LIKE 'P%'),
	[PackageName] VARCHAR(50) CONSTRAINT uq_PackageName UNIQUE NOT NULL,
	[CategoryId] VARCHAR(3) CONSTRAINT fk_CategoryId REFERENCES Categories(CategoryId),
	[Price] NUMERIC(8) CONSTRAINT chk_Price CHECK(Price>0) NOT NULL,
	[Types]  VARCHAR(15) NOT NULL,
	[Description] VARCHAR(200) NOT NULL,
	[Paths] VARCHAR(MAX) ,
	[PlacesToVisit] VARCHAR(50) NOT NULL,
	[DayNight] VARCHAR(4) NOT NULL,
	[Accomodation] BIT NOT NULL
)
GO


CREATE INDEX ix_RoleId ON Users(RoleId)
GO




CREATE FUNCTION ufn_CheckEmailId
(
	@EmailId VARCHAR(50)
)
RETURNS BIT
AS
BEGIN
	
	DECLARE @ReturnValue BIT
	
	IF NOT EXISTS (SELECT EmailId FROM Users WHERE EmailId=@EmailId)
		SET @ReturnValue=1
	
	ELSE SET @ReturnValue=0
	
	RETURN @ReturnValue

END
GO

CREATE FUNCTION ufn_ValidateUserCredentials
(
                @EmailId VARCHAR(50),
                @UserPassword VARCHAR(15)
)
RETURNS INT
AS
BEGIN
DECLARE @RoleId INT

                                SELECT @RoleId=RoleId FROM Users WHERE EmailId=@EmailId AND UserPassword=@UserPassword
                                
                                RETURN @RoleId
END
GO

CREATE FUNCTION ufn_GetCategories()
RETURNS TABLE 
AS
	RETURN (SELECT * FROM Categories)
GO


CREATE FUNCTION ufn_GetPackageDetailsCategoryId(@CategoryId varchar)
RETURNS TABLE 
AS
RETURN (SELECT PackageId,PackageName,Price,Types,Description,Paths,PlacesToVisit,DayNight,Accomodation FROM Packages WHERE CategoryId=@CategoryId)
GO

CREATE FUNCTION ufn_GetPackageDetailsByType(@Types VARCHAR)
RETURNS TABLE 
AS
RETURN (SELECT PackageId,PackageName,Price,Types,Description,Paths,PlacesToVisit,DayNight,Accomodation FROM Packages WHERE Types=@Types)
GO

CREATE FUNCTION ufn_GenerateNewPackageId()
RETURNS CHAR(4)
AS
BEGIN

	DECLARE @PackageId CHAR(4)
	
	IF NOT EXISTS(SELECT PackageId FROM Packages)
		SET @PackageId='P100'
		
	ELSE
		SELECT @PackageId='P'+CAST(CAST(SUBSTRING(MAX(PackageId),2,3) AS INT)+1 AS CHAR) FROM Packages

	RETURN @PackageId
	
END
GO

CREATE PROCEDURE usp_RegisterUser
(
	@FirstName VARCHAR(50),
	@LastName VARCHAR(50),
	@ContactNumber VARCHAR(10),
	@UserPassword VARCHAR(15),
	@Gender CHAR,
	@EmailId VARCHAR(50),
	@DateOfBirth DATE,
	@Address VARCHAR(200)
)
AS
BEGIN
	DECLARE @RoleId TINYINT,
		@retval int
	BEGIN TRY
		IF (LEN(@EmailId)<4 OR LEN(@EmailId)>50 OR (@EmailId IS NULL))
			SET @retval = -1
		
		ELSE IF (@FirstName IS NULL)
			SET @retval = -2
			
		ELSE IF (@LastName IS NULL)
			SET @retval = -3
		
		ELSE IF (@ContactNumber IS NULL)
			SET @retval = -4
		
		ELSE IF (LEN(@UserPassword)<8 OR LEN(@UserPassword)>15 OR (@UserPassword IS NULL))
			SET @retval = -5
		ELSE IF (@Gender<>'F' AND @Gender<>'M' OR (@Gender Is NULL))
			SET @retval = -6		
		ELSE IF (@DateOfBirth>=CAST(GETDATE() AS DATE) OR (@DateOfBirth IS NULL))
			SET @retval = -7
		ELSE IF DATEDIFF(d,@DateOfBirth,GETDATE())<6570
			SET @retval = -8
		ELSE IF (@Address IS NULL)
			SET @retval = -9
		ELSE 
		     
			BEGIN
				SELECT @RoleId=RoleId FROM Roles WHERE RoleName='Customer'
				INSERT INTO Users VALUES 
				(@EmailId,@FirstName,@LastName,@ContactNumber,@UserPassword, @RoleId, @Gender, @DateOfBirth, @Address)
				SET @retval = 1			
			END
		SELECT @retval 
		END TRY
		BEGIN CATCH
			SET @retval = -99
			SELECT @retval 
		END CATCH
		
END
GO

--insertion scripts for roles
SET IDENTITY_INSERT Roles ON
INSERT INTO Roles (RoleId, RoleName) VALUES (1, 'Admin')
INSERT INTO Roles (RoleId, RoleName) VALUES (2, 'Customer')
SET IDENTITY_INSERT Roles OFF


-- insertion script for Categories
INSERT INTO Categories (CategoryId, CategoryName) VALUES ('ADV', 'Adventure')
INSERT INTO Categories (CategoryId, CategoryName) VALUES ('NAT', 'Nature')
INSERT INTO Categories (CategoryId, CategoryName) VALUES ('REG', 'Religious')
INSERT INTO Categories (CategoryId, CategoryName) VALUES ('VIL', 'Village')
INSERT INTO Categories (CategoryId, CategoryName) VALUES ('WLD', 'Wildlife')
GO

-- insertion script for Users
INSERT INTO Users( EmailId,FirstName,LastName,ContactNumber,UserPassword,RoleId,Gender, DateOfBirth,Address) VALUES('Franken@gmail.com','Frank','Job','1234567890','ABCDE@1234',2,'M','1976-08-26','Fauntleroy Circus')
GO

-- insertion script for Packages
INSERT INTO Packages(PackageId,PackageName,CategoryId,Price,Types,Description,Paths,PlacesToVisit,DayNight,Accomodation) VALUES('P101','Andaman and Nicobar','ADV',18000000.00,'IND','','A set of island in the Bay of Bengal','Sundarban,Kolkata,Howrah','7/8',1)

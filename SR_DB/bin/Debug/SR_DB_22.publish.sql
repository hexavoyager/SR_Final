﻿/*
Deployment script for SR_DB

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "SR_DB"
:setvar DefaultFilePrefix "SR_DB"
:setvar DefaultDataPath "C:\Users\Norman\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\"
:setvar DefaultLogPath "C:\Users\Norman\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
/*
The column [dbo].[Bookings].[is_1stclass] on table [dbo].[Bookings] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column [dbo].[Bookings].[price] on table [dbo].[Bookings] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
*/

IF EXISTS (select top 1 1 from [dbo].[Bookings])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
/*
The column [dbo].[Clients].[is_healthy] on table [dbo].[Clients] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
*/

IF EXISTS (select top 1 1 from [dbo].[Clients])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'Altering Table [dbo].[Bookings]...';


GO
ALTER TABLE [dbo].[Bookings]
    ADD [is_1stclass] BIT NOT NULL,
        [price]       INT NOT NULL;


GO
PRINT N'Altering Table [dbo].[Clients]...';


GO
ALTER TABLE [dbo].[Clients]
    ADD [is_healthy] BIT NOT NULL;


GO
PRINT N'Creating Procedure [dbo].[AddBooking]...';


GO
CREATE PROCEDURE [dbo].[AddBooking]
	@clientId INT,
	@planet BIT,
	@stopover BIT,
	@planet_portId INT,
	@dateA DATETIME,
	@dateB DATETIME,
	@is_1stclass BIT,
	@price INT
AS
BEGIN
	INSERT INTO [Bookings] (clientId, planet, stopover, planet_portId, dateA, dateB, is_1stclass, price) VALUES (@clientId, @planet, @stopover, @planet_portId, @dateA, @dateB, @is_1stclass, @price);
	RETURN 0
end
GO
-- Refactoring step to update target server with deployed transaction logs

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'd0d3db49-7ddf-4426-95b0-229a585e758d')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('d0d3db49-7ddf-4426-95b0-229a585e758d')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '2c40f582-5f9e-46a9-a7ff-c454211c84d9')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('2c40f582-5f9e-46a9-a7ff-c454211c84d9')

GO

GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

--INSERT INTO [Clients] ([fname], [lname], [bdate], [email], [pass], [ccard], [idcard], [book_count], [is_vip], [is_healthy]) VALUES ('David', 'Bowman', 30/05/1970, 'db@gmail.com', 'pw', 'XXXX-XXXX-XXXX-XXXX', 'A9F41KV', DEFAULT, 1, 1);
--INSERT INTO [Clients] ([fname], [lname], [bdate], [email], [pass], [ccard], [idcard], [book_count], [is_vip], [is_healthy]) VALUES ('John', 'Doe', 02/07/1978, 'jd@gmail.com', 'pw', 'XXXX-XXXX-XXXX-XXXX', 'Y3GN98B', DEFAULT, DEFAULT, 1);

--INSERT INTO [Planets] (
--    [name],
--    [capacity], 
--    [distance_m], 
--    [distance_h], 
--    [fuel_req], 
--    [atmosphere], 
--    [ports_count]
--    ) VALUES ('Saturn', 437, 120, 191, 50000, 'hydrogen', 1);

--INSERT INTO [Planets] (
--    [name],
--    [capacity], 
--    [distance_m], 
--    [distance_h], 
--    [fuel_req], 
--    [atmosphere], 
--    [ports_count]
--    ) VALUES ('Jupiter', 698, 444, 57, 3100, 'helium', 2);

--INSERT INTO [Users] ([fname], [lname], [bdate], [email], [pass], [ccard], [idcard], [book_count], [isAdmin]) VALUES ('Hal', '9000', 12/01/1992, 'h9@srite.com', 'pw', null, null, DEFAULT, 1);
GO

GO
PRINT N'Update complete.';


GO

SELECT @@VERSION AS [SQLServerVersion];

SELECT SERVERPROPERTY('ProductVersion') AS ProductVersion,
SERVERPROPERTY('ProductLevel') AS ProductLevel,
SERVERPROPERTY('Edition') AS Edition; 

EXECUTE sp_helpdb;

SELECT
  SERVERPROPERTY('MachineName') AS MachineName,
  SERVERPROPERTY('InstanceName') AS InstanceName,
  SERVERPROPERTY('ProductVersion') AS ProductVersion,
  SERVERPROPERTY('Edition') AS Edition,
  SERVERPROPERTY('ProductLevel') AS ProductLevel,
  SERVERPROPERTY('IsClustered') AS IsClustered;

SELECT @@VERSION AS VersionText;

SELECT cpu_count FROM sys.dm_os_sys_info;

SELECT @@MAX_CONNECTIONS AS MaxConnections;

EXEC xp_instance_regread
    N'HKEY_LOCAL_MACHINE',
    N'Software\Microsoft\MSSQLServer\Setup',
    N'SQLPath';

CREATE DATABASE Stud_Zhunusbekov_David_Yurievich_2
ON 
( NAME = Stud_Zhunusbekov_DY_2_root,
  FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Stud_Zhunusbekov_David_Yurievich_2.mdf',
  SIZE = 10MB,
  MAXSIZE = 50MB,
  FILEGROWTH = 5MB )
LOG ON
( NAME = Stud_Zhunusbekov_DY_2_log,
  FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Stud_Zhunusbekov_David_Yurievich_2_log.ldf',
  SIZE = 5MB,
  MAXSIZE = 25MB,
  FILEGROWTH = 5MB );

SELECT name, database_id, create_date
FROM sys.databases;

BACKUP DATABASE [Stud_<ФИО>_1]
TO DISK = N'C:\Backups\C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Stud_Zhunusbekov David Yurievich_1.bak'
WITH INIT, NAME = N'Full backup Stud_Zhunusbekov David Yurievich_1', STATS = 10;
GO

ALTER DATABASE [Stud_Жунусбеков Давид Юрьевич_1] MODIFY NAME = [Stud_Zhunusbekov David Yurievich_1];

EXEC sp_helpdb [Stud_Zhunusbekov_David_Yurievich_2];
DBCC SHRINKDATABASE ([Stud_Zhunusbekov_David_Yurievich_2]);

ALTER DATABASE [Stud_Zhunusbekov_David_Yurievich_2] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE [Stud_Zhunusbekov_David_Yurievich_2];
SELECT name, database_id, create_date, state_desc
FROM sys.databases
ORDER BY name;

ALTER DATABASE [Stud_Zhunusbekov David Yurievich_1] SET OFFLINE;
ALTER DATABASE [Stud_Zhunusbekov David Yurievich_1] SET ONLINE;
select @@VERSION as Версия_MSSQL



select *
from sys.databases 



create database stud_ivashin_mikhail_2
ON
(NAME = stud_ivashin_mikhail_2_root,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\stud_ivashin_mikhail_2root.mdf',
	SIZE = 10,
	MAXSIZE = 50,
	FILEGROWTH = 5)
LOG ON
(NAME = stud_ivashin_mikhail_2_log,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\stud_ivashin_mikhail_2log.ldf',
	SIZE = 5,
	MAXSIZE = 25,
	FILEGROWTH = 5),




sp_helpdb stud_ivashin_mikhail_1
sp_helpdb stud_ivashin_mikhail_2



BACKUP database stud_ivashin_mikhail_1
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\stud_ivashin_mikhail_1.bak'



sp_renamedb @dbname = 'stud_ivashin_mikhail_1', @newname = 'stud_ivashin_mikhail'



DBCC SHRINKDATABASE (stud_ivashin_mikhail_2, 25);



 use master 
 alter database stud_ivashin_mikhail_2 set single_user with rollback immediate
 drop database stud_ivashin_mikhail_2

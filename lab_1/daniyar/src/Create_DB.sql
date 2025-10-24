CREATE DATABASE Stud_Ibraev_Nurgali
ON(
	NAME=Stud_Ibraev_Nurgali_dat,
	FILENAME = 'D:\À‡·_1\Stud_Ibraev_Nurgali.mdf', 
    SIZE = 10MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 5MB)
LOG ON
(NAME = Stud_Ibraev_Nurgali_log,
	FILENAME = 'D:\À‡·_1\Stud_Ibraev_Nurgali.ldf',
	SIZE = 5MB,
	MAXSIZE = 25MB,
	FILEGROWTH = 5 MB)

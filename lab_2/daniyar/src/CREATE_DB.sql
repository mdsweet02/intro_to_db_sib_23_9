USE [master]
CREATE DATABASE Дипломное_проектирование 
ON(
	NAME=Дипломное_проектирование_dat,
	FILENAME = N'C:\Users\ayatd\Desktop\Предметы 5 семестр\Введение в Базы Данных\Дипломное проектирование\Дипломное проектирование.mdf',
	SIZE = 10MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 5MB
)

LOG ON(
	NAME = Дипломное_проектирование_log,
	FILENAME = N'C:\Users\ayatd\Desktop\Предметы 5 семестр\Введение в Базы Данных\Дипломное проектирование\Дипломное проектирование.ldf',
	SIZE = 10MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 5MB
)
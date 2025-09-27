CREATE DATABASE Kabildina_Alsiya
ON
(
    NAME = Kabildina_Alsiya_dat,
    FILENAME = 'C:\Users\KSTU.Student\Desktop\temp1\Kabildina_Alsiya.mdf',
    SIZE = 10MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 5MB
)
LOG ON
(
    NAME = Kabildina_Alsiya_log,	
    FILENAME = 'C:\Users\KSTU.Student\Desktop\temp1\Kabildina_Alsiya.ldf',
    SIZE = 10MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 5MB
);
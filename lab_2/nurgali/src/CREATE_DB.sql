CREATE DATABASE ”гольный_разрез
ON
(
	NAME = '”гольный_разрез_dat',
	FILENAME = 'D:\Lab_2\”гольный_разрез.mdf',
	SIZE = 50MB,
	MAXSIZE = 100MB,
	FILEGROWTH = 10MB
)

LOG ON
(
	NAME = '”гольный_разрез_log',
	FILENAME = 'D:\Lab_2\”гольный_разрез.ldf',
	SIZE = 25MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 5MB
)
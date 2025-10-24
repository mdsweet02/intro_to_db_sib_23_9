-- Удаляем базу данных, если она существует
USE master;
GO
DROP DATABASE IF EXISTS UchetObrascheniy;
GO

-- Создаем новую пустую базу данных
CREATE DATABASE UchetObrascheniy;
GO

-- Подключаемся к ней
USE UchetObrascheniy;
GO
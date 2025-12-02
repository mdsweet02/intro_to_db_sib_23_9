-- Таблица Документы
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Документы' AND xtype='U')
BEGIN
    CREATE TABLE [Документы](
        [Код] INT PRIMARY KEY,
        [Наименование] NVARCHAR(100)
    );
END
GO

-- Таблица Подразделения
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Подразделения' AND xtype='U')
BEGIN
    CREATE TABLE [Подразделения](
        [Код] INT PRIMARY KEY,
        [Наименование] NVARCHAR(100)
    );
END
GO

-- Таблица Сотрудники
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Сотрудники' AND xtype='U')
BEGIN
    CREATE TABLE [Сотрудники](
        [Код] INT PRIMARY KEY,
        [ФИО] NVARCHAR(100),
        [Код_подразделения] INT
    );
END
GO

-- Таблица Статус_документа
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Статус_документа' AND xtype='U')
BEGIN
    CREATE TABLE [Статус_документа](
        [Код] INT PRIMARY KEY,
        [Наименование] NVARCHAR(50)
    );
END
GO

-- Таблица Анкета_заявителя
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Анкета_заявителя' AND xtype='U')
BEGIN
    CREATE TABLE [Анкета_заявителя](
        [Код_заявителя] INT PRIMARY KEY,
        [ФИО] NVARCHAR(100),
        [Адрес] NVARCHAR(200),
        [Телефон] NVARCHAR(20),
        [Пол] NVARCHAR(1),
        [Год_рождения] INT
    );
END
GO

-- Таблица Регистрация
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Регистрация' AND xtype='U')
BEGIN
    CREATE TABLE [Регистрация](
        [Номер_документа] INT PRIMARY KEY,
        [Дата_регистрации] DATE,
        [Код_документа] INT,
        [Код_заявителя] INT,
        [Дата_исполнения_по_закону] DATE,
        [Статус] INT
    );
END
GO

-- Таблица Движение
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Движение' AND xtype='U')
BEGIN
    CREATE TABLE [Движение](
        [Код_документа] INT,
        [Код_сотрудника_исполнителя] INT,
        [Дата_получения_документа] DATE,
        [Дата_окончания_исполнения] DATE
    );
END
GO

-- Таблица Резолюция
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Резолюция' AND xtype='U')
BEGIN
    CREATE TABLE [Резолюция](
        [Номер_документа] INT,
        [Дата] DATE,
        [Код_исполнителя] INT,
        [Описание_работы_по_документу] NVARCHAR(500)
    );
END
GO
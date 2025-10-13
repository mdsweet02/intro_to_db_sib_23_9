CREATE DATABASE Страхование
ON PRIMARY (
    NAME = 'Страхование',
    FILENAME = 'D:\SQL\Страхование.mdf',
    SIZE = 10MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 5MB
)
LOG ON (
    NAME = 'Страхование_log',
    FILENAME = 'D:\SQL\Страхование_log.ldf',
    SIZE = 5MB,
    MAXSIZE = 25MB,
    FILEGROWTH = 5MB
);
GO
USE Страхование;
GO

CREATE TYPE Код_тип FROM INT NOT NULL;
GO

GO
USE Страхование;
GO
CREATE TABLE Страховщики (
    Код_страховщика Код_тип PRIMARY KEY,
    ФИО VARCHAR(100) NOT NULL,
    Процент_вознаграждения DECIMAL(5,2)
        CHECK (Процент_вознаграждения BETWEEN 0 AND 100)
);
GO
USE Страхование;
GO
CREATE TABLE Виды_страхования (
    Код_вида Код_тип PRIMARY KEY,
    Наименование VARCHAR(100) NOT NULL UNIQUE,
    Сумма DECIMAL(15,2) CHECK (Сумма > 0)
);
GO
USE Страхование;
GO
CREATE TABLE Объекты_страхования (
    Код_объекта Код_тип PRIMARY KEY,
    Наименование VARCHAR(100) NOT NULL
);
GO
USE Страхование;
GO
CREATE TABLE Районы (
    Код_района Код_тип PRIMARY KEY,
    Наименование VARCHAR(100) NOT NULL UNIQUE
);
GO
USE Страхование;
GO
CREATE TABLE Банки (
    Код_банка Код_тип PRIMARY KEY,
    Наименование VARCHAR(100) NOT NULL UNIQUE,
    Адрес VARCHAR(200) NOT NULL
);
GO
USE Страхование;
GO
CREATE TABLE Клиенты (
    ИИН_БИН CHAR(12) PRIMARY KEY,
    ФИО_Наименование VARCHAR(150) NOT NULL,
    Признак_клиента VARCHAR(20)
        CHECK (Признак_клиента IN ('физическое лицо', 'юридическое лицо')),
    Код_района Код_тип NOT NULL,
    Адрес VARCHAR(200),
    Телефон VARCHAR(20),
    Лицевой_счет VARCHAR(20) UNIQUE,
    Код_банка Код_тип,
    FOREIGN KEY (Код_района) REFERENCES Районы(Код_района),
    FOREIGN KEY (Код_банка) REFERENCES Банки(Код_банка)
);
GO
USE Страхование;
GO
CREATE TABLE Договора (
    Номер_договора Код_тип PRIMARY KEY,
    Дата_заключения DATE NOT NULL,
    ИИН_БИН CHAR(12) NOT NULL,
    Срок_действия DATE NOT NULL,
    Код_вида Код_тип NOT NULL,
    Код_страховщика Код_тип NOT NULL,
    Код_объекта Код_тип NOT NULL,
    Количество_объектов INT CHECK (Количество_объектов > 0),
    Характеристика VARCHAR(300),
    Сумма_страховки DECIMAL(15,2) CHECK (Сумма_страховки > 0),
    Месячный_взнос DECIMAL(15,2) CHECK (Месячный_взнос >= 0),
    Накопленная_сумма DECIMAL(15,2) DEFAULT 0,
    FOREIGN KEY (ИИН_БИН) REFERENCES Клиенты(ИИН_БИН),
    FOREIGN KEY (Код_вида) REFERENCES Виды_страхования(Код_вида),
    FOREIGN KEY (Код_страховщика) REFERENCES Страховщики(Код_страховщика),
    FOREIGN KEY (Код_объекта) REFERENCES Объекты_страхования(Код_объекта)
);
GO
USE Страхование;
GO
CREATE TABLE Перечисления (
    Код INT IDENTITY PRIMARY KEY,
    Номер_договора Код_тип NOT NULL,
    ИИН_БИН CHAR(12) NOT NULL,
    Дата_оплаты DATE NOT NULL,
    Месяц INT CHECK (Месяц BETWEEN 1 AND 12),
    Год INT CHECK (Год >= 2000),
    Сумма DECIMAL(15,2) CHECK (Сумма > 0),
    Код_банка Код_тип NOT NULL,
    FOREIGN KEY (Номер_договора) REFERENCES Договора(Номер_договора),
    FOREIGN KEY (ИИН_БИН) REFERENCES Клиенты(ИИН_БИН),
    FOREIGN KEY (Код_банка) REFERENCES Банки(Код_банка)
);

USE Страхование;
GO
SELECT  
    fk.name AS ForeignKeyName,  
    tp.name AS ParentTable,  
    tr.name AS ReferenceTable,  
    cp.name AS ParentColumn,  
    cr.name AS ReferenceColumn  
FROM sys.foreign_keys AS fk  
INNER JOIN sys.foreign_key_columns AS fkc  
    ON fk.object_id = fkc.constraint_object_id  
INNER JOIN sys.tables AS tp  
    ON fkc.parent_object_id = tp.object_id  
INNER JOIN sys.columns AS cp  
    ON fkc.parent_object_id = cp.object_id  
   AND fkc.parent_column_id = cp.column_id  
INNER JOIN sys.tables AS tr  
    ON fkc.referenced_object_id = tr.object_id  
INNER JOIN sys.columns AS cr  
    ON fkc.referenced_object_id = cr.object_id  
   AND fkc.referenced_column_id = cr.column_id  
ORDER BY tp.name, fk.name;
USE Страхование;
GO
SELECT  
    t.name AS TableName,
    ind.name AS IndexName,
    ind.is_unique AS is_unique
FROM  
    sys.indexes ind  
INNER JOIN  
    sys.tables t ON ind.object_id = t.object_id  
WHERE  
    t.is_ms_shipped = 0  -- Исключаем системные таблицы
ORDER BY  
    t.name, ind.name;


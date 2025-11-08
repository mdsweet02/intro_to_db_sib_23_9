CREATE TYPE ClientIDType FROM CHAR(12) NOT NULL;
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

USE Страхование;
GO
CREATE TABLE Страховщики (
    Код_страховщика Код_тип PRIMARY KEY,
    ФИО VARCHAR(100) NOT NULL,
    Процент_вознаграждения DECIMAL(5,2)
        CHECK (Процент_вознаграждения BETWEEN 0 AND 100)
);
USE Страхование;
GO
CREATE TABLE Виды_страхования (
    Код_вида Код_тип PRIMARY KEY,
    Наименование VARCHAR(100) NOT NULL UNIQUE,
    Сумма DECIMAL(15,2) CHECK (Сумма > 0)
);
USE Страхование;
GO
CREATE TABLE Объекты_страхования (
    Код_объекта Код_тип PRIMARY KEY,
    Наименование VARCHAR(100) NOT NULL
);
USE Страхование;
GO
CREATE TABLE Районы (
    Код_района Код_тип PRIMARY KEY,
    Наименование VARCHAR(100) NOT NULL UNIQUE
);
USE Страхование;
GO
CREATE TABLE Банки (
    Код_банка Код_тип PRIMARY KEY,
    Наименование VARCHAR(100) NOT NULL UNIQUE,
    Адрес VARCHAR(200) NOT NULL
);
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
INSERT INTO Районы VALUES
(1, 'Байконур'), (2, 'Есильский'), (3, 'Сарыаркинский'),
(4, 'Алатауский'), (5, 'Жетысуский');
USE Страхование;
GO
INSERT INTO Банки VALUES
(1, 'Kaspi Bank', 'г. Астана, пр. Абая, 12'),
(2, 'Halyk Bank', 'г. Алматы, ул. Достык, 55'),
(3, 'Forte Bank', 'г. Астана, ул. Сейфуллина, 24');
USE Страхование;
GO
INSERT INTO Страховщики VALUES
(1, 'Иванов Иван Иванович', 10.5),
(2, 'Петров Петр Сергеевич', 8.0),
(3, 'Ахметов Нурлан Бекенович', 12.3),
(4, 'Сидорова Анна Николаевна', 9.7),
(5, 'Мухамеджанов Ерлан Ерболович', 11.2);
USE Страхование;
GO
INSERT INTO Виды_страхования VALUES
(1, 'Автострахование', 500000),
(2, 'Страхование имущества', 1000000),
(3, 'Страхование здоровья', 750000),
(4, 'Страхование жизни', 1200000),
(5, 'Путешествия', 300000);
USE Страхование;
GO
INSERT INTO Объекты_страхования VALUES
(1, 'Автомобиль'),
(2, 'Квартира'),
(3, 'Дом'),
(4, 'Жизнь человека'),
(5, 'Поездка за границу');
USE Страхование;
GO
INSERT INTO Клиенты VALUES
('990101123456', 'Касымов Али', 'физическое лицо', 1, 'г. Астана', '87071234567', 'LS001', 1),
('980202654321', 'TOO "Алем-Строй"', 'юридическое лицо', 2, 'г. Алматы', '87271234568', 'LS002', 2),
('990303987654', 'Иванова Алина', 'физическое лицо', 3, 'г. Караганда', '87081234569', 'LS003', 1),
('970404321789', 'TOO "TechPro"', 'юридическое лицо', 1, 'г. Астана', '87091234570', 'LS004', 3),
('990505112233', 'Серикова Гульмира', 'физическое лицо', 2, 'г. Алматы', '87051234571', 'LS005', 2);
USE Страхование;
GO
INSERT INTO Договора VALUES
(1, '2024-01-10', '990101123456', '2025-01-10', 1, 1, 1, 1, 'Kia Sportage', 500000, 25000, 25000),
(2, '2024-03-15', '980202654321', '2025-03-15', 2, 2, 2, 1, 'Офисное здание', 1000000, 50000, 50000),
(3, '2024-05-20', '990303987654', '2025-05-20', 3, 3, 4, 1, 'Медстраховка', 750000, 30000, 30000),
(4, '2024-07-05', '970404321789', '2025-07-05', 5, 4, 5, 1, 'Командировка', 300000, 15000, 15000),
(5, '2024-09-01', '990505112233', '2025-09-01', 4, 5, 4, 1, 'Страхование жизни', 1200000, 60000, 60000);
USE Страхование;
GO
INSERT INTO Перечисления (Номер_договора, ИИН_БИН, Дата_оплаты, Месяц, Год, Сумма, Код_банка) VALUES
(1, '990101123456', '2024-02-10', 2, 2024, 25000, 1),
(1, '990101123456', '2024-03-10', 3, 2024, 25000, 1),
(2, '980202654321', '2024-04-15', 4, 2024, 50000, 2),
(3, '990303987654', '2024-06-20', 6, 2024, 30000, 1),
(4, '970404321789', '2024-08-05', 8, 2024, 15000, 3),
(5, '990505112233', '2024-10-01', 10, 2024, 60000, 2);
USE Страхование;
GO
SELECT * FROM Страховщики;
SELECT * FROM Виды_страхования;
SELECT * FROM Объекты_страхования;
SELECT * FROM Районы;
SELECT * FROM Банки;
SELECT * FROM Клиенты;
SELECT * FROM Договора;
SELECT * FROM Перечисления;
USE Страхование;
GO
SELECT 'Районы' AS tbl, COUNT(*) AS cnt FROM Районы
UNION ALL
SELECT 'Банки', COUNT(*) FROM Банки
UNION ALL
SELECT 'Страховщики', COUNT(*) FROM Страховщики
UNION ALL
SELECT 'Виды_страхования', COUNT(*) FROM Виды_страхования
UNION ALL
SELECT 'Объекты_страхования', COUNT(*) FROM Объекты_страхования
UNION ALL
SELECT 'Клиенты', COUNT(*) FROM Клиенты
UNION ALL
SELECT 'Договора', COUNT(*) FROM Договора
UNION ALL
SELECT 'Перечисления', COUNT(*) FROM Перечисления;

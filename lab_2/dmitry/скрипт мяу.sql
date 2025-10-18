CREATE DATABASE Chymical_lab

CREATE TABLE Химические_элементы (
    Код_элемента INT PRIMARY KEY,
    Название VARCHAR(100) NOT NULL,
    Признак VARCHAR(100) NOT NULL,
        CHECK (Признак IN ('Основа','Примесь'))
		);
CREATE TABLE Марки_плавок (
    Код_марки_литья INT PRIMARY KEY,
    Название VARCHAR(100) NOT NULL
);
CREATE TABLE Сотрудники (
    Код_сотрудника INT PRIMARY KEY,
    ФИО VARCHAR(100) NOT NULL,
    Код_подразделения INT NOT NULL
);
CREATE TABLE Подразделения (
    Код_подразделения INT PRIMARY KEY,
    Название VARCHAR(100) NOT NULL,
    Код_сотрудника_начальника INT,
    FOREIGN KEY (Код_сотрудника_начальника) REFERENCES Сотрудники(Код_сотрудника)
);
CREATE TABLE Печи (
    Код_печи INT PRIMARY KEY,
    Название VARCHAR(100) NOT NULL,
    Код_подразделения INT,
    FOREIGN KEY (Код_подразделения) REFERENCES Подразделения(Код_подразделения)
);
CREATE TABLE Компоненты_марки (
    Код_марки_литья INT,
    Код_элемента INT,
    Нижний_предел_количество_элемента INT,
    Верхний_предел_количество_элемента INT,
    PRIMARY KEY (Код_марки_литья, Код_элемента),
    FOREIGN KEY (Код_марки_литья) REFERENCES Марки_плавок(Код_марки_литья),
    FOREIGN KEY (Код_элемента) REFERENCES Химические_элементы(Код_элемента),
    CHECK (Нижний_предел_количество_элемента >= 0),
    CHECK (Верхний_предел_количество_элемента >= Нижний_предел_количество_элемента)
);
CREATE TABLE Плавка (
    Номер_плавки INT PRIMARY KEY,
    Код_марки_литья INT,
    Код_сотрудника INT,
    Код_подразделения INT,
    Код_печи INT,
    Дата DATE,
    Примечание VARCHAR(100),
    Кол_во_в_тоннах DECIMAL(10, 2),
    FOREIGN KEY (Код_марки_литья) REFERENCES Марки_плавок(Код_марки_литья),
    FOREIGN KEY (Код_сотрудника) REFERENCES Сотрудники(Код_сотрудника),
    FOREIGN KEY (Код_подразделения) REFERENCES Подразделения(Код_подразделения),
    FOREIGN KEY (Код_печи) REFERENCES Печи(Код_печи)
);
CREATE TABLE Плавка_компоненты (
    Номер_плавки INT,
    Код_элемента INT,
    Количество DECIMAL(10, 2),
    PRIMARY KEY (Номер_плавки, Код_элемента),
    FOREIGN KEY (Номер_плавки) REFERENCES Плавка(Номер_плавки),
    FOREIGN KEY (Код_элемента) REFERENCES Химические_элементы(Код_элемента)
);
CREATE TABLE Плавка_примеси (
    Номер_плавки INT,
    Код_элемента INT,
    Количество DECIMAL(10, 2),
    PRIMARY KEY (Номер_плавки, Код_элемента),
    FOREIGN KEY (Номер_плавки) REFERENCES Плавка(Номер_плавки),
    FOREIGN KEY (Код_элемента) REFERENCES Химические_элементы(Код_элемента),
    CHECK (Количество >= 0)
);
USE Chymical_lab;
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
INSERT INTO Сотрудники (Код_сотрудника, ФИО, Код_подразделения) VALUES
(1, 'Иванов Иван Иванович', 1),
(2, 'Петров Петр Петрович', 2);
INSERT INTO Подразделения (Код_подразделения, Название, Код_сотрудника_начальника) VALUES
(1, 'Отдел химического анализа', 1),
(2, 'Отдел металлургического анализа', 2);
INSERT INTO Марки_плавок (Код_марки_литья, Название) VALUES
(1, 'Марка A'),
(2, 'Марка B');
INSERT INTO Химические_элементы (Код_элемента, Название, Признак) VALUES
(1, 'Углерод', 'Основа'),
(2, 'Марганец', 'Основа');
INSERT INTO Печи (Код_печи, Название, Код_подразделения) VALUES
(1, 'Печь №1', 1),
(2, 'Печь №2', 2);
INSERT INTO Компоненты_марки (Код_марки_литья, Код_элемента, Нижний_предел_количество_элемента, Верхний_предел_количество_элемента) VALUES
(1, 1, 5, 10),
(2, 2, 2, 4);
INSERT INTO Плавка (Номер_плавки, Код_марки_литья, Код_сотрудника, Код_подразделения, Код_печи, Дата, Примечание, Кол_во_в_тоннах) VALUES
(1, 1, 1, 1, 1, '2025-10-01', 'Примечание 1', 20.5),
(2, 2, 2, 2, 2, '2025-10-02', 'Примечание 2', 15.3);
INSERT INTO Плавка_компоненты (Номер_плавки, Код_элемента, Количество) VALUES
(1, 1, 5.0),
(2, 2, 3.0);
INSERT INTO Плавка_примеси (Номер_плавки, Код_элемента, Количество) VALUES
(1, 2, 0.5),
(2, 1, 0.3);
SELECT COUNT(*) AS Количество_сотрудников FROM Сотрудники;
SELECT COUNT(*) AS Количество_подразделений FROM Подразделения;
SELECT COUNT(*) AS Количество_марок_плавок FROM Марки_плавок;
SELECT COUNT(*) AS Количество_химических_элементов FROM Химические_элементы;
SELECT COUNT(*) AS Количество_печей FROM Печи;
SELECT COUNT(*) AS Количество_компонентов_марок FROM Компоненты_марки;
SELECT COUNT(*) AS Количество_плавок FROM Плавка;
SELECT COUNT(*) AS Количество_компонентов_плавок FROM Плавка_компоненты;
SELECT COUNT(*) AS Количество_примесей_плавок FROM Плавка_примеси;
SELECT 'Сотрудники' AS tbl, COUNT(*) AS cnt FROM Сотрудники
UNION ALL
SELECT 'Подразделения', COUNT(*) FROM Подразделения
UNION ALL
SELECT 'Марки_плавок', COUNT(*) FROM Марки_плавок
UNION ALL
SELECT 'Химические_элементы', COUNT(*) FROM Химические_элементы
UNION ALL
SELECT 'Печи', COUNT(*) FROM Печи
UNION ALL
SELECT 'Компоненты_марки', COUNT(*) FROM Компоненты_марки
UNION ALL
SELECT 'Плавка', COUNT(*) FROM Плавка
UNION ALL
SELECT 'Плавка_компоненты', COUNT(*) FROM Плавка_компоненты
UNION ALL
SELECT 'Плавка_примеси', COUNT(*) FROM Плавка_примеси;

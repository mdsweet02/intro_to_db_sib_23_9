--Создание таблиц

USE SRSP2;
GO

CREATE TABLE VidiSporta
(SportID INT PRIMARY KEY,
Nazvanie VARCHAR(100) NOT NULL);

CREATE TABLE PriznakSporta
(PriznakID INT PRIMARY KEY,
Opisanie VARCHAR(100) NOT NULL,
SportID INT,
FOREIGN KEY (SportID) REFERENCES VidiSporta(SportID)
ON UPDATE CASCADE
ON DELETE SET NULL);

CREATE TABLE Trenery
(TrenerID INT PRIMARY KEY,
FIO VARCHAR(100) NOT NULL,
SportID INT, 
FOREIGN KEY (SportID) REFERENCES VidiSporta(SportID)
ON UPDATE CASCADE
ON DELETE SET NULL);

CREATE TABLE TipSorev
(TipID INT PRIMARY KEY,
Tip_name VARCHAR(100) NOT NULL);

CREATE TABLE Sorevnovaniya
(SorevnID INT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
TipID INT NOT NULL,
FOREIGN KEY (TipID) REFERENCES TipSorev(TipID)
ON UPDATE CASCADE
ON DELETE NO ACTION);

CREATE TABLE Nagrady
(NagradaID INT PRIMARY KEY,
Nazvanie VARCHAR(100) NOT NULL);

CREATE TABLE Sportsmeny
(SportsmenID INT PRIMARY KEY,
FIO_Nazvanie VARCHAR(100) NOT NULL,
SportID INT NOT NULL,
TrenerID INT NOT NULL,
Priznak VARCHAR(20) NOT NULL CHECK (Priznak IN ('Физ.лицо', 'Команда')),
FOREIGN KEY (SportID) REFERENCES VidiSporta(SportID)
ON UPDATE CASCADE
ON DELETE NO ACTION,
FOREIGN KEY (TrenerID) REFERENCES Trenery(TrenerID));

CREATE TABLE Sportsmeny_Fiz
(SportsmenID INT PRIMARY KEY,
Pol CHAR(1) NOT NULL CHECK (Pol IN ('М', 'Ж')),
GodRozh SMALLINT NOT NULL CHECK(GodRozh>1900),
Nacionalnost VARCHAR(50) NOT NULL,
FOREIGN KEY (SportsmenID) REFERENCES Sportsmeny(SportsmenID)
ON UPDATE CASCADE
ON DELETE CASCADE);

CREATE TABLE Sportsmeny_Komandy
(SportsmenID INT PRIMARY KEY,
FIO VARCHAR(100) NOT NULL,
Pol CHAR(1) NOT NULL CHECK (Pol IN ('М', 'Ж')),
GodRozh SMALLINT NOT NULL CHECK(GodRozh>1900),
Nacionalnost VARCHAR(50) NOT NULL,
FOREIGN KEY (SportsmenID) REFERENCES Sportsmeny(SportsmenID)
ON UPDATE CASCADE
ON DELETE CASCADE);

CREATE TABLE Grafik
(SorevnID INT PRIMARY KEY,
SportID INT NOT NULL,
DataStart DATE NOT NULL,
DataEnd DATE NOT NULL,
FOREIGN KEY (SorevnID) REFERENCES Sorevnovaniya(SorevnID)
ON UPDATE CASCADE
ON DELETE CASCADE,
FOREIGN KEY (SportID) REFERENCES VidiSporta(SportID)
ON UPDATE CASCADE
ON DELETE NO ACTION);

CREATE TABLE Results
(ItogID INT PRIMARY KEY,
SorevnID INT NOT NULL,
SportID INT NOT NULL,
DataItoga DATE NOT NULL,
NagradaID INT NOT NULL,
SportsmenID INT NOT NULL,
FOREIGN KEY (SorevnID) REFERENCES Sorevnovaniya(SorevnID)
ON UPDATE CASCADE
ON DELETE CASCADE,
FOREIGN KEY (SportID) REFERENCES VidiSporta(SportID)
ON UPDATE CASCADE
ON DELETE NO ACTION,
FOREIGN KEY (NagradaID) REFERENCES Nagrady(NagradaID),
FOREIGN KEY (SportsmenID) REFERENCES Sportsmeny(SportsmenID));

--Создание/удаление индексов

CREATE INDEX IX_Sportsmeny_FIO
ON Sportsmeny(FIO_Nazvanie);

CREATE INDEX IX_Nagrady_Nazvanie
ON Nagrady(Nazvanie);

CREATE INDEX IX_Results_Sorevn_Nagrada
ON Results(SorevnID, NagradaID);


--Просмотр всех индексов

SELECT 
    t.name AS TableName,
    ind.name AS IndexName,
    col.name AS ColumnName,
    ind.type_desc AS IndexType
FROM sys.indexes ind
INNER JOIN sys.index_columns ic 
    ON ind.object_id = ic.object_id AND ind.index_id = ic.index_id
INNER JOIN sys.columns col 
    ON ic.object_id = col.object_id AND ic.column_id = col.column_id
INNER JOIN sys.tables t 
    ON ind.object_id = t.object_id
WHERE ind.is_primary_key = 0 
AND ind.is_unique_constraint = 0
ORDER BY t.name, ind.name;

-- 1. Виды спорта
INSERT INTO VidiSporta (SportID, Nazvanie)
VALUES (1, 'Футбол'),
       (2, 'Баскетбол'),
       (3, 'Плавание'),
       (4, 'Теннис'),
       (5, 'Волейбол'),
       (6, 'Легкая атлетика'),
       (7, 'Бокс'),
       (8, 'Гимнастика'),
       (9, 'Хоккей'),
       (10, 'Фехтование');

-- 2. Признаки видов спорта
INSERT INTO PriznakSporta (PriznakID, Opisanie, SportID)
VALUES (1, 'Командный вид', 1),
       (2, 'Индивидуальный вид', 3),
       (3, 'Индивидуальный вид', 4),
       (4, 'Командный вид', 5),
       (5, 'Индивидуальный вид', 6),
       (6, 'Индивидуальный вид', 7),
       (7, 'Индивидуальный вид', 8),
       (8, 'Командный вид', 9),
       (9, 'Индивидуальный вид', 10),
       (10, 'Командный вид', 1),
       (11, 'Индивидуальный вид', 2),
       (12, 'Индивидуальный вид', 3);

-- 3. Тренеры
INSERT INTO Trenery (TrenerID, FIO, SportID)
VALUES (1, 'Иванов Петр Сергеевич', 1),
       (2, 'Сидоров Алексей Николаевич', 2),
       (3, 'Петров Николай Сергеевич', 3),
       (4, 'Смирнова Анна Ивановна', 4),
       (5, 'Кузнецов Дмитрий Олегович', 5),
       (6, 'Михайлова Ольга Сергеевна', 6),
       (7, 'Соколов Илья Павлович', 7),
       (8, 'Алексеева Мария Викторовна', 8),
       (9, 'Фролов Константин Андреевич', 9),
       (10, 'Васильев Артем Юрьевич', 10);

-- 4. Тип соревнований
INSERT INTO TipSorev (TipID, Tip_name)
VALUES (1, 'Региональные'),
       (2, 'Международные'),
       (3, 'Национальные'),
       (4, 'Континентальные'),
       (5, 'Чемпионат мира'),
       (6, 'Олимпийские игры'),
       (7, 'Региональные'),
       (8, 'Кубок мира'),
       (9, 'Локальные соревнования'),
       (10, 'Турнир по приглашению');

-- 5. Соревнования
INSERT INTO Sorevnovaniya (SorevnID, name, TipID)
VALUES (1, 'Кубок Казахстана', 1),
       (2, 'Олимпийские игры', 2),
       (3, 'Чемпионат РК', 3),
       (4, 'Кубок Азии', 4),
       (5, 'Чемпионат мира по футболу', 5),
       (6, 'Олимпиада 2028', 6),
       (7, 'Региональный турнир', 7),
       (8, 'Кубок мира по баскетболу', 8),
       (9, 'Турнир Москва', 9),
       (10, 'Международный турнир', 10);

-- 6. Награды
INSERT INTO Nagrady (NagradaID, Nazvanie)
VALUES (1, 'Золотая медаль'),
       (2, 'Серебряная медаль'),
       (3, 'Бронзовая медаль'),
       (4, 'Чемпионский кубок'),
       (5, 'Бронзовый кубок'),
       (6, 'Серебряная медаль'),
       (7, 'Почетная грамота'),
       (8, 'Диплом участника'),
       (9, 'Кубок за лучший результат'),
       (10, 'Приз зрительских симпатий');

-- 7. Спортсмены
INSERT INTO Sportsmeny (SportsmenID, FIO_Nazvanie, SportID, TrenerID, Priznak)
VALUES (1, 'Кайратов Дамир', 1, 1, 'Физ.лицо'),
       (2, 'Команда "Орлы"', 2, 2, 'Команда'),
       (3, 'Александров Иван', 3, 3, 'Физ.лицо'),
       (4, 'Команда "Волейболисты"', 5, 5, 'Команда'),
       (5, 'Смирнова Елена', 6, 6, 'Физ.лицо'),
       (6, 'Команда "Боксеры"', 7, 7, 'Команда'),
       (7, 'Иванова Мария', 8, 8, 'Физ.лицо'),
       (8, 'Команда "Хоккеисты"', 9, 9, 'Команда'),
       (9, 'Фролов Алексей', 10, 10, 'Физ.лицо'),
       (10, 'Команда "Фехтовальщики"', 10, 10, 'Команда'),
       (11, 'Козлов Петр', 1, 1, 'Физ.лицо'),
       (12, 'Команда "Баскетболисты"', 2, 2, 'Команда'),
       (13, 'Николаев Сергей', 3, 3, 'Физ.лицо'),
       (14, 'Команда "Пловцы"', 3, 3, 'Команда'),
       (15, 'Петрова Анна', 4, 4, 'Физ.лицо'),
       (16, 'Команда "Теннисисты"', 4, 4, 'Команда'),
       (17, 'Васильев Игорь', 5, 5, 'Физ.лицо'),
       (18, 'Команда "Гимнасты"', 8, 8, 'Команда'),
       (19, 'Сидоров Алексей', 7, 7, 'Физ.лицо'),
       (20, 'Команда "Легкая атлетика"', 6, 6, 'Команда');

-- 8. Спортсмены-физлица
INSERT INTO Sportsmeny_Fiz (SportsmenID, Pol, GodRozh, Nacionalnost)
VALUES (1, 'М', 2000, 'Казах'),
       (3, 'М', 1995, 'Казах'),
       (5, 'Ж', 1998, 'Россия'),
       (7, 'Ж', 2001, 'Казах'),
       (9, 'М', 1997, 'Россия'),
       (11, 'М', 2000, 'Казах'),
       (13, 'М', 1996, 'Украина'),
       (15, 'Ж', 1999, 'Беларусь'),
       (17, 'М', 2002, 'Казах'),
       (19, 'М', 2001, 'Россия');

-- 9. Спортсмены-команды
INSERT INTO Sportsmeny_Komandy (SportsmenID, FIO, Pol, GodRozh, Nacionalnost)
VALUES (2, 'Иванов Сергей', 'М', 1998, 'Россия'),
       (4, 'Команда "Волейболисты"', 'М', 2000, 'Казах'),
       (6, 'Команда "Боксеры"', 'М', 1999, 'Россия'),
       (8, 'Команда "Хоккеисты"', 'М', 2001, 'Россия'),
       (10, 'Команда "Фехтовальщики"', 'М', 2000, 'Казах'),
       (12, 'Команда "Баскетболисты"', 'М', 1998, 'Россия'),
       (14, 'Команда "Пловцы"', 'Ж', 2002, 'Казах'),
       (16, 'Команда "Теннисисты"', 'М', 2001, 'Россия'),
       (18, 'Команда "Гимнасты"', 'Ж', 1999, 'Казах'),
       (20, 'Команда "Легкая атлетика"', 'М', 2000, 'Россия');

-- 10. График
INSERT INTO Grafik (SorevnID, SportID, DataStart, DataEnd)
VALUES (1, 1, '2025-05-01', '2025-05-07'),
       (2, 2, '2025-06-10', '2025-06-15'),
       (3, 3, '2025-07-01', '2025-07-05'),
       (4, 4, '2025-07-10', '2025-07-15'),
       (5, 1, '2025-08-01', '2025-08-10'),
       (6, 2, '2025-08-15', '2025-08-20'),
       (7, 5, '2025-09-01', '2025-09-07'),
       (8, 8, '2025-09-10', '2025-09-15'),
       (9, 9, '2025-10-01', '2025-10-05'),
       (10, 10, '2025-10-10', '2025-10-15');

-- 11. Результаты
INSERT INTO Results (ItogID, SorevnID, SportID, DataItoga, NagradaID, SportsmenID)
VALUES (1, 1, 1, '2025-05-07', 1, 1),
       (2, 2, 2, '2025-06-15', 2, 2),
       (3, 3, 3, '2025-07-05', 4, 3),
       (4, 4, 4, '2025-07-15', 5, 4),
       (5, 5, 1, '2025-08-10', 1, 11),
       (6, 6, 2, '2025-08-20', 2, 12),
       (7, 7, 5, '2025-09-07', 3, 6),
       (8, 8, 8, '2025-09-15', 4, 18),
       (9, 9, 9, '2025-10-05', 5, 8),
       (10, 10, 10, '2025-10-15', 6, 10),
       (11, 1, 1, '2025-05-07', 1, 1),
       (12, 2, 2, '2025-06-15', 2, 2),
       (13, 3, 3, '2025-07-05', 6, 13),
       (14, 4, 4, '2025-07-15', 7, 15),
       (15, 5, 1, '2025-08-10', 2, 11),
       (16, 6, 2, '2025-08-20', 3, 12),
       (17, 7, 5, '2025-09-07', 4, 6),
       (18, 8, 8, '2025-09-15', 5, 18),
       (19, 9, 9, '2025-10-05', 6, 8),
       (20, 10, 10, '2025-10-15', 7, 10);

-- ВЫБОРКИ
--1.
SELECT Sportsmeny.FIO_Nazvanie, VidiSporta.Nazvanie
FROM Sportsmeny
JOIN Results ON Sportsmeny.SportsmenID = Results.SportsmenID
JOIN VidiSporta ON Results.SportID = VidiSporta.SportID
WHERE YEAR(DataItoga) = Year(GETDATE())

--2.
SELECT Nagrady.Nazvanie
FROM Nagrady
JOIN Results ON Nagrady.NagradaID = Results.NagradaID
WHERE Results.DataItoga = '2025-05-07';

--3.
SELECT DISTINCT Nagrady.Nazvanie
FROM Nagrady
JOIN Results ON Nagrady.NagradaID = Results.NagradaID
JOIN Sportsmeny ON Results.SportsmenID = Sportsmeny.SportsmenID
WHERE Sportsmeny.TrenerID = 1;
;

--4. 
SELECT VidiSporta.Nazvanie, COUNT(Results.NagradaID) AS Kolichestvo
FROM Results
JOIN VidiSporta ON Results.SportID = VidiSporta.SportID
GROUP BY VidiSporta.Nazvanie;

--5. 
SELECT FIO_Nazvanie
FROM Sportsmeny
WHERE FIO_Nazvanie LIKE 'А%';

-- ХРАНИМЫЕ ПРОЦЕДУРЫ
--1.
CREATE PROCEDURE Rewards
@SorevnID INT,
@SportID INT
AS
BEGIN
SELECT *
FROM Results
WHERE SorevnID = @SorevnID
AND SportID = @SportID;
END;
GO

EXEC Rewards 1, 2;

--2.

CREATE PROCEDURE Women18to20
AS
BEGIN
SELECT *
FROM Sportsmeny_Fiz
WHERE Pol = 'Ж'
AND(YEAR(GETDATE()) - GodRozh) BETWEEN 18 AND 20;
END;
GO

EXEC Women18to20;

--3.

CREATE PROCEDURE AddThreeCoaches
AS
BEGIN
DECLARE @Coach INT=1;
WHILE @Coach <=3
BEGIN
INSERT INTO Trenery (TrenerID, FIO, SportID)
VALUES((SELECT ISNULL(MAX(TrenerID), 0)+1 FROM Trenery), 'Новый тренер', NULL);
SET @Coach = @Coach + 1;
END;
PRINT 'Добавлено 3 Новых тренера.';
END;
GO

EXEC AddThreeCoaches;

--4.
CREATE PROCEDURE CompetDuration
@SorevnID INT
AS
BEGIN
SELECT
SorevnID,
DataStart,
DataEnd,
DATEDIFF(DAY, DataStart, DataEnd) AS Duration
FROM Grafik
WHERE SorevnID = @SorevnID
END;
GO

EXEC CompetDuration 1;

-- Представления
--1.

CREATE VIEW ListOfWinners
AS
SELECT Sportsmeny.FIO_Nazvanie, VidiSporta.Nazvanie, Sorevnovaniya.name AS Соревнование
FROM Results
JOIN Sportsmeny ON Results.SportsmenID = Sportsmeny.SportsmenID
JOIN VidiSporta ON Results.SportID = VidiSporta.SportID
JOIN Sorevnovaniya ON Results.SorevnID = Sorevnovaniya.SorevnID
WHERE Results.NagradaID IN (1, 2, 3);

SELECT * FROM ListOfWinners

--2.

CREATE VIEW TypeOfSportsInCompet
AS
SELECT DISTINCT VidiSporta.Nazvanie, Sorevnovaniya.name AS Соревнование
FROM Results
JOIN VidiSporta ON Results.SportID = VidiSporta.SportID
JOIN Sorevnovaniya ON Results.SorevnID = Sorevnovaniya.SorevnID
WHERE Sorevnovaniya.SorevnID = 1;

SELECT * FROM TypeOfSportsInCompet

--3.

CREATE VIEW CurrentYearsSchedule
AS
SELECT 
Sorevnovaniya.name AS Соревнование,
VidiSporta.Nazvanie,
Grafik.DataStart,
Grafik.DataEnd
FROM Grafik=
JOIN Sorevnovaniya ON Grafik.SorevnID = Sorevnovaniya.SorevnID
JOIN VidiSporta ON Grafik.SportID = VidiSporta.SportID
WHERE YEAR(Grafik.DataStart) = YEAR(GETDATE());

SELECT * FROM CurrentYearsSchedule

------

--1.

CREATE VIEW View_Sportsmen_Info
AS
SELECT 
Sportsmeny.SportsmenID,
Sportsmeny.FIO_Nazvanie AS [ФИО спортсмена],
VidiSporta.Nazvanie AS [Вид спорта],
Trenery.FIO AS [Тренер],
Sportsmeny.Priznak AS [Тип]
FROM Sportsmeny
JOIN VidiSporta ON Sportsmeny.SportID = VidiSporta.SportID
JOIN Trenery ON Sportsmeny.TrenerID = Trenery.TrenerID;

SELECT * FROM View_Sportsmen_Info

--2.

CREATE VIEW View_Sportsmen_Edit AS
SELECT 
    Sportsmeny.SportsmenID,
    Sportsmeny.FIO_Nazvanie,
    Sportsmeny.Priznak
FROM Sportsmeny
WHERE Sportsmeny.Priznak IN ('Физ.лицо', 'Команда');

SELECT * FROM View_Sportsmen_Edit

UPDATE View_Sportsmen_Edit
SET FIO_Nazvanie = 'Иванов Иван Иванович'
WHERE SportsmenID = 1;

--Транзакции

BEGIN TRANSACTION;

BEGIN TRY

INSERT INTO Sportsmeny (SportsmenID, FIO_Nazvanie, TrenerID, SportID, Priznak)
VALUES ((SELECT ISNULL(MAX(SportsmenID), 0) + 1 FROM Sportsmeny),'Кузнецов Илья', 2, 1, 'Физ.лицо');

INSERT INTO Sportsmeny_Fiz (SportsmenID, Pol, GodRozh)
VALUES ((SELECT MAX(SportsmenID) FROM Sportsmeny), 'М', 2004);

INSERT INTO Results (SportsmenID, SorevnID, SportID, NagradaID, DataItoga)
VALUES ((SELECT MAX(SportsmenID) FROM Sportsmeny), 1, 1, 2, GETDATE());

COMMIT TRANSACTION;
PRINT 'Транзакция выполнена успешно.';
END TRY

BEGIN CATCH
ROLLBACK TRANSACTION;
PRINT 'Ошибка! Транзакция отменена.';
PRINT ERROR_MESSAGE();
END CATCH;
GO

--Пользовательские функции

--1.
-- Скалярная функция: проверка возраста
CREATE FUNCTION dbo.IsAdult (@BirthYear INT)
RETURNS NVARCHAR(20)
AS
BEGIN
DECLARE @Age INT = YEAR(GETDATE()) - @BirthYear;
DECLARE @Result NVARCHAR(20);

IF @Age >= 18
SET @Result = 'Совершеннолетний';
ELSE
SET @Result = 'Несовершеннолетний';

RETURN @Result;
END;
GO


SELECT dbo.IsAdult(2006) AS Status;

--2.
CREATE FUNCTION NumbersWithSquares()
RETURNS TABLE
AS
RETURN
(WITH Numbers AS 
(SELECT 1 AS Num
UNION ALL
SELECT Num + 1 FROM Numbers WHERE Num < 25)
SELECT 
Num AS Chislo,
Num * Num AS Kvadrat
FROM Numbers);
GO



-- Проверка работы функции
SELECT * FROM dbo.NumbersWithSquares();



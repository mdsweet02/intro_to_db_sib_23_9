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

-- Представления
--1.

CREATE VIEW ListOfWinners
AS
SELECT Sportsmeny.FIO_Nazvanie, VidiSporta.Nazvanie, Results.SorevnID
FROM Results
JOIN Sportsmeny ON Results.SportsmenID = Sportsmeny.SportsmenID
JOIN VidiSporta ON Results.SportID = VidiSporta.SportID
WHERE Results.NagradaID IN (1, 2, 3);

SELECT * FROM ListOfWinners

--2.

CREATE VIEW TypeOfSportsInCompet
AS
SELECT DISTINCT VidiSporta.Nazvanie, Results.SorevnID
FROM Results
JOIN VidiSporta ON Results.SportID = VidiSporta.SportID;

SELECT * FROM TypeOfSportsInCompet

--3.

CREATE VIEW CurrentYearsSchedule
AS
SELECT SorevnID, SportID, DataStart, DataEnd
FROM Grafik
WHERE YEAR(DataStart) = YEAR(GETDATE());

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
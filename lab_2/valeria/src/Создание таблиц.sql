-- Создаем пользовательский тип данных
CREATE TYPE PhoneType FROM NVARCHAR(20);
GO

-- Таблица Подразделения
CREATE TABLE Podrazdeleniya (
    Kod INT PRIMARY KEY,
    Naimenovanie NVARCHAR(100) NOT NULL
);

-- Таблица Сотрудники
CREATE TABLE Sotrudniki (
    Kod INT PRIMARY KEY,
    FIO NVARCHAR(100) NOT NULL,
    Kod_podrazdeleniya INT NOT NULL,
    FOREIGN KEY (Kod_podrazdeleniya) REFERENCES Podrazdeleniya(Kod)
);

-- Таблица Документы
CREATE TABLE Dokumenty (
    Kod INT PRIMARY KEY,
    Naimenovanie NVARCHAR(150) NOT NULL
);

-- Таблица Статус_документа
CREATE TABLE Status_dokumenta (
    Kod INT PRIMARY KEY,
    Naimenovanie NVARCHAR(50) NOT NULL CHECK (Naimenovanie IN ('зарегистрирован', 'на исполнении', 'исполнен'))
);

-- Таблица Анкета_заявителя
CREATE TABLE Anketa_zayavitelya (
    Kod_zayavitelya INT PRIMARY KEY,
    FIO NVARCHAR(100) NOT NULL,
    Adres NVARCHAR(200),
    Telefon PhoneType,
    Pol CHAR(1) CHECK (Pol IN ('М', 'Ж')),
    God_rojdeniya INT CHECK (God_rojdeniya BETWEEN 1900 AND YEAR(GETDATE()))
);

-- Таблица Регистрация
CREATE TABLE Registraciya (
    Nomer_dokumenta INT PRIMARY KEY,
    Data_registracii DATE NOT NULL,
    Kod_dokumenta INT NOT NULL,
    Kod_zayavitelya INT NOT NULL,
    Data_ispolneniya DATE,
    Status_dokumenta INT NOT NULL,
    FOREIGN KEY (Kod_dokumenta) REFERENCES Dokumenty(Kod),
    FOREIGN KEY (Kod_zayavitelya) REFERENCES Anketa_zayavitelya(Kod_zayavitelya),
    FOREIGN KEY (Status_dokumenta) REFERENCES Status_dokumenta(Kod)
);

-- Таблица Резолюция
CREATE TABLE Rezolyuciya (
    Nomer_dokumenta INT NOT NULL,
    Data DATE NOT NULL,
    Kod_ispolnitelya INT NOT NULL,
    Opisanie NVARCHAR(300),
    FOREIGN KEY (Nomer_dokumenta) REFERENCES Registraciya(Nomer_dokumenta),
    FOREIGN KEY (Kod_ispolnitelya) REFERENCES Sotrudniki(Kod)
);

-- Таблица Движение
CREATE TABLE Dvizhenie (
    Kod_dokumenta INT NOT NULL,
    Kod_sotrudnika_ispolnitelya INT NOT NULL,
    Data_polucheniya DATE,
    Data_okonchaniya DATE,
    FOREIGN KEY (Kod_dokumenta) REFERENCES Registraciya(Nomer_dokumenta),
    FOREIGN KEY (Kod_sotrudnika_ispolnitelya) REFERENCES Sotrudniki(Kod)
);
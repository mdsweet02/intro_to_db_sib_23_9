CREATE TABLE dbo.Должности (
    Код_должности   INT            NOT NULL
        CONSTRAINT PK_Должности PRIMARY KEY,
    наименование    NVARCHAR(255)  NOT NULL
);
GO

CREATE TABLE dbo.Пенсионный_фонд (
    Код_фонда       INT            NOT NULL
        CONSTRAINT PK_Пенсионный_фонд PRIMARY KEY,
    наименование    NVARCHAR(255)  NOT NULL
);
GO

CREATE TABLE dbo.Уголь (
    Марка_угля        NVARCHAR(100) NOT NULL
        CONSTRAINT PK_Уголь PRIMARY KEY,
    зольность         DECIMAL(5,2)  NOT NULL
        CONSTRAINT CK_Уголь_зольность CHECK (зольность BETWEEN 0 AND 100),
    влажность         DECIMAL(5,2)  NOT NULL
        CONSTRAINT CK_Уголь_влажность CHECK (влажность BETWEEN 0 AND 100),
    теплота_сгорания  INT           NOT NULL      -- кДж/кг или ккал/кг — подберите единицы
        CONSTRAINT CK_Уголь_теплота CHECK (теплота_сгорания > 0)
);
GO

CREATE TABLE dbo.Работники (
    таб_номер               INT            NOT NULL
        CONSTRAINT PK_Работники PRIMARY KEY,
    ФИО                     NVARCHAR(255)  NOT NULL,
    ИИН                     CHAR(12)           NULL
        CONSTRAINT CK_Работники_ИИН CHECK (ИИН IS NULL OR ИИН NOT LIKE '%[^0-9]%'),
    СИК                     NVARCHAR(50)       NULL,
    код_должности           INT                NOT NULL
        CONSTRAINT FK_Работники_Должности
        REFERENCES dbo.Должности(Код_должности),
    код_пенсионного_фонда   INT                NOT NULL
        CONSTRAINT FK_Работники_ПФ
        REFERENCES dbo.Пенсионный_фонд(Код_фонда)
);
GO

CREATE TABLE dbo.Самосвалы (
    Номер_самосвала INT            NOT NULL
        CONSTRAINT PK_Самосвалы PRIMARY KEY,
    название        NVARCHAR(255)  NOT NULL,
    тоннаж          DECIMAL(10,2)      NULL
        CONSTRAINT CK_Самосвалы_тоннаж CHECK (тоннаж IS NULL OR тоннаж > 0)
);
GO

CREATE TABLE dbo.Экскаваторы (
    Номер_экскаватора INT            NOT NULL
        CONSTRAINT PK_Экскаваторы PRIMARY KEY,
    название          NVARCHAR(255)  NOT NULL,
    объем_ковша       DECIMAL(10,3)      NULL   -- м³
        CONSTRAINT CK_Экскаваторы_ковш CHECK (объем_ковша IS NULL OR объем_ковша > 0)
);
GO


CREATE TABLE dbo.Добыча_вывоз (
    номер_рейса   BIGINT         NOT NULL IDENTITY(1,1)
        CONSTRAINT PK_Добыча_вывоз PRIMARY KEY,   -- кластерный индекс по умолчанию
    дата          DATE           NOT NULL,
    смена         TINYINT        NOT NULL
        CONSTRAINT CK_Добыча_вывоз_смена CHECK (смена IN (1,2,3)),
    объем         DECIMAL(18,3)  NOT NULL          -- м³ или т
        CONSTRAINT CK_Добыча_вывоз_объем CHECK (объем > 0),
    марка_угля    NVARCHAR(100)  NOT NULL
        CONSTRAINT FK_Добыча_вывоз_Уголь
        REFERENCES dbo.Уголь(Марка_угля)
);
GO

CREATE TABLE dbo.Добыча_экскаватор (
    номер_рейса          BIGINT NOT NULL
        CONSTRAINT FK_Добыча_экскаватор_Рейс
        REFERENCES dbo.Добыча_вывоз(номер_рейса) ON DELETE CASCADE,
    код_экскаватора      INT    NOT NULL
        CONSTRAINT FK_Добыча_экскаватор_Экскаватор
        REFERENCES dbo.Экскаваторы(Номер_экскаватора),
    таб_номер_работника  INT    NOT NULL
        CONSTRAINT FK_Добыча_экскаватор_Работник
        REFERENCES dbo.Работники(таб_номер),
    CONSTRAINT PK_Добыча_экскаватор
        PRIMARY KEY (номер_рейса, код_экскаватора, таб_номер_работника)
);
GO

CREATE TABLE dbo.Вывоз_самосвал (
    номер_рейса          BIGINT NOT NULL
        CONSTRAINT FK_Вывоз_самосвал_Рейс
        REFERENCES dbo.Добыча_вывоз(номер_рейса) ON DELETE CASCADE,
    код_самосвала        INT    NOT NULL
        CONSTRAINT FK_Вывоз_самосвал_Самосвал
        REFERENCES dbo.Самосвалы(Номер_самосвала),
    таб_номер_работника  INT    NOT NULL
        CONSTRAINT FK_Вывоз_самосвал_Работник
        REFERENCES dbo.Работники(таб_номер),
    CONSTRAINT PK_Вывоз_самосвал
        PRIMARY KEY (номер_рейса, код_самосвала, таб_номер_работника)
);
GO

CREATE TABLE dbo.Учет (
    Дата              DATE          NOT NULL,
    смена             TINYINT       NOT NULL
        CONSTRAINT CK_Учет_смена CHECK (смена IN (1,2,3)),
    таб_номер         INT           NOT NULL
        CONSTRAINT FK_Учет_Работник
        REFERENCES dbo.Работники(таб_номер),
    количество_часов  DECIMAL(4,2)  NOT NULL
        CONSTRAINT CK_Учет_часы CHECK (количество_часов >= 0 AND количество_часов <= 24),
    CONSTRAINT PK_Учет PRIMARY KEY (Дата, смена, таб_номер)
);
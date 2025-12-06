CREATE TABLE dbo.Аудит_Студенты
(
    ID               int IDENTITY(1,1) PRIMARY KEY,
    Операция         nvarchar(10) NOT NULL,      -- INSERT/UPDATE/DELETE
    Дата             datetime     NOT NULL DEFAULT GETDATE(),
    Код_студента     int          NOT NULL,
    Старый_ср_балл   float        NULL,
    Новый_ср_балл    float        NULL,
    Примечание       nvarchar(4000) NULL
);
GO

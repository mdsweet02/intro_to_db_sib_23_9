USE ChemLab;
GO

-- Создание таблицы логов, если не существует
IF NOT EXISTS (SELECT * FROM sys.objects 
               WHERE object_id = OBJECT_ID(N'[dbo].[MeltLog]') AND type in (N'U'))
BEGIN
    CREATE TABLE MeltLog (
        LogID INT IDENTITY(1,1) PRIMARY KEY,
        MeltID INT NULL,
        MarkID INT NULL,
        ActionType NVARCHAR(10),
        ActionDate DATETIME DEFAULT GETDATE()
    );
END;
GO
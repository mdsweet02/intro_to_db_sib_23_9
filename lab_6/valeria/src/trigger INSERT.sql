CREATE OR ALTER TRIGGER trg_InsertDocument
ON [Документы]
AFTER INSERT
AS
BEGIN
    INSERT INTO [Документы_Лог] ([Код_документа], [Наименование], [Дата_добавления])
    SELECT [Код], [Наименование], GETDATE()
    FROM INSERTED;
END
GO
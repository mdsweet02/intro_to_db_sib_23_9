CREATE OR ALTER TRIGGER trg_DeleteDocument
ON [Документы]
AFTER DELETE
AS
BEGIN
    INSERT INTO [Документы_Лог] ([Код_документа], [Наименование], [Дата_добавления])
    SELECT d.[Код], d.[Наименование], GETDATE()
    FROM DELETED d;
END
GO
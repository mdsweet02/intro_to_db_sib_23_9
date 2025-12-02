CREATE OR ALTER TRIGGER trg_UpdateDocument
ON [Документы]
AFTER UPDATE
AS
BEGIN
    INSERT INTO [Документы_Лог] ([Код_документа], [Наименование], [Дата_добавления])
    SELECT i.[Код], i.[Наименование], GETDATE()
    FROM INSERTED i;
END
GO
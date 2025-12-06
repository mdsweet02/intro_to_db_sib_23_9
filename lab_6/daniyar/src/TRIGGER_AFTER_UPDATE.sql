CREATE TRIGGER trg_Студенты_UPD
ON dbo.Студенты
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Аудит_Студенты
        (Операция, Код_студента, Старый_ср_балл, Новый_ср_балл, Примечание)
    SELECT
        N'UPDATE',
        i.Код_студента,
        d.средний_балл_успеваемости,
        i.средний_балл_успеваемости,
        N'ФИО: ' + ISNULL(d.ФИО, N'') + N' -> ' + ISNULL(i.ФИО, N'') +
        N'; группа: ' + ISNULL(d.код_группы, N'') + N' -> ' + ISNULL(i.код_группы, N'') +
        N'; спец: ' + ISNULL(d.код_специальности, N'') + N' -> ' + ISNULL(i.код_специальности, N'')
    FROM inserted i
    JOIN deleted  d ON d.Код_студента = i.Код_студента;
END;
GO
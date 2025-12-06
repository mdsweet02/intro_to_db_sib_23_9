USE Дипломное_проектирование
GO
CREATE TRIGGER trg_Студенты_INS
ON dbo.Студенты
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Аудит_Студенты
        (Операция, Код_студента, Новый_ср_балл, Примечание)
    SELECT
        N'INSERT',
        i.Код_студента,
        i.средний_балл_успеваемости,
        N'Добавлен студент: ' + ISNULL(i.ФИО, N'') +
        N', группа=' + ISNULL(i.код_группы, N'') +
        N', специальность=' + ISNULL(i.код_специальности, N'')
    FROM inserted AS i;
END;
GO

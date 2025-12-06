USE Дипломное_проектирование
GO

CREATE TRIGGER trg_Студенты_DEL
ON dbo.Студенты
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Аудит_Студенты
	(Операция, Код_студента, Старый_ср_балл, Примечание)
    SELECT
        N'DELETE',
        d.Код_студента,
        d.средний_балл_успеваемости,
        N'Удалён студент: ' + ISNULL(d.ФИО, N'') +
        N', группа=' + ISNULL(d.код_группы, N'') +
        N', спец='   + ISNULL(d.код_специальности, N'')
    FROM deleted d;
END;
GO

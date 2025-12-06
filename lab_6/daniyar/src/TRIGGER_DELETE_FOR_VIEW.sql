CREATE TRIGGER trg_vMy_view2_DEL
ON dbo.vMy_view2
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DefaultGroup nvarchar(100) = N'ГРУППА_ПО_УМОЛЧАНИЮ';
    -- тот же код группы, что и в триггере INSERT

    DELETE s
    FROM dbo.Студенты s
    JOIN deleted d
        ON  s.ФИО                       = d.ФИО_Студента
        AND s.код_специальности         = d.Код_специальности
        AND s.средний_балл_успеваемости = d.Средний_балл_успеваемости
        AND s.код_группы                = @DefaultGroup;
END;
GO

CREATE TRIGGER trg_vMy_view2_UPD
ON dbo.vMy_view2
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DefaultGroup nvarchar(100) = N'ГРУППА_ПО_УМОЛЧАНИЮ';
    -- тот же код группы, что и в INSERT/DELETE

    -- Предполагаем, что через vMy_view2 изменяется только Средний_балл_успеваемости.
    -- ФИО_Студента и Код_специальности считаем ключом и не меняем.

    UPDATE s
    SET
        s.средний_балл_успеваемости = i.Средний_балл_успеваемости
    FROM dbo.Студенты s
    JOIN inserted i
        ON  s.ФИО               = i.ФИО_Студента
        AND s.код_специальности = i.Код_специальности
        AND s.код_группы        = @DefaultGroup;
END;
GO

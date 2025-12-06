DROP TRIGGER IF EXISTS trg_vMy_view2_INS;
GO

CREATE TRIGGER trg_vMy_view2_INS
ON dbo.vMy_view2
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DefaultGroup nvarchar(100) = N'ГРУППА_ПО_УМОЛЧАНИЮ'; 
    -- TODO: здесь указать реальный код группы из dbo.Группа

    INSERT INTO dbo.Студенты
        (ФИО, код_группы, код_специальности, средний_балл_успеваемости)
    SELECT
        i.ФИО_Студента,
        @DefaultGroup,
        i.Код_специальности,
        i.Средний_балл_успеваемости
    FROM inserted i;
END;
GO

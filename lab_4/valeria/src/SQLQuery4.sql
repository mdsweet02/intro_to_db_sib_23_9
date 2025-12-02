CREATE OR ALTER VIEW vw_DocumentExecution AS
SELECT
    r.[Номер_документа],
    rez.[Дата] AS [Дата_резолюции],
    s.[ФИО] AS [Исполнитель],
    rez.[Описание_работы_по_документу]
FROM [Резолюция] rez
JOIN [Сотрудники] s ON rez.[Код_исполнителя] = s.[Код]
JOIN [Регистрация] r ON rez.[Номер_документа] = r.[Номер_документа];
-- Вставляем нового гражданина
INSERT INTO Citizens (
    IIN, FIO, [Date of birth], [Place of birth],
    [Residential address], Paul, [Document number],
    [Date of issue of the document], [Nationality code], Status
)
VALUES (
    '999999999999', 
    N'Гражданин для теста INSERT', 
    '2001-01-01', 
    N'Алматы', 
    N'Алматы', 
    N'М', 
    'XX1111111', 
    '2021-01-01', 
    '1', 
    N'Активный'
);

-- Проверяем таблицу логов
SELECT * FROM Citizens_Log WHERE IIN = '999999999999';


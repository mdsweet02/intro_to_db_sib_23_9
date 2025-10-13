SELECT 'Районы' AS tbl, COUNT(*) AS cnt FROM Районы
UNION ALL
SELECT 'Банки', COUNT(*) FROM Банки
UNION ALL
SELECT 'Страховщики', COUNT(*) FROM Страховщики
UNION ALL
SELECT 'Виды_страхования', COUNT(*) FROM Виды_страхования
UNION ALL
SELECT 'Объекты_страхования', COUNT(*) FROM Объекты_страхования
UNION ALL
SELECT 'Клиенты', COUNT(*) FROM Клиенты
UNION ALL
SELECT 'Договора', COUNT(*) FROM Договора
UNION ALL
SELECT 'Перечисления', COUNT(*) FROM Перечисления;



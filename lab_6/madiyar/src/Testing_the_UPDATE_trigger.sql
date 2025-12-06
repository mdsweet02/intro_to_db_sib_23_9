-- Удаляем тестовую строку
DELETE FROM Citizens
WHERE IIN = '999999999999';

-- Проверяем архив
SELECT * FROM Citizens_Archive WHERE IIN = '999999999999';

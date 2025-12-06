-- Обновляем ФИО
UPDATE Citizens
SET FIO = N'Гражданин для теста UPDATE'
WHERE IIN = '999999999999';

-- Проверяем лог
SELECT * FROM Citizens_Log WHERE IIN = '999999999999';

Проверка триггера DELETE
Триггер переносит удалённые данные в архив:
-- Удаляем тестовую строку
DELETE FROM Citizens
WHERE IIN = '999999999999';

-- Проверяем архив
SELECT * FROM Citizens_Archive WHERE IIN = '999999999999';


create database Phonoteka

use Phonoteka

create table [countries] (
	[country code] int primary key,
	[name] varchar(20) not null
	);


create table [disk categories] (
	[disk category code] int primary key,
	[name] varchar(30) not null
	);


create table [disk] (
	[disk code] int primary key,
	[name] varchar(30) not null,
	[release date] date,
	[disk category code] int references [disk categories]([disk category code]),
	[artist type code] int,
	[country code] int references [countries]([country code]),
	[sound duration] varchar(20) not null,
	[the price is collateral]  decimal(10, 2),
	[the cost of rent per day] decimal(5, 2),
	[total number of copies] int,
	[availability of instances] int
	);


create table [disk contents] (
	[disk code] int references [disk]([disk code]),
	[the code of a piece of music] int
	);


create table [categories of works] (
	[category code] int primary key,
	[name] varchar(30) not null
	);


create table [musical works] (
	[product ñode] int primary key,
	[name] varchar(30) not null,
	[category code] int references [categories of works]([category code]),
	[text] varchar(5000) not null,
	[the text author's code] int not null,
	[the music author's code] int not null,
	[performer's code] int not null
	);



create table [client] (
	[client's code] int primary key,
	[Full name of the client] varchar(50) not null,
	[residential address] varchar(50),
	[telephone] varchar(15) not null
	);


create table [music authors] (
	[music author's code] int primary key,
	[full name] varchar(50) not null
	);


create table [text authors] (
	[text author's code] int primary key,
	[full name] varchar(50) not null
	);


create table [performers] (
	[performer's code] int primary key,
	[full name] varchar(50) not null
);


create table [movement] (
	[disk number] int references [disk]([disk code]),
	[client's code] int references[client]([client's code]),
	[date of issue] date,
	[for how long was it issued] int,
	[return date] date
);




INSERT INTO [disk categories] ([disk category code], [name]) VALUES
(1, 'Ðîê'),
(2, 'Ïîï'),
(3, 'Êëàññèêà'),
(4, 'Äæàç'),
(5, 'Ýëåêòðîííàÿ ìóçûêà'),
(6, 'Ôîëê'),
(7, 'Êàíòðè'),
(8, 'Õèï-õîï'),
(9, 'Ðåããè'),
(10, 'Ìåòàëë');


INSERT INTO [countries] ([country code], [name]) VALUES
(1, 'Ðîññèÿ'),
(2, 'ÑØÀ'),
(3, 'Ãåðìàíèÿ'),
(4, 'Âåëèêîáðèòàíèÿ'),
(5, 'Ôðàíöèÿ'),
(6, 'ßïîíèÿ'),
(7, 'Êèòàé'),
(8, 'Èòàëèÿ'),
(9, 'Èñïàíèÿ'),
(10, 'Àâñòðàëèÿ');


INSERT INTO [performers] ([performer's code], [full name]) VALUES
(1, 'Äæîí Ëåííîí'),
(2, 'Áîá Äèëàí'),
(3, 'Áüîðê'),
(4, 'Òåéëîð Ñâèôò'),
(5, 'Êàíüå Óýñò'),
(6, 'Ýìèíåì'),
(7, 'Ìàéêë Äæåêñîí'),
(8, 'Ëåäè Ãàãà'),
(9, 'Ëåîíàðä Êîýí'),
(10, 'Ýä Øèðàí');


INSERT INTO [music authors] ([music author's code], [full name]) VALUES
(1, 'Ëþäâèã âàí Áåòõîâåí'),
(2, 'Âîëüôãàíã Àìàäåé Ìîöàðò'),
(3, 'Äæîí Ëåííîí'),
(4, 'Áîá Äèëàí'),
(5, 'Òåéëîð Ñâèôò'),
(6, 'Êàíüå Óýñò'),
(7, 'Ôðåääè Ìåðêüþðè'),
(8, 'Áüîðê'),
(9, 'Ýìèíåì'),
(10, 'Ëåäè Ãàãà');


INSERT INTO [text authors] ([text author's code], [full name]) VALUES
(1, 'Áîá Äèëàí'),
(2, 'Òåéëîð Ñâèôò'),
(3, 'Ìàéêë Äæåêñîí'),
(4, 'Ëåîíàðä Êîýí'),
(5, 'Êàíüå Óýñò'),
(6, 'Ëåäè Ãàãà'),
(7, 'Äæîí Ëåííîí'),
(8, 'Ýìèíåì'),
(9, 'Áüîðê'),
(10, 'Ôðåääè Ìåðêüþðè');


INSERT INTO [categories of works] ([category code], [name]) VALUES
(1, 'Ìåëîäèÿ'),
(2, 'Áàëàäà'),
(3, 'Îïåðà'),
(4, 'Ãèìí'),
(5, 'Ðîê-áàëëàäà'),
(6, 'Ïåñíÿ'),
(7, 'Ôîëê'),
(8, 'Êàíòðè'),
(9, 'Òàíöåâàëüíàÿ'),
(10, 'Èíñòðóìåíòàëüíàÿ');


INSERT INTO [musical works] ([product ñode], [name], [category code], [text], [the text author's code], [the music author's code], [performer's code]) VALUES
(1, 'Imagine', 1, 'Imagine all the people living life in peace...', 1, 3, 1),
(2, 'Like a Rolling Stone', 2, 'Once upon a time you dressed so fine...', 2, 4, 2),
(3, 'Bad Romance', 5, 'I want your love and I want your revenge...', 6, 8, 6),
(4, 'Billie Jean', 1, 'She says I am the one...', 4, 7, 7),
(5, 'Bohemian Rhapsody', 6, 'Is this the real life? Is this just fantasy...', 10, 7, 9),
(6, 'Poker Face', 9, 'I wanna hold ’em like they do in Texas, please...', 6, 8, 6),
(7, 'Smells Like Teen Spirit', 3, 'With the lights out, it’s less dangerous...', 8, 7, 8),
(8, 'Thriller', 1, 'It’s close to midnight...', 4, 7, 7),
(9, 'Hallelujah', 2, 'Now I’ve heard there was a secret chord...', 3, 9, 9),
(10, 'Shake It Off', 7, 'And the players gonna play, play, play...', 2, 5, 4),
(11, 'Lose Yourself', 2, 'Look, if you had one shot, or one opportunity...', 8, 9, 8),
(12, 'Let It Be', 3, 'When I find myself in times of trouble...', 1, 3, 1),
(13, 'Blinding Lights', 6, 'I’ve been tryna call...', 5, 5, 4),
(14, 'Rolling in the Deep', 2, 'We could have had it all...', 2, 4, 5),
(15, 'Shape of You', 1, 'The club isn’t the best place to find a lover...', 4, 5, 10),
(16, 'Someone Like You', 3, 'I heard that you’re settled down...', 2, 5, 4),
(17, 'Firework', 9, 'Do you ever feel like a plastic bag...', 2, 8, 6),
(18, 'All of Me', 6, 'Cause all of me loves all of you...', 7, 9, 10),
(19, 'Uptown Funk', 1, 'This hit, that ice cold...', 9, 7, 6),
(20, 'Hey Jude', 5, 'Hey Jude, don’t make it bad...', 1, 3, 1);


INSERT INTO [disk] ([disk code], [name], [release date], [disk category code], [artist type code], [country code], [sound duration], [the price is collateral], [the cost of rent per day], [total number of copies], [availability of instances]) VALUES
(1, 'Let It Be', '1970-05-08', 3, 1, 1, '00:45:00', 300.00, 25.00, 50, 50),
(2, 'Thriller', '1982-11-30', 2, 7, 2, '00:42:00', 500.00, 35.00, 100, 100),
(3, 'The Dark Side of the Moon', '1973-03-01', 1, 9, 3, '00:43:00', 350.00, 30.00, 70, 70),
(4, 'Abbey Road', '1969-09-26', 1, 1, 4, '00:47:00', 400.00, 28.00, 60, 60),
(5, 'Born to Run', '1975-08-25', 4, 5, 5, '00:38:00', 250.00, 20.00, 30, 30),
(6, 'Hotel California', '1976-12-08', 5, 6, 6, '00:44:00', 450.00, 32.00, 80, 80),
(7, 'The Wall', '1979-11-30', 1, 8, 7, '01:00:00', 600.00, 40.00, 120, 120),
(8, 'Sticky Fingers', '1971-04-23', 2, 9, 8, '00:42:00', 500.00, 38.00, 110, 110),
(9, 'Back in Black', '1980-07-25', 1, 10, 9, '00:41:00', 450.00, 36.00, 90, 90),
(10, 'The Beatles', '1968-11-22', 1, 1, 10, '00:35:00', 350.00, 28.00, 50, 50),
(11, 'Born This Way', '2011-05-23', 2, 6, 6, '00:45:00', 400.00, 30.00, 80, 80),
(12, 'The Fame Monster', '2009-11-18', 2, 6, 8, '00:38:00', 350.00, 28.00, 75, 75),
(13, 'Lover', '2019-08-23', 5, 4, 5, '00:45:00', 375.00, 29.00, 65, 65),
(14, 'Good Kid, M.A.A.D City', '2012-10-22', 7, 8, 7, '00:50:00', 420.00, 32.00, 90, 90),
(15, 'A Night at the Opera', '1975-11-21', 3, 9, 9, '00:43:00', 480.00, 35.00, 100, 100),
(16, 'The Chronic', '1992-12-15', 8, 8, 2, '00:56:00', 450.00, 33.00, 60, 60),
(17, 'Graduation', '2007-09-11', 9, 7, 5, '00:50:00', 500.00, 36.00, 120, 120),
(18, 'Future Nostalgia', '2020-03-27', 1, 10, 6, '00:40:00', 350.00, 30.00, 85, 85),
(19, 'Views', '2016-04-29', 1, 4, 6, '00:48:00', 475.00, 34.00, 95, 95),
(20, 'Take Care', '2011-11-15', 9, 8, 5, '00:52:00', 420.00, 32.00, 110, 110);


INSERT INTO [disk contents] ([disk code], [the code of a piece of music]) VALUES
(1, 12), (1, 13), (1, 14), (1, 15),
(2, 1), (2, 2), (2, 3), (2, 4),
(3, 5), (3, 6), (3, 7), (3, 8),
(4, 9), (4, 10), (4, 11), (4, 12),
(5, 13), (5, 14), (5, 15), (5, 16),
(6, 17), (6, 18), (6, 19), (6, 20),
(7, 1), (7, 2), (7, 3), (7, 4),
(8, 5), (8, 6), (8, 7), (8, 8),
(9, 9), (9, 10), (9, 11), (9, 12),
(10, 13), (10, 14), (10, 15), (10, 16),
(11, 17), (11, 18), (11, 19), (11, 20),
(12, 1), (12, 2), (12, 3), (12, 4),
(13, 5), (13, 6), (13, 7), (13, 8),
(14, 9), (14, 10), (14, 11), (14, 12),
(15, 13), (15, 14), (15, 15), (15, 16),
(16, 17), (16, 18), (16, 19), (16, 20);


INSERT INTO [client] ([client's code], [Full name of the client], [residential address], [telephone]) VALUES
(1, 'Èâàí Èâàíîâ', 'Ìîñêâà, óë. Ëåíèíà, 10', '89001112201'),
(2, 'Ïåòð Ïåòðîâ', 'Ñàíêò-Ïåòåðáóðã, óë. Ïóøêèíà, 5', '89001112202'),
(3, 'Ñåðãåé Ñåðãååâ', 'Íîâîñèáèðñê, óë. Ñâåðäëîâà, 15', '89001112203'),
(4, 'Àííà Àíòîíîâà', 'Åêàòåðèíáóðã, óë. ×åõîâà, 12', '89001112204'),
(5, 'Ìàðèÿ Âàñèëüåâà', 'Êàçàíü, óë. Ìèðà, 3', '89001112205'),
(6, 'Àëåêñàíäð Àëåêñååâ', 'Íèæíèé Íîâãîðîä, óë. Ãîðüêîãî, 8', '89001112206'),
(7, 'Åëåíà Åëåíîâà', 'Ðîñòîâ-íà-Äîíó, óë. Êàëèíèíà, 9', '89001112207'),
(8, 'Ìàêñèì Ìàêñèìîâ', 'Âîëãîãðàä, óë. Äçåðæèíñêîãî, 6', '89001112208'),
(9, 'Îëüãà Îðëîâà', '×åëÿáèíñê, óë. Ëåíèíà, 20', '89001112209'),
(10, 'Äìèòðèé Äìèòðèåâ', 'Òîìñê, óë. Êàðëà Ìàðêñà, 18', '89001112210'),
(11, 'Âèêòîð Âèêòîðîâ', 'Êðàñíîäàð, óë. 40 ëåò Ïîáåäû, 7', '89001112211'),
(12, 'Èðèíà Èðèíà', 'Ïåðìü, óë. Ïîáåäû, 25', '89001112212'),
(13, 'ßðîñëàâ ßðîñëàâîâ', 'Áàðíàóë, óë. Ìàÿêîâñêîãî, 14', '89001112213'),
(14, 'Åâãåíèé Åâãåíüåâ', 'Òþìåíü, óë. Ãàãàðèíà, 9', '89001112214'),
(15, 'Òàòüÿíà Òàòüÿíîâà', 'Ñî÷è, óë. Êóðîðòíàÿ, 5', '89001112215'),
(16, 'Íèêèòà Íèêèòèí', 'Óôà, óë. Ëåíèíà, 2', '89001112216'),
(17, 'Îêñàíà Îêñàðîâà', 'Âëàäèâîñòîê, óë. Êàðëà Ìàðêñà, 16', '89001112217'),
(18, 'Ðîìàí Ðîìàíîâ', 'Èðêóòñê, óë. Ñâåðäëîâà, 11', '89001112218'),
(19, 'Àíäðåé Àíäðååâ', 'Êàëóãà, óë. ×åõîâà, 4', '89001112219'),
(20, 'Þëèÿ Þëèåâà', 'Ñàìàðà, óë. Ïðîëåòàðñêàÿ, 8', '89001112220');

INSERT INTO movement ([disk number], [client's code], [date of issue], [for how long was it issued], [return date]) VALUES
(1,  1,  '2023-10-01', 7,  '2023-10-08'),
(2,  2,  '2023-10-02', 5,  '2023-10-07'),
(3,  3,  '2023-10-03', 10, '2023-10-13'),
(4,  4,  '2023-10-04', 3,  '2023-10-07'),
(5,  5,  '2023-10-05', 14, '2023-10-19'),
(6,  6,  '2023-10-06', 7,  '2023-10-13'),
(7,  7,  '2023-10-07', 21, '2023-10-28'),
(8,  8,  '2023-10-08', 4,  '2023-10-12'),
(9,  9,  '2023-10-09', 8,  '2023-10-17'),
(10, 10, '2023-10-10', 5,  '2023-10-15'),
(11, 11, '2023-10-11', 12, '2023-10-23'),
(12, 12, '2023-10-12', 3,  '2023-10-15'),
(13, 13, '2023-10-13', 6,  '2023-10-19'),
(14, 14, '2023-10-14', 7,  '2023-10-21'),
(15, 15, '2023-10-15', 10, '2023-10-25'),
(16, 16, '2023-10-16', 5,  '2023-10-21'),
(17, 17, '2023-10-17', 6,  '2023-10-23'),
(18, 18, '2023-10-18', 8,  '2023-10-26'),
(19, 19, '2023-10-19', 4,  '2023-10-23'),
(20, 20, '2023-10-20', 9,  '2023-10-29');









CREATE VIEW view_movement_2023 AS
SELECT 
    m.[disk number],
    d.[name] AS disk_name,
    m.[client's code],
    c.[Full name of the client],
    m.[date of issue],
    m.[for how long was it issued],
    m.[return date]
FROM movement m
JOIN [disk] d ON m.[disk number] = d.[disk code]
JOIN client c ON m.[client's code] = c.[client's code]
WHERE YEAR(m.[date of issue]) = 2023;



CREATE VIEW view_disks_of_performer_1 AS
SELECT DISTINCT 
    d.[disk code],
    d.[name] AS disk_name,
    p.[full name] AS performer
FROM [disk] d
JOIN [disk contents] dc ON d.[disk code] = dc.[disk code]
JOIN [musical works] mw ON dc.[the code of a piece of music] = mw.[product ñode]
JOIN performers p ON mw.[performer's code] = p.[performer's code]
WHERE mw.[performer's code] = 1;




CREATE VIEW view_works_count_per_disk AS
SELECT 
    d.[disk code],
    d.[name] AS disk_name,
    COUNT(dc.[the code of a piece of music]) AS works_count
FROM [disk] d
LEFT JOIN [disk contents] dc ON d.[disk code] = dc.[disk code]
GROUP BY d.[disk code], d.[name];





CREATE VIEW view_disk_with_category AS
SELECT 
    d.[disk code],
    d.[name] AS disk_name,
    dc.[name] AS category,
    d.[release date],
    d.[sound duration]
FROM [disk] d
JOIN [disk categories] dc ON d.[disk category code] = dc.[disk category code];





CREATE VIEW view_client_edit AS
SELECT 
    [client's code],
    [Full name of the client],
    [telephone]
FROM client







CREATE PROCEDURE Get_Long_Rent
AS
BEGIN
    SELECT *
    FROM [movement]
    WHERE DATEDIFF(day, [date of issue], [return date]) > 10;
END;

EXEC Get_Long_Rent




CREATE PROCEDURE Get_Disks_By_Category
    @categoryCode INT
AS
BEGIN
    SELECT *
    FROM [disk]
    WHERE [disk category code] = @categoryCode;
END;


EXEC Get_Disks_By_Category 1




CREATE PROCEDURE Insert_Three_Disk_Categories
    @startCode INT
AS
BEGIN
    DECLARE @i INT = 0;
    DECLARE @code INT = @startCode;

    WHILE @i < 3
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM [disk categories] WHERE [disk category code] = @code)
        BEGIN
            INSERT INTO [disk categories] ([disk category code], [name])
            VALUES (@code, CONCAT('Íîâàÿ êàòåãîðèÿ ', @code));
        END

        SET @code = @code + 1;
        SET @i = @i + 1;
    END
END;




EXEC Insert_Three_Disk_Categories 11






CREATE PROCEDURE Get_Collateral_Cost
    @diskCode INT
AS
BEGIN
    SELECT 
        [disk code],
        [availability of instances] AS available_instances,
        [the price is collateral]   AS collateral_price_per_item,
        [availability of instances] * [the price is collateral] AS total_collateral_cost
    FROM [disk]
    WHERE [disk code] = @diskCode;
END;


EXEC Get_Collateral_Cost 1





CREATE FUNCTION dbo.fn_GetCollateralCost (@diskCode INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @result DECIMAL(18,2);

    SELECT @result =
        [availability of instances] * [the price is collateral]
    FROM [disk]
    WHERE [disk code] = @diskCode;

    RETURN @result;
END;


SELECT dbo.fn_GetCollateralCost(1);





CREATE FUNCTION fn_Disks_By_Country (@countryCode INT)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM [disk]
    WHERE [country code] = @countryCode
);




SELECT * FROM fn_Disks_By_Country(6);






CREATE TRIGGER trg_movement_insert
ON movement
FOR INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE d
    SET d.[availability of instances] = d.[availability of instances] - 1
    FROM [disk] d
    JOIN inserted i ON d.[disk code] = i.[disk number];

    PRINT 'Äîñòóïíûå ýêçåìïëÿðû óìåíüøåíû';
END;





CREATE TRIGGER trg_movement_delete
ON movement
FOR DELETE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE d
    SET d.[availability of instances] = d.[availability of instances] + 1
    FROM [disk] d
    JOIN deleted del ON d.[disk code] = del.[disk number];

    PRINT 'Ýêçåìïëÿð âîçâðàù¸í íà ñêëàä';
END;







CREATE TRIGGER trg_disk_price_update
ON [disk]
FOR UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE([the price is collateral])
    BEGIN
        DECLARE @old decimal(10,2), @new decimal(10,2);

        SELECT @old = d.[the price is collateral] FROM deleted d;
        SELECT @new = i.[the price is collateral] FROM inserted i;

        IF (@new > @old * 1.2 OR @new < @old * 0.8)
        BEGIN
            PRINT 'Îøèáêà: èçìåíåíèå öåíû áîëåå ÷åì íà 20% çàïðåùåíî!';
            ROLLBACK TRANSACTION;
        END
        ELSE
            PRINT 'Öåíà èçìåíåíà êîððåêòíî';
    END
END;



CREATE TRIGGER trg_view_insert_disk_work
ON view_works_count_per_disk
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [disk contents] ([disk code], [the code of a piece of music])
    SELECT i.[disk code], 1  
    FROM inserted i;

    PRINT 'Â äèñê äîáàâëåíî ìóçûêàëüíîå ïðîèçâåäåíèå';
END;


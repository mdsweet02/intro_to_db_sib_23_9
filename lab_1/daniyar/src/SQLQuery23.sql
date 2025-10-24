RESTORE DATABASE [Stud_Ayat_Daniar]
FROM DISK = 'D:\MSSQL_DATABASE_BACKUPS\Stud_Ayat_Daniar.bak'

WITH 
    MOVE N'Stud_Ayat_Daniar_1_dat' TO N'F:\Stud_Ayat_Daniar\Stud_Ayat_Daniar.mdf',
    MOVE N'Stud_Ayat_Daniar_1_log' TO N'F:\Stud_Ayat_Daniar\Stud_Ayat_Daniar.ldf'
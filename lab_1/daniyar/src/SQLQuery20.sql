USE master
GO
ALTER DATABASE Stud_ayat_Daniar SET SINGLE_USER WITH ROLLBACK IMMEDIATE
EXEC sp_detach_db 'Stud_Ayat_Daniar'
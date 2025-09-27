RESTORE DATABASE [Kabildina_Alsiya_OUT]
FROM DISK='C:\Users\KSTU.Student\Desktop\temp1\Kabildina_Alsiya.bak'


WITH 
   MOVE 'Kabildina_Alsiya_dat' TO 'E:\Alsiya\Kabildina_Alsiya.mdf',
   MOVE 'Kabildina_Alsiya_log' TO 'E:\Alsiya\Kabildina_Alsiya.ldf'
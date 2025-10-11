USE [Дипломное_проектирование]
CREATE TABLE Кафедры
(
	Код_кафедры INT PRIMARY KEY NOT NULL,
	наименование VARCHAR(50) NOT NULL
)

CREATE TABLE Специальности
(
	Код_специальности INT PRIMARY KEY NOT NULL,
	наименование VARCHAR(50) NOT NULL
)

CREATE TABLE Группа
(
	Код_группы INT PRIMARY KEY NOT NULL,
	наименование VARCHAR(50) NOT NULL UNIQUE,
	код_кафедры INT NOT NULL,
	FOREIGN KEY (Код_кафедры) REFERENCES Кафедры(Код_кафедры)
)

CREATE TABLE Студенты
(
	Код_студента INT PRIMARY KEY NOT NULL,
	ФИО VARCHAR(50) NOT NULL,
	код_группы INT NOT NULL,
	код_специальности INT NOT NULL,
	средний_балл_успеваемости FLOAT NOT NULL
		CHECK(средний_балл_успеваемости >= 0 AND средний_балл_успеваемости <= 100)
		FOREIGN KEY (код_группы) REFERENCES Группа(Код_группы)
			ON UPDATE CASCADE
			ON DELETE NO ACTION,
		FOREIGN KEY (код_специальности) REFERENCES Специальности(код_специальности)
			ON UPDATE CASCADE
			ON DELETE NO ACTION
)

CREATE TABLE Преподаватели 
(
	Код_преподавателя INT PRIMARY KEY NOT NULL,
	ФИО VARCHAR(50) NOT NULL,
	код_кафедры INT NOT NULL,
	запланированное_количество_дипломников TINYINT NOT NULL,
	число_вакансий TINYINT NOT NULL, 
)

CREATE TABLE Состав_ГАК
(
	ИИН INT PRIMARY KEY NOT NULL,
	код_специальности INT NOT NULL,
	выполняемые_функции VARCHAR(50) NOT NULL
		FOREIGN KEY (код_специальности) REFERENCES Специальности(код_специальности)
)

CREATE TABLE Категории_типов_проектов
(
	Код_типа_категории_проекта INT PRIMARY KEY NOT NULL,
	наименование VARCHAR(50) NOT NULL
)

CREATE TABLE Проект
(
	код_рецензента INT PRIMARY KEY NOT NULL,
	Код_студента INT NOT NULL,
	код_преподавателя_руководителя INT NOT NULL,
	тема_дипломного_проекта VARCHAR(255) NOT NULL,
	код_типа_категории_проекта INT NOT NULL,
	FOREIGN KEY (Код_студента) REFERENCES Студенты(Код_студента),
	FOREIGN KEY (код_преподавателя_руководителя) REFERENCES Преподаватели(Код_преподавателя),
	FOREIGN KEY (код_типа_категории_проекта) REFERENCES Категории_типов_проектов(Код_типа_категории_проекта)
)

CREATE TABLE Банки
(
	Код_банка INT PRIMARY KEY NOT NULL,
	наименование VARCHAR(50) NOT NULL UNIQUE
)

CREATE TABLE Рецензенты_члены_ГАК
(
	ИИН CHAR(12) NOT NULL,
	ФИО VARCHAR(255) NOT NULL,
	код_банка INT NOT NULL,
	домашний_адрес VARCHAR(255) NOT NULL,
	телефон INT NOT NULL,
	место_работы VARCHAR(255) NOT NULL,
	должность VARCHAR(50) NOT NULL,
	номер_удостоверения_личности_ CHAR(12) NOT NULL,
	дата_выдачи_документа DATE NOT NULL,
	кем_выдан VARCHAR(50) NOT NULL,
	запланированное_количество_дипломников INT NOT NULL,
	FOREIGN KEY (код_банка) REFERENCES Банки(Код_банка)
)


CREATE TABLE График_защиты
(
	дата INT NOT NULL,
	код_студента INT NOT NULL
)

CREATE TABLE Результаты_ГАК
(
	дата DATE NOT NULL,
	оценка INT NOT NULL,
	тип_итоговой_аттестации VARCHAR(50)
		CONSTRAINT тип_итоговой_аттестации
		CHECK (тип_итоговой_аттестации IN (N'гос. экзамен', N'защита дипл.проекта'))
)
-- In mySQL Server, the regular expression is used with REGEXP function, 
-- while in MySQL it is used with LIKE operator. Also, the []  and 
-- '' is different syntax with the same meaning at the two servers. 
-- Except for these, no incompatibility.

CREATE DATABASE Instructor_Schedule_Management;
USE Instructor_Schedule_Management;
-- table1
CREATE TABLE Instructor(
	Instructor_id NUMERIC(9,0) PRIMARY KEY ,
	Instructor_name VARCHAR(35) NOT NULL ,
    Title CHAR(20) DEFAULT 'NULL',
    email_address VARCHAR(35) UNIQUE NOT NULL ,
    office_phone NUMERIC(10) UNIQUE NOT NULL ,
    
    CONSTRAINT Instructor_id_constraint CHECK(Instructor_id BETWEEN 0 AND 1000000000),
    CONSTRAINT Instructor_em_constraint CHECK(email_address LIKE '%@douglascollege.ca'),
    CONSTRAINT Instructor_ph_constraint CHECK(999999999 < office_phone < 10000000000)
)ENGINE = InnoDB;
-- table2
CREATE TABLE Student(
	Student_id NUMERIC(9,0) PRIMARY KEY CHECK(Student_id BETWEEN 0 AND 1000000000),
	Student_Name VARCHAR(30) NOT NULL
)ENGINE = InnoDB;
-- table3
CREATE TABLE Course(
	CourseID VARCHAR(8) PRIMARY KEY CHECK(CourseID REGEXP '[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9]'),
    Course_Name VARCHAR(40) NOT NULL,
    Credit INT NOT NULL CHECK(0<Credit<10)
)ENGINE = InnoDB;
-- table4
CREATE TABLE `Schedule`(
	`Date` DATE NOT NULL, 
    Start_Time TIME NOT NULL,
    End_Time TIME NOT NULL,
    
    PRIMARY KEY(`Date`, Start_Time, End_Time),
    CHECK (`Date` >= '1970-01-01')
)ENGINE = InnoDB;
-- table5
CREATE TABLE Semester(
	`Year` NUMERIC(4) NOT NULL CHECK(`Year` > 2000),
    Term VARCHAR(6) NOT NULL ,
    
    PRIMARY KEY(`Year`, Term),
    CHECK (Term IN ('Summer', 'Fall', 'Winter'))
)ENGINE = InnoDB;
-- table6
CREATE TABLE ROOM (
	Campus VARCHAR(15) NOT NULL,
    Room_Num VARCHAR(6) NOT NULL ,
    
    PRIMARY KEY(Campus, Room_Num),
    CONSTRAINT Campus_Format CHECK (Campus IN ('NEW WESTMINSTER', 'COQUITLAM', 'ANVIL TOWER')),
    CONSTRAINT Room_Num_Format CHECK (Room_Num REGEXP '[A-Z][A-Z][0-9][0-9][0-9][0-9]'
		OR Room_Num REGEXP '[A-Z][A-Z][A-Z][0-9][0-9][0-9]'
        OR Room_Num REGEXP '[A-Z][0-9][0-9][0-9][0-9]')
)ENGINE = InnoDB;
-- table7
CREATE TABLE Course_Semester_Section(
	`Year` NUMERIC(4) NOT NULL CHECK(2000<`Year`),
    Term VARCHAR(6) NOT NULL CHECK(Term IN ('WINTER', 'SUMMER', 'FALL')),
    CourseID VARCHAR(8) CHECK(CourseID REGEXP '[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9]'),
    Sec_id INT NOT NULL CHECK(1<Sec_id<20),
    SType VARCHAR(9) NOT NULL CHECK(SType IN ('ONLINE', 'IN-PERSON')),
    
    PRIMARY KEY(`Year`, Term, CourseID, Sec_id),
    FOREIGN KEY(`Year`, Term) REFERENCES Semester(`Year`, Term) ON DELETE CASCADE,
    FOREIGN KEY(CourseID) REFERENCES Course(CourseID)ON DELETE CASCADE
)ENGINE = InnoDB;
-- table8
CREATE TABLE Instructor_Student_Appointment(
	Instructor_id NUMERIC(9) CHECK(0<Instructor_id<1000000000),
    Student_id NUMERIC(9) NOT NULL CHECK(0<Student_id<1000000000),
    `Date` DATE NOT NULL,
    `Time` VARCHAR(11) NOT NULL,
    `Subject` VARCHAR(30), 
    
    PRIMARY KEY(Instructor_id, Student_id, `Date`, `Time`),
    FOREIGN KEY(Instructor_id) REFERENCES Instructor(Instructor_id) ON DELETE CASCADE,
    FOREIGN KEY(Student_id) REFERENCES Student(Student_id) ON DELETE CASCADE,
    CHECK (`Time` REGEXP '[0-9][0-9]:[0-9][0-9]-[0-9][0-9]:[0-9][0-9]')
)ENGINE = InnoDB;
-- table9
CREATE TABLE Instructor_Has_Schedule(
	Instructor_id NUMERIC(9) CHECK(0<Instructor_id<100000000),
    `Date` DATE NOT NULL CHECK (`Date` >= '1970-01-01'),
    Start_Time TIME NOT NULL,
    End_Time TIME NOT NULL,
    
    PRIMARY KEY(Instructor_id, `Date`, Start_Time, End_Time),
	FOREIGN KEY(Instructor_id) REFERENCES Instructor(Instructor_id) ON DELETE CASCADE,
    FOREIGN KEY(`Date`, Start_Time, End_Time) REFERENCES `Schedule`(`Date`, Start_Time, End_Time) ON DELETE CASCADE
)ENGINE = InnoDB;
-- table10
CREATE TABLE Teaching_Involve_Section(
	`Date` DATE NOT NULL,
    Start_Time TIME NOT NULL,
    End_Time TIME NOT NULL,
	`Year` NUMERIC(4) NOT NULL CHECK(2000<`Year`),
    Term VARCHAR(6) NOT NULL CHECK(Term IN ('WINTER', 'SUMMER', 'FALL')),
	CourseID VARCHAR(8) CHECK(CourseID REGEXP '[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9]'),
    Sec_id INT CHECK(1<Sec_id<20),
    
    PRIMARY KEY(`Date`, Start_Time, End_Time, `Year`, Term, CourseID, Sec_id),
    CHECK (`Date` >= '1970-01-01'),
	FOREIGN KEY(`Date`, Start_Time, End_Time) REFERENCES `Schedule`(`Date`, Start_Time, End_Time) ON DELETE CASCADE, 
	FOREIGN KEY(`Year`, Term, CourseID, Sec_id) REFERENCES Course_Semester_Section(`Year`, Term, CourseID, Sec_id) ON DELETE CASCADE
)ENGINE = InnoDB;
-- table11
CREATE TABLE Section_Locate_Room(
	`Year` NUMERIC(4) NOT NULL CHECK(2000<`Year`),
    Term VARCHAR(6) NOT NULL CHECK(Term IN ('WINTER', 'SUMMER', 'FALL')),
    CourseID VARCHAR(8) NOT NULL CHECK(CourseID REGEXP '[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9]'),
    Sec_id INT NOT NULL CHECK(1<Sec_id<20),
    Campus VARCHAR(15) NOT NULL CHECK(Campus IN ('NEW WESTMINSTER', 'COQUITLAM', 'ANVIL TOWER')),
    Room_Num VARCHAR(10) NOT NULL,
    
    PRIMARY KEY(`Year`, Term, CourseID, Sec_id, Campus, Room_Num),
    FOREIGN KEY(`Year`, Term, CourseID, Sec_id) REFERENCES Course_Semester_Section(`Year`, Term, CourseID, Sec_id) ON DELETE CASCADE,
    FOREIGN KEY(Campus, Room_Num) REFERENCES ROOM(Campus, Room_Num) ON DELETE CASCADE,
    CONSTRAINT Room_Num_Format2 CHECK (Room_Num REGEXP '[A-Z][A-Z][0-9][0-9][0-9][0-9]' 
		OR Room_Num REGEXP '[A-Z][A-Z][A-Z][0-9][0-9][0-9]' 
        OR Room_Num REGEXP '[A-Z][0-9][0-9][0-9][0-9]')
)ENGINE = InnoDB;
-- table12
CREATE TABLE OfficeHours_Locate_Room(
	`Date` DATE NOT NULL, 
    Start_Time TIME NOT NULL,
    End_Time TIME NOT NULL,
    Campus VARCHAR(15),
    Room_Num VARCHAR(10),
    
    PRIMARY KEY(`Date`, Start_Time, End_Time, Campus, Room_Num),
    FOREIGN KEY(`Date`, Start_Time, End_Time) REFERENCES `Schedule`(`Date`, Start_Time, End_Time) ON DELETE CASCADE,
    FOREIGN KEY(Campus, Room_Num) REFERENCES ROOM(Campus, Room_Num) ON DELETE CASCADE,
    CONSTRAINT Campus_Check CHECK(Campus IN ('NEW WESTMINSTER', 'COQUITLAM', 'ANVIL TOWER')),
    CONSTRAINT Room_Num_Check CHECK (Room_Num REGEXP '[A-Z][A-Z][0-9][0-9][0-9][0-9]' 
		OR Room_Num REGEXP '[A-Z][A-Z][A-Z][0-9][0-9][0-9]' 
        OR Room_Num REGEXP '[A-Z][0-9][0-9][0-9][0-9]')
)ENGINE = InnoDB;
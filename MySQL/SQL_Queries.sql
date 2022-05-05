-- Scenario 1: An instructor check appointments information at a specific date
SELECT * 
FROM Instructor_Student_Appointment
WHERE Instructor_id = '46854655' AND `Date` = '2022-10-10';

-- Scenario 2: An instructor summarize the appointments he has within a specific period
SELECT Instructor_id, `Date`, `Time`, `Subject`
FROM Instructor_Student_Appointment
WHERE Instructor_id = '200256565' AND `Date` BETWEEN '2022-03-01' AND '2022-03-07';

-- Scenario 3: An instructor checks how many appointments he has with each students within a specific period
SELECT Student_id, COUNT(*) AS NumAppts 
FROM Instructor_Student_Appointment
WHERE Instructor_id = '200256565' AND `Date` BETWEEN '2022-03-01' AND '2022-03-07'
GROUP BY Student_id;

-- Scenario 4: An instructor check his schedule at a specific date
SELECT * 
FROM  Instructor_Has_Schedule
WHERE Instructor_id = '200256565' AND `Date` = '2022-03-07';

-- Scenario 5: An instructor summarize the schedule he has per day within a specific period
SELECT Instructor_id, `Date`, COUNT(*) AS NumSchedule
FROM Instructor_Has_Schedule
WHERE Instructor_id = '200256565' AND `Date` BETWEEN '2022-03-03' AND '2022-03-15'
GROUP BY Instructor_id, `Date`;

-- Scenario 6: A student checks the instructor's information (VIEW)
CREATE VIEW Student_Instructor AS
SELECT Instructor_name,Title, email_address, office_phone
FROM Instructor;
SELECT *
FROM Student_Instructor
WHERE Instructor_name = 'Ram';  

-- Scenario 7: Manager updates instructor name (UPDATE QUERY)
UPDATE Instructor
SET Instructor_name = 'JONNY'
WHERE Instructor_id = '111211';
SELECT * FROM Instructor;

-- Scenario 8: A student checks the afternoon schedule of a professor at two specific date (LEFT JOIN)
SELECT Instructor_name, `Date`, Start_Time, End_Time
FROM Instructor_Has_Schedule
LEFT JOIN Instructor ON Instructor.Instructor_id = Instructor_Has_Schedule.Instructor_id
WHERE Instructor_Has_Schedule.Instructor_id = '46854655' AND `Date` IN ('2021-05-15', '2021-05-16') AND Start_Time >= '12:00:00';

-- Scenario 9: A student checks what courses are opened at a specific semester (CROSS JOIN)
SELECT `Year`, Term, Course_Semester_Section.CourseID, Course.Course_Name, Sec_id, SType
FROM Course_Semester_Section
CROSS JOIN Course
WHERE Course.CourseID = Course_Semester_Section.CourseID AND `Year` = 2022 AND Term = 'FALL';

-- Scenario 10: Manager checks at a specific semester which rooms at which campus are not in use for any purpose (INNER JOIN, NATURAL JOIN)
SELECT Campus, Room_Num
FROM ROOM
WHERE CONCAT(Campus, Room_Num) NOT IN (
	SELECT CONCAT(ROOM.Campus, ROOM.Room_Num)
	FROM OfficeHours_Locate_Room
	INNER JOIN ROOM ON ROOM.Room_Num = OfficeHours_Locate_Room.Room_Num 
    AND ROOM.Campus = OfficeHours_Locate_Room.Campus
    WHERE `Date` BETWEEN '2022-01-01' AND '2022-04-30')  -- the time period of 2022 winter
AND CONCAT(Campus, Room_Num) NOT IN (
	SELECT CONCAT(ROOM.Campus, ROOM.Room_Num)
	FROM Section_Locate_Room
	NATURAL JOIN ROOM
    WHERE `Year`=2022 AND Term='Winter');

-- Scenario 11: a student check the location of all CSIS in-person sections at specific semester (FULL JOIN)
SELECT p.`Year`, p.Term, p.CourseID, p.Sec_id, SType, Campus, Room_Num
FROM Course_Semester_Section AS p
LEFT JOIN Section_Locate_Room AS q
ON p.`Year` = q.`Year`
AND p.Term = q.Term
AND p.CourseID = q.CourseID
AND p.Sec_id = q.Sec_id
WHERE p.`Year`=2022 AND p.Term='Fall' AND p.CourseID LIKE 'CSIS%' AND SType='In-Person'
UNION ALL
SELECT p.`Year`, p.Term, p.CourseID, p.Sec_id, SType, Campus, Room_Num
FROM Course_Semester_Section AS p
RIGHT JOIN Section_Locate_Room AS q
ON p.`Year` = q.`Year`
AND p.Term = q.Term
AND p.CourseID = q.CourseID
AND p.Sec_id = q.Sec_id
WHERE p.`Year`=2022 AND p.Term='Fall' AND p.CourseID LIKE 'CSIS%' AND SType='In-Person';

-- Scenario 12: A student check how many sections every course have and their type at a specific semester
SELECT CourseID, COUNT(*) AS CountSections 
FROM Course_Semester_Section
WHERE `Year` = 2022 AND Term = 'Fall'
GROUP BY CourseID;

-- Scenario 13: A student check the schedule of all in-person sections of all courses at a specific semester (RIGHT JOIN)
SELECT t.`Year`, t.Term, t.CourseID, t.Sec_id, SType, `Date`, Start_Time, End_Time
FROM Teaching_Involve_Section AS t
RIGHT JOIN (SELECT * FROM Course_Semester_Section WHERE SType='IN-PERSON') q
ON t.`Year` = q.`Year`
AND t.Term = q.Term
AND t.CourseID = q.CourseID
AND t.Sec_id = q.Sec_id
WHERE t.`Year`=2022 AND t.Term='Fall';

-- Scenario 14: Manager deletes a student's record (DELETE QUERY)
DELETE FROM Student WHERE Student_id = '895632581';
SELECT * FROM Student;

-- Scenario 15: A manager checks for a specific room, when it will be used for office hours
SELECT Campus, Room_Num, `Date`, Start_Time, End_Time
FROM OfficeHours_Locate_Room
WHERE Campus = 'NEW WESTMINSTER' AND Room_Num='SW6105';

-- Scenario 16: A manager check for a specific room, when it will be used for teaching within a specific period (LEFT JOIN)
SELECT Campus, Room_Num, `Date`, t.CourseID, t.Sec_id, Start_Time, End_Time
FROM Section_Locate_Room AS t
LEFT JOIN Teaching_Involve_Section AS q
ON t.`Year` = q.`Year`
AND t.Term = q.Term
AND t.CourseID = q.CourseID
AND t.Sec_id = q.Sec_id
WHERE Campus='NEW WESTMINSTER' AND Room_Num='NW5105' AND `Date` BETWEEN '2022-01-30' AND '2022-04-30';

-- Scenario 17: A manager summarize how many courses are held at each campus
SELECT `Year`, Term, Campus, COUNT(*) AS 'No. of Courses'
FROM Section_Locate_Room
GROUP BY `Year`, Term, Campus
ORDER BY `Year`, Term, Campus;

-- Scenario 18: A manager summarize for each room, how many courses it holds at a specific semester. Sort the data by descending order.
SELECT Campus, Room_Num, COUNT(*) AS 'Count'
FROM Section_Locate_Room
WHERE `Year` = 2022 AND Term = 'Fall'
GROUP BY Campus, Room_Num
ORDER BY 'Count' DESC;

-- Scenario 19: A manager summarize the times of rooms being used for office hours at a specific semester. Sort the data by descending order.
SELECT Campus, Room_Num, COUNT(*) AS 'Count'
FROM OfficeHours_Locate_Room
WHERE `Date` BETWEEN '2022-1-01' AND '2022-5-01'
GROUP BY Campus, Room_Num
ORDER BY 'Count' DESC;

-- Scenario 20: A manager summarize how many online and offline courses are held for two continuously years (LEFT JOIN)
SELECT t.`Year`, SType, Campus, COUNT(*) AS 'Count'
FROM Course_Semester_Section AS t
LEFT JOIN Section_Locate_Room AS q
ON t.`Year` = q.`Year`
AND t.Term = q.Term
AND t.CourseID = q.CourseID
AND t.Sec_id = q.Sec_id
WHERE t.`Year` IN (2021, 2022)
GROUP BY t.`Year`, SType, Campus
ORDER BY t.`Year`, SType, Campus;
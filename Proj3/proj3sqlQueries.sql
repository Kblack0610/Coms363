/*Returns count of classes taken by each student*/
SELECT 
    StudentID, COUNT(Grade)
FROM
    (SELECT 
        s.StudentID, CourseCode, Grade
    FROM
        Student s
    INNER JOIN Enrollment e ON s.StudentID = e.StudentID
    ORDER BY s.StudentID) AS StudentInfo
GROUP BY StudentID;

/*Update Credit Hours*/
UPDATE
	Student
SET 
	CreditHours = CreditHours + count*3
WHERE StudentID IN(SELECT 
					    StudentID, COUNT(Grade) count
					FROM
					    (SELECT 
					        s.StudentID, CourseCode, Grade
					    FROM
					        Student s
					    INNER JOIN Enrollment e ON s.StudentID = e.StudentID
					    ORDER BY s.StudentID) AS StudentInfo
					GROUP BY StudentID);

/*Then upate classification, order matters*/
UPDATE 
	Student
SET 
	Classification = "Sophomore"
WHERE
	CreditHours >= 30;

UPDATE 
	Student
SET 
	Classification = "Junior"
WHERE
	CreditHours >= 60;

UPDATE 
	Student
SET 
	Classification = "Senior"
WHERE
	CreditHours >= 90;

/*Update GPA*/
UPDATE
	Student
SET 
	GPA = GPA*CreditHours + uhhhhhh;

/*Mentor Name of All Seniors*/
SELECT 
    Name AS MentorName
FROM
    Person P
        INNER JOIN
    Instructor I ON P.ID = I.InstructorID
WHERE
    I.InstructorID IN (SELECT 
            MentorID
        FROM
            Student
        WHERE
            classification = 'Senior');

/*Top Seniors*/
SELECT 
    Name, MentorName, GPA, Classification
FROM
    Student S
        INNER JOIN
    Person pp ON pp.ID = S.StudentID
        INNER JOIN
    (SELECT 
        P.Name AS MentorName, I.InstructorID
    FROM
        Person P
    INNER JOIN Instructor I ON P.ID = I.InstructorID
    WHERE
        I.InstructorID IN (SELECT 
                MentorID
            FROM
                Student
            WHERE
                classification = 'Senior')

                ) AS Mentors 
                ON S.MentorID = InstructorID
WHERE Classification = 'Senior'
ORDER BY GPA desc;

/* Part A Query*/
SELECT 
	s.StudentID, CreditHours, CourseCode, Grade 
FROM 
	Student s 
INNER JOIN Enrollment e ON s.StudentID = e.StudentID 
ORDER BY s.StudentID;

/*Top Seniors Java Friendly*/
SELECT Name, MentorName, GPA, Classification
FROM Student S INNER JOIN Person pp ON pp.ID = S.StudentID
INNER JOIN (SELECT P.Name AS MentorName, I.InstructorID FROM
Person P INNER JOIN Instructor I ON P.ID = I.InstructorID
WHERE I.InstructorID IN (SELECT MentorID FROM Student
WHERE classification = 'Senior')) AS Mentors 
ON S.MentorID = InstructorID
WHERE Classification = 'Senior'
ORDER BY GPA desc;







/*Matthew Vanderwerf and Kenneth Black*/

/*item 1 */
CREATE TABLE Person (
    Name CHAR(20),
    ID CHAR(9) NOT NULL,
    Address CHAR(30),
    DOB DATE,
    PRIMARY KEY (ID)
);

/*item 2*/
CREATE TABLE Instructor (
    InstructorID CHAR(9) NOT NULL REFERENCES Person (ID),
    Rank CHAR(12),
    Salary INT,
    PRIMARY KEY (InstructorID)
);

/*item 3*/
CREATE TABLE Student (
    StudentID CHAR(9) NOT NULL REFERENCES Person (ID),
    Classification VARCHAR(10),
    GPA DOUBLE,
    MentorID CHAR(9) REFERENCES Instructor (InstructorID),
    CreditHours INT,
    PRIMARY KEY (studentID)
);
    
/*item 4*/
CREATE TABLE Course (
	CourseCode CHAR(6) NOT NULL,
    CourseName char(50),
    PreReq char(6)
);

/*item 5*/
CREATE TABLE Offering (
    CourseCode CHAR(6) NOT NULL,
    SectionNo INT NOT NULL,
    InstructorID CHAR(9) NOT NULL REFERENCES Instructor (InstructorID),
    PRIMARY KEY (CourseCode , SectionNo)
);

/*item 6*/
CREATE TABLE Enrollment (
    CourseCode CHAR(6) NOT NULL,
    SectionNo INT NOT NULL,
    StudentID CHAR(9) NOT NULL REFERENCES Student,
    Grade CHAR(4) NOT NULL,
    PRIMARY KEY (CourseCode , StudentID),
    FOREIGN KEY (CourseCode , SectionNo)
        REFERENCES Offering (CourseCode , SectionNo)
);

/*item 7*/
load xml local infile '/Users/derf/GithubLocalBranch/Coms363/Proj2/Person.xml'
into table Person
rows identified by '<Person>';

/*item 8*/
load xml local infile '/Users/derf/GithubLocalBranch/Coms363/Proj2/Instructor.xml'
into table Instructor
rows identified by '<Instructor>';

/*item 9*/
load xml local infile '/Users/derf/GithubLocalBranch/Coms363/Proj2/Student.xml'
into table Student
rows identified by '<Student>';

/*item 10*/
load xml local infile '/Users/derf/GithubLocalBranch/Coms363/Proj2/Course.xml'
into table Course
rows identified by '<Course>';

/*item 11*/
load xml local infile '/Users/derf/GithubLocalBranch/Coms363/Proj2/Offering.xml'
into table Offering
rows identified by '<Offering>';

/*item 12*/
load xml local infile '/Users/derf/GithubLocalBranch/Coms363/Proj2/Enrollment.xml'
into table Enrollment
rows identified by '<Enrollment>';

/*item 13*/
SELECT 
    StudentID, MentorID
FROM
    Student
WHERE
    (Classification = 'Junior'
        OR Classification = 'Senior')
        AND GPA > 3.8;
        
/*item 14*/
SELECT DISTINCT
    CourseCode, SectionNo
FROM
    Offering o
WHERE
    o.SectionNo IN (SELECT 
            SectionNo
        FROM
            Enrollment
        WHERE
            StudentID IN (SELECT 
                    StudentID
                FROM
                    Student
                WHERE
                    Classification = 'Sophomore'));
    
/*item 15*/
SELECT 
    Name, salary
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
            classification = 'Freshman');
            
/*item 16*/
SELECT 
    SUM(salary)
FROM
    Instructor I
WHERE
    I.InstructorID NOT IN (SELECT 
            InstructorID
        FROM
            Offering);
            
/*item 17*/
SELECT 
    Name, DOB
FROM
    Student
        INNER JOIN
    Person ON Person.ID = Student.StudentID
WHERE
    YEAR(Person.DOB) = 1976;
    
/*item 18*/
SELECT 
    Name, Rank
FROM
    Instructor
        INNER JOIN
    Person ON Instructor.InstructorID = Person.ID
WHERE
    Instructor.InstructorID NOT IN (SELECT 
            InstructorID
        FROM
            Offering)
        AND Instructor.InstructorID NOT IN (SELECT 
            MentorID
        FROM
            Student);
            
/*item 19*/
SELECT 
    ID, DOB, name
FROM
    Person
WHERE
    DOB IN (SELECT 
            MIN(DOB)
        FROM
            Student
                INNER JOIN
            Person ON Student.StudentID = Person.ID);

/*item 20*/
SELECT 
    ID, Name, DOB
FROM
    Person
WHERE
    Person.ID NOT IN (SELECT 
            StudentID
        FROM
            Student)
        AND Person.ID NOT IN (SELECT 
            InstructorID
        FROM
            Instructor);
            
/*item 21*/
SELECT 
    Name, COUNT(StudentID)
FROM
    Instructor I
        INNER JOIN
    Student s ON I.InstructorID = s.MentorID
        INNER JOIN
    Person p ON I.InstructorID = p.ID
GROUP BY Name;
    
/*item 22*/
SELECT 
    COUNT(StudentID), AVG(GPA)
FROM
    Student
GROUP BY Classification;

/*item 23*/
SELECT 
    CourseCode, MIN(count)
FROM
    (SELECT 
        CourseCode, COUNT(StudentID) count
    FROM
        Enrollment
    GROUP BY CourseCode) AS lowEnroll;
    
/*item 24*/
SELECT DISTINCT
    Student.StudentID, MentorID
FROM
    Instructor,
    Student,
    Enrollment,
    Offering
WHERE
    Student.StudentID = Enrollment.StudentID
        AND Enrollment.CourseCode = Offering.CourseCode
        AND Student.MentorID = Offering.InstructorID;
        
/*item 25*/
SELECT 
    StudentID, Name, CreditHours
FROM
    Student
        INNER JOIN
    Person ON Person.ID = StudentID
WHERE
    Classification = 'Freshman'
        AND YEAR(Person.DOB) >= 1976;

/*item 26*/
INSERT INTO Person(Name,ID,Address,DOB)
	VALUES ('Briggs Jason','480293439','215, North Hyland Avenue','1975-01-15');
Insert into Student(StudentID,Classification,GPA,MentorID,CreditHours)
	VALUES ('480293439','junior',3.48,'201586985','75');
Insert into Enrollment(CourseCode,SectionNo,StudentID,Grade)
	Values ('CS311',2,'480293439','A');
INSERT INTO Enrollment(CourseCode,SectionNo,StudentID,Grade)
	Values ('CS330',1,'480293439','A-');
    
Select *
From Person P
Where P.Name= "Briggs Jason";

Select *
From Student S
Where S.StudentID= "480293439";

SELECT 
    *
FROM
    Enrollment E
WHERE
    E.StudentID = "480293439";

/*item 27*/
DELETE FROM Enrollment 
WHERE
    StudentID IN (SELECT 
        StudentID
    FROM
        Student
    WHERE
        GPA < 0.5);
DELETE FROM Student 
WHERE
    GPA < 0.5;
	
SELECT 
    *
FROM
    Student S
WHERE
    S.GPA < 0.5;
    
/*item 29*/
INSERT INTO Person(Name,ID,Address,DOB)
	VALUES('Trevor Horns','000957303','23 Canberra Street','1964-11-23');
    
SELECT 
    *
FROM
    Person P
WHERE
    P.Name = 'Trevor Horns';
    
/*item 30*/
DELETE FROM Student 
WHERE
    StudentID = (SELECT 
        ID
    FROM
        Person
    
    WHERE
        'Jan Austin' = Name);
DELETE FROM Instructor 
WHERE
    InstructorID = (SELECT 
        ID
    FROM
        Person
    
    WHERE
        'Jan Austin' = Name);
DELETE FROM Person 
WHERE
    name = 'Jan Austin';
    
SELECT 
    *
FROM
    Person P
WHERE
    P.Name = 'Jan Austin';
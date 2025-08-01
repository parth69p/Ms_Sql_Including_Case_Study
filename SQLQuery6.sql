use CollegeDb;
--1.Which students are enrolled in which courses.
--2.Who is teaching each course ?
--3.There should be rules like minimum student age, unique email IDs.
--4. Allow only authorized users to make changes or view specific data.
--5. Procedure to get student info by ID

-- creating table
create table Student(
studentid int primary key,
FullName varchar(20) Not null,
Email varchar(20) Unique Not null,
Age int check(Age>=18)
);

select * from student;

create table Instructor(
InstructorID int primary key,
FullName varchar(30),
Email varchar(20) unique
);
-- Drop Table Cource
drop table enrollment;
drop table Cource;

Create Table Course(
CourseID INT PRIMARY KEY,
CourseName VARCHAR(100),
InstructorID INT,
Foreign KEY (InstructorID) References Instructor( InstructorID)
);


create table Enrollment(
EnrollmentId int Primary key,
StudentId int ,
CourceID int,
Enrollment Date Default getdate()
Foreign key( StudentId) references Student(StudentId),
Foreign key( CourceId) references Course(CourseId)
);

-- Inserting into above tables
Insert into Instructor values(1,'Dr. Smith','smith@gmail.comm');
Insert into Instructor values(2,'Prof. Rajesh','rajesh@gmail.com');
Insert into Cource values(101,'Data Science');
  SELECT name 
FROM sys.key_constraints 
WHERE parent_object_id = OBJECT_ID('Cource');

ALTER TABLE Cource DROP CONSTRAINT UQ__Cource__A9D10534E6ABC9C2;
ALTER TABLE Cource DROP COLUMN Email;
select * from Cource;

EXEC sp_rename 'Enrollment.Enrollment', 'EnrollmentDate', 'COLUMN';

insert into student values(1,'rohit','Rohit@ucla.uk',19);

insert into student values(2,'rashi','rashi@ucla.uk',20);

--inserting into Enrollment

insert into Enrollment values( 1001,1,101,GEtDATe());

-- Grand and Revoke
grant select on student to auditor;
grant select on Enrollment to auditor;

create user auditor;
-- for above to work we have to create login and user
create login auditor with password = 'strongPassword123';
create user auditor For login auditor;

Revoke select on student from auditor;
select * from student;
-- Implementing a transaction with commit and roll back
begin transaction;
insert into student values(3, 'Alex ', 'Alex@hwd.edu',20);
insert into Enrollment values(1003,2,101,GETDATE());
commit;

-- rollback
Begin transaction;
Insert into Student values(4,'Angel','Angel@gmail.com',20);
rollback;

select * from Student;
Select * from Enrollment;
select * from Course;
select * from Instructor;
--inserting into student
insert into Student values(4,'Parth' ,'Parth@gmail.com',20);
insert into Student values(5,'Tushar' ,'Tushar@gmail.com',20);

-- inserting into instructor first;
insert into Instructor values( 3,'Prof. Navneet','navneet@gmail.com');
-- inserting into cource
insert into Course values(101,'data science',1);
insert into Course values(102,'Computer Applications',3);
insert into Course values(103,'C# using .net',2);

-- insert into enrollment
insert into Enrollment values(1001, 1,101,GETDATE());
insert into Enrollment values(1002, 4,101,GETDATE());

insert into Enrollment values(1003,5,102,GETDATE());

-- which student enrolled in which cource
SELECT 
    s.FullName, 
    c.CourseName
FROM 
    Student s
Left JOIN 
    Enrollment e ON s.StudentId = e.StudentId
left JOIN 
    Course c ON e.CourceId = c.CourseID;

-- Who is teaching the each cource 

Select i.FullName , c.CourseName from Instructor i
join 
   Course c on i.InstructorID= c.InstructorID;


   -- Create Procedure to view Student data by id
create procedure GetStudentInfoById
@studentId int
as
begin
select * from Student where studentid= @studentId;
end;

execute GetStudentInfoById 4;
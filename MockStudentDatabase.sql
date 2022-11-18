CREATE DATABASE university;
USE university;

CREATE TABLE students (
	id INT NOT NULL AUTO_INCREMENT UNIQUE,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    gpa INT NOT NULL,
    PRIMARY KEY (id)
);
DROP TABLE students;

CREATE TABLE professors (
	id INT AUTO_INCREMENT NOT NULL UNIQUE,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    salary INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE courses (
	id INT AUTO_INCREMENT NOT NULL UNIQUE,
    title VARCHAR(255) NOT NULL,
    department VARCHAR(255) NOT NULL,
    credits INT NOT NULL,
    `description` BLOB,
    section INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE student_courses (
	registration_id INT AUTO_INCREMENT UNIQUE NOT NULL,
	numerical_grade INT,
    letter_grade VARCHAR(1),
    completed BOOLEAN,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    PRIMARY KEY (registration_id),
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);
DROP TABLE student_courses;
CREATE TABLE professor_courses (
	professor_course_id INT AUTO_INCREMENT UNIQUE NOT NULL,
	professor_id INT NOT NULL,
    course_id INT NOT NULL, 
    PRIMARY KEY (professor_course_id),
    FOREIGN KEY (professor_id) REFERENCES professors(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- Create user and give user privileges for data manipulation
CREATE USER 'data_manipulation' IDENTIFIED BY 'password';
GRANT SELECT, INSERT ON university.* TO 'data_manipulation';

-- Selecting all students currently registered for a course
-- Selecting from course with id of 5
SELECT * FROM student_courses WHERE course_id = 5 AND completed = FALSE;

-- Selecting the grade a specific student received in a course previously taken
-- In this case, student with id 2 and course with id 10
SELECT numerical_grade, letter_grade FROM student_courses WHERE course_id = 10 AND student_id = 2 AND completed = TRUE;

-- Adding a student to a course
-- In this case, adding student with id of 6 to course with id of 1, have no grade yet
INSERT INTO student_courses (numerical_grade, letter_grade, completed, student_id, course_id) VALUES (NULL, NULL, FALSE, 6, 1);

-- Dropping a student (student with id 3) from a course (course with id 2) with no W 
DELETE FROM student_courses WHERE student_id = 3 AND course_id = 4;

-- Dropping a student (student with id 10) from a course (course with id 4) with W
UPDATE student_courses SET letter_grade = 'W', completed = FALSE WHERE student_id = 10 AND course_id = 4;

--  Extra Credit: Selecting all the courses a student is taking from a certain professor
-- Student with id of 7, professor with id of 1
SELECT professor_courses.professor_id, student_courses.student_id, student_courses.course_id
FROM professor_courses
INNER JOIN student_courses
ON professor_courses.course_id = student_courses.course_id
WHERE student_courses.student_id = 7 AND professor_courses.professor_id = 1;


#1.	Create a database named project and employee, then import data_science_team.csv and proj_table.csv into the project 
#   database and emp_record_table.csv into the employee database from the given resources.

Create database project_and_employee;
use project_and_employee;

SELECT 
    *
FROM
    data_science_team;

#2.  Rename the ï»¿EMP_ID column name to emp_id for data_science_team, emp_record_table, and rename the ï»¿PROJ_ID column name to proj_id for proj_table.
#2.1
alter table data_science_team rename column ï»¿EMP_ID to emp_id; 
SELECT 
    *
FROM
    data_science_team;
#2.2
SELECT 
    *
FROM
    emp_record_table;
# renaming the the  ï»¿EMP_ID to emp_id
alter table emp_record_table rename column ï»¿EMP_ID to emp_id;
SELECT 
    *
FROM
    emp_record_table;
#2.3
SELECT 
    *
FROM
    proj_table;
# renaming the the  ï»¿PROJ_ID to proj_id
alter table proj_table rename column ï»¿PROJ_ID to proj_id;
SELECT 
    *
FROM
    proj_table;

# 3. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, 
#    and make a list of employees and details of their department.

SELECT 
    emp_id, first_name, last_name, Gender, Dept
FROM
    emp_record_table;


#4.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
#●	less than two
#●	greater than four 
#●	between two and four
SELECT 
    *
FROM
    emp_record_table;

SELECT 
    emp_id, first_name, last_name, Gender, Dept, emp_rating
FROM
    emp_record_table
WHERE
    emp_rating < 2;
SELECT 
    emp_id, first_name, last_name, Gender, Dept, emp_rating
FROM
    emp_record_table
WHERE
    emp_rating > 4;
SELECT 
    emp_id, first_name, last_name, Gender, Dept, emp_rating
FROM
    emp_record_table
WHERE
    emp_rating BETWEEN 2 AND 4; 

# 5.	Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table 
# and then give the resultant column alias as NAME.

SELECT 
    CONCAT(first_name, ' ', last_name) AS name
FROM
    emp_record_table
WHERE
    dept = 'FINANCE';

#6.	Write a query to list only those employees who have someone reporting to them. Also, show the number of reporters (include the President and the CEO of the organization).
SELECT 
    *
FROM
    emp_record_table;

SELECT 
    e.`MANAGER ID` AS ManagerID,
    CONCAT(m.FIRST_NAME, ' ', m.LAST_NAME) AS ManagerName,
    COUNT(e.EMP_ID) AS NumberOfReporters
FROM
    emp_record_table e
        JOIN
    emp_record_table m ON e.`MANAGER ID` = m.EMP_ID
GROUP BY e.`MANAGER ID` , m.FIRST_NAME , m.LAST_NAME
HAVING COUNT(e.EMP_ID) > 0;



#7.	Write a query to list down all the employees from the healthcare and finance domain using union. Take data from the employee record table

SELECT 
    emp_id, first_name, last_name, dept, Role
FROM
    emp_record_table
WHERE
    dept = 'healthcare' 
UNION SELECT 
    emp_id, first_name, last_name, dept, Role
FROM
    emp_record_table
WHERE
    dept = 'finance';


#8.	Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. 
# Also include the respective employee rating along with the max emp rating for the department.


SELECT 
    e.EMP_ID,
    e.FIRST_NAME,
    e.LAST_NAME,
    e.ROLE,
    e.DEPT AS Department,
    e.EMP_RATING,
    d.MaxRating
FROM 
    emp_record_table e
JOIN 
    (SELECT 
         DEPT, 
         MAX(EMP_RATING) AS MaxRating
     FROM 
         emp_record_table
     GROUP BY 
         DEPT) d
ON 
    e.DEPT = d.DEPT;

    
#9.	Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table
SELECT 
    role,
    MIN(salary) AS Minimum_salary,
    MAX(salary) AS Maximum_salary
FROM
    emp_record_table
GROUP BY role;


#10. Write a query to assign ranks to each employee based on their experience. Take data from the employee record table
SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    ROLE,
    DEPT,
    EXP,
    RANK() OVER (ORDER BY EXP DESC) AS RankByExperience
FROM 
    emp_record_table;
    
#11.	Write a query to create a view that displays employees in various countries whose salary is more than six thousand. Take data from the employee record table.

CREATE VIEW HighSalaryEmployees AS
    SELECT 
        emp_id, first_name, last_name, role, dept, exp, salary
    FROM
        emp_record_table
    WHERE
        salary > 6000;

SELECT 
    *
FROM
    HighSalaryEmployees;

#12.	Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.

SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EXP
FROM
    emp_record_table
WHERE
    EXP > (SELECT 
            MAX(EXP) - 10
        FROM
            emp_record_table);

#13. Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. Take data from the employee record table.
DELIMITER $$

CREATE PROCEDURE GetEmployeesWithExperience()
BEGIN
    SELECT 
        EMP_ID,
        FIRST_NAME,
        LAST_NAME,
        ROLE,
        DEPT,
        EXP
    FROM 
        emp_record_table
    WHERE 
        EXP > 3;
END$$

DELIMITER ;


CALL GetEmployeesWithExperience();


#14. Write a query using stored functions in the project table to check whether the job profile assigned to each
# employee in the data science team matches the organization’s set standard.

SELECT 
    *
FROM
    Proj_table;
SELECT 
    *
FROM
    data_science_team;

DELIMITER $$

CREATE FUNCTION ValidateJobProfile(exp INT, job_role VARCHAR(255)) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE expected_role VARCHAR(255);
    
    -- Determine the expected role based on experience
    IF exp <= 2 THEN
        SET expected_role = 'JUNIOR DATA SCIENTIST';
    ELSEIF exp > 2 AND exp <= 5 THEN
        SET expected_role = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF exp > 5 AND exp <= 10 THEN
        SET expected_role = 'SENIOR DATA SCIENTIST';
    ELSEIF exp > 10 AND exp <= 12 THEN
        SET expected_role = 'LEAD DATA SCIENTIST';
    ELSEIF exp > 12 AND exp <= 16 THEN
        SET expected_role = 'MANAGER';
    ELSE
        SET expected_role = NULL; -- No defined role
    END IF;

    -- Compare the expected role with the provided job_role
    RETURN expected_role = job_role;
END$$

DELIMITER ;
SELECT 
    ds.EMP_ID,
    ds.FIRST_NAME,
    ds.LAST_NAME,
    ds.ROLE AS AssignedRole,
    ds.EXP AS Experience,
    VALIDATEJOBPROFILE(ds.EXP, ds.ROLE) AS IsValidRole
FROM
    data_science_team ds;


#15.	Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating).
SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    ROLE,
    SALARY,
    EMP_RATING,
    (SALARY * 0.05 * EMP_RATING) AS Bonus
FROM 
    emp_record_table;

#16.	Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.
SELECT 
    CONTINENT,
    COUNTRY,
    AVG(SALARY) AS AvgSalary
FROM 
    emp_record_table
GROUP BY 
    CONTINENT, COUNTRY
ORDER BY 
    CONTINENT, COUNTRY;

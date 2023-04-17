//1.	Write a SQL query to remove the details of an employee whose first name ends in ‘even’
DELETE FROM employees WHERE first_name LIKE '%even';

//2.	Write a query in SQL to show the three minimum values of the salary from the table.
SELECT salary FROM employees ORDER BY salary LIMIT 3;

//3.	Write a SQL query to remove the employees table from the database
--drop table employees;

//4.	Write a SQL query to copy the details of this table into a new table with table name as Employee table and to delete the records in employees table
CREATE TABLE Employee_table AS SELECT * FROM employees;
TRUNCATE employees;
SELECT * FROM employee_table;

//5.	Write a SQL query to remove the column Age from the table
ALTER TABLE employees DROP Age;

//6.	Obtain the list of employees (their full name, email, hire_year) where they have joined the firm before 2000
SELECT concat(first_name,' ',last_name) AS full_name, email, year(hire_date) AS hire_year FROM employees where year(hire_date)<2000;

//7.	Fetch the employee_id and job_id of those employees whose start year lies in the range of 1990 and 1999
SELECT employee_id, job_id from employees where year(hire_date) BETWEEN 1990 AND 1999;

//8.	Find the first occurrence of the letter 'A' in each employees Email ID
--Return the employee_id, email id and the letter position
SELECT employee_id, email, charindex('A',email) AS letter_position from employees;

//9.	Fetch the list of employees(Employee_id, full name, email) whose full name holds characters less than 12
SELECT employee_id, concat(first_name,' ',last_name) AS full_name, email from employees where length(full_name)<12;

//10.	Create a unique string by hyphenating the first name, last name , and email of the employees to obtain a new field named UNQ_ID 
--Return the employee_id, and their corresponding UNQ_ID;
SELECT employee_id, concat(first_name,'-',last_name,'-',email) AS UNQ_ID from employees;

//11.	Write a SQL query to update the size of email column to 30
ALTER TABLE employees ALTER COLUMN email VARCHAR(30);

//12.	Fetch all employees with their first name , email , phone (without extension part) and extension (just the extension)  
-- Info : this mean you need to separate phone into 2 parts 
-- eg: 123.123.1234.12345 => 123.123.1234 and 12345 . first half in phone column and second half in extension column
SELECT first_name, phone_number, split_part(phone_number, '.', -1) AS extension, left(phone_number, charindex(extension, phone_number,1)-2) AS phone FROM employees;

//13.	Write a SQL query to find the employee with second and third maximum salary.
SELECT * FROM employees WHERE SALARY < (SELECT MAX(SALARY) FROM employees) ORDER BY SALARY DESC LIMIT 2;

//14.	  Fetch all details of top 3 highly paid employees who are in department Shipping and IT
SELECT * FROM employees WHERE department_id = 50 OR department_id = 60 ORDER BY salary DESC LIMIT 3;

//15.	  Display employee id and the positions(jobs) held by that employee (including the current position)
SELECT e.employee_id, e.job_id, j.job_title from employees e, jobs j where e.job_id=j.job_id UNION SELECT job_history.employee_id, job_history.job_id, j.job_title from jobs j, job_history where j.job_id=job_history.job_id ORDER BY employee_id;

//16.	Display Employee first name and date joined as WeekDay, Month Day, Year
-- Eg : 
-- Emp ID      Date Joined
-- 1	Monday, June 21st, 1999
SELECT first_name, concat(dayname(hire_date),', ',monthname(hire_date),' ',DAYOFMONTH(hire_date),', ',YEAR(hire_date)) AS DATE from employees;

//17.	The company holds a new job opening for Data Engineer (DT_ENGG) with a minimum salary of 12,000 and maximum salary of 30,000 .  
-- The job position might be removed based on market trends (so, save the changes) . 
--  - Later, update the maximum salary to 40,000 . 
-- - Save the entries as well.
-- -  Now, revert back the changes to the initial state, where the salary was 30,000
ALTER SESSION SET AUTOCOMMIT =false;
SELECT * FROM departments;
INSERT INTO jobs VALUES('DT_ENGG','Data Engineer', 12000, 30000);
COMMIT;
SELECT * FROM jobs;
UPDATE jobs SET max_salary=40000 WHERE job_id='DT_ENGG';
ROLLBACK;
ALTER SESSION SET AUTOCOMMIT = true;

//18.	Find the average salary of all the employees who got hired after 8th January 1996 but before 1st January 2000 and round the result to 3 decimals
SELECT round(avg(salary),3) AS average_salary FROM employees WHERE hire_date BETWEEN '09-JAN-1996' AND '31-DEC-1999';

//19.	 Display  Australia, Asia, Antarctica, Europe along with the regions in the region table (Note: Do not insert data into the table)
-- A. Display all the regions
-- B. Display all the unique regions
SELECT region_name FROM regions UNION ALL SELECT 'Australia' UNION ALL SELECT 'Australia' UNION ALL SELECT 'Asia' UNION ALL SELECT 'Antartica' UNION ALL SELECT 'Europe';
SELECT region_name FROM regions UNION SELECT 'Australia' UNION SELECT 'Australia' UNION SELECT 'Asia' UNION SELECT 'Antartica' UNION SELECT 'Europe';




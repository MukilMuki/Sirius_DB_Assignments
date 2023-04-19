-- 1.	 Write a SQL query to find the total salary of employees who is in Tokyo excluding whose first name is Nancy
SELECT sum(e.salary) AS total_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
WHERE l.city = 'Seattle' AND e.first_name != 'Nancy';

-- 2.	 Fetch all details of employees who has salary more than the avg salary by each department.
SELECT e.* FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > (
  SELECT avg(salary) FROM employees WHERE department_id = e.department_id
)
ORDER BY d.department_id;


-- 3.	Write a SQL query to find the number of employees and its location whose salary is greater than or equal to 7000 and less than 10000
SELECT count(e.employee_id) As total_employees,l.state_province FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
WHERE e.salary BETWEEN 7000 AND 9999
GROUP BY l.state_province;

-- 4.	Fetch max salary, min salary and avg salary by job and department. 
SELECT department_id,jobs.job_id,job_title,max(salary) AS maximum_salary, min(salary) AS minimum_salary, avg(salary) AS average_salary FROM jobs 
INNER JOIN employees ON jobs.job_id=employees.job_id GROUP BY department_id,jobs.job_id,job_title ORDER BY department_id,maximum_salary;
--  Info:  grouped by department id and job id ordered by department id and max salary

-- 5.	Write a SQL query to find the total salary of employees whose country_id is ‘Us’ excluding whose first name is Nancy  
SELECT sum(salary) FROM employees 
JOIN departments ON employees.department_id=departments.department_id
JOIN locations ON locations.location_id=departments.location_id 
WHERE first_name!='Nancy' AND country_id='US';

-- 6.	Fetch max salary, min salary and avg salary by job id and department id but only for folks who worked in more than one role(job) in a department.
SELECT em.employee_id, job_id, department_id, max(salary) AS maximum_salary, min(em.salary) AS minimum_salary, avg(salary) AS average_salary FROM employees em
JOIN (
    SELECT employee_id, count(employee_id) AS Job_Count FROM job_history
    GROUP BY department_id,employee_id HAVING Job_Count > 1
    ) AS e 
ON e.employee_id = em.employee_id 
GROUP BY job_id,department_id,em.employee_id 
ORDER BY department_id;

-- 7.	Display the employee count in each department and also in the same result.  
-- Info: * the total employee count categorized as "Total"
-- •	the null department count categorized as "-" *
SELECT count(employee_id), coalesce(department_id,'0') AS department_id FROM employees GROUP BY department_id ORDER BY department_id;

-- 8.	Display the jobs held and the employee count. 
-- Hint: every employee is part of at least 1 job 
-- Hint: use the previous questions answer
-- sample
-- JobsHeld EmpCount
-- 1	100
-- 2	4
SELECT num_jobs, count(*) AS num_employees
FROM (
    SELECT e.employee_id, count(DISTINCT jh.job_id) AS num_jobs FROM employees e
    LEFT JOIN job_history jh ON e.employee_id = jh.employee_id
    GROUP BY e.employee_id
)
GROUP BY num_jobs;


-- 9.	 Display average salary by department and country
SELECT department_name, c.country_name, avg(salary) FROM employees e
JOIN departments d ON e.department_id=d.department_id
JOIN locations l ON l.location_id=d.location_id
JOIN countries c ON c.country_id=l.country_id
GROUP BY department_name, c.country_name
ORDER BY department_name;

-- 10.	Display manager names and the number of employees reporting to them by countries (each employee works for only one department, and each department belongs to a country)
SELECT d.manager_id, l.country_id, count(*) AS num_employees FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
GROUP BY d.manager_id, l.country_id
ORDER BY d.manager_id;

-- 11.	 Group salaries of employees in 4 buckets eg: 0-10000, 10000-20000,.. (Like the previous question) but now group by department and categorize it like below.
-- Eg : 
-- DEPT id 0-10000 10000-20000
-- 50          2               10
-- 60          6                5
SELECT department_id AS "Dept Id",
       SUM(CASE WHEN salary BETWEEN 0 AND 10000 THEN 1 ELSE 0 END) AS "0-10000",
       SUM(CASE WHEN salary BETWEEN 10000 AND 20000 THEN 1 ELSE 0 END) AS "10000-20000",
       SUM(CASE WHEN salary BETWEEN 20000 AND 30000 THEN 1 ELSE 0 END) AS "20000-30000",
       SUM(CASE WHEN salary > 30000 THEN 1 ELSE 0 END) AS ">30000"
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- 12.	 Display employee count by country and the avg salary 
-- Eg : 
-- Emp Count       Country        Avg salary
-- 10                     Germany      34242.8
SELECT avg(salary), count(employee_id), c.country_name FROM employees e
JOIN departments d ON e.department_id=d.department_id
JOIN locations l ON l.location_id=d.location_id
JOIN countries c ON c.country_id=l.country_id
GROUP BY c.country_name;

-- 13.	 Display region and the number off employees by department
-- Eg : 
-- Dept id   America   Europe  Asia
-- 10            22               -            -
-- 40             -                 34         -
-- (Please put "-" instead of leaving it NULL or Empty)
SELECT r.region_name,d.department_id, count(employee_id) AS num_employees FROM employees e
JOIN departments d ON e.department_id=d.department_id
JOIN locations l ON l.location_id=d.location_id
JOIN countries c ON c.country_id=l.country_id
JOIN regions r ON r.region_id=c.region_id
GROUP BY r.region_name, d.department_id
ORDER BY d.department_id;

-- 14.	 select the list of all employees who work either for one or more departments or have not yet joined / allocated to any department
SELECT * FROM employees 
LEFT JOIN departments ON employees.department_id= departments.department_id 
ORDER BY employee_id;

-- 15.	write a SQL query to find the employees and their respective managers. Return the first name, last name of the employees and their managers
SELECT first_name, last_name, department_name,employees.manager_id FROM employees,departments 
WHERE departments.manager_id=employees.manager_id ORDER BY manager_id;

-- 16.	write a SQL query to display the department name, city, and state province for each department.
SELECT departments.department_id,department_name, city, state_province FROM departments, locations 
WHERE departments.location_id=locations.location_id;

-- 17.	write a SQL query to list the employees (first_name , last_name, department_name) who belong to a department or don't
SELECT first_name, last_name, department_name FROM employees 
LEFT JOIN departments ON employees.department_id=departments.department_id 
ORDER BY departments.department_name;

-- 18.	The HR decides to make an analysis of the employees working in every department. Help him to determine the salary given in average per department and the total number of employees working in a department.  List the above along with the department id, department name
SELECT d.department_id, d.department_name, AVG(e.salary) AS average_salary, COUNT(e.employee_id) AS total_employees FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name
ORDER BY d.department_id;

-- 19.	Write a SQL query to combine each row of the employees with each row of the jobs to obtain a consolidated results. (i.e.) Obtain every possible combination of rows from the employees and the jobs relation.
SELECT * FROM EMPLOYEES CROSS JOIN JOBS;

-- 20.	 Write a query to display first_name, last_name, and email of employees who are from Europe and Asia
SELECT first_name, last_name, email FROM employees e 
JOIN departments d on e.department_id = d.department_id 
JOIN locations l on d.location_id=l.location_id 
JOIN countries c ON l.country_id=c.country_id 
JOIN regions r ON c.region_id=r.region_id 
WHERE r.region_name IN ('Europe','Asia');

-- 21.	 Write a query to display full name with alias as FULL_NAME (Eg: first_name = 'John' and last_name='Henry' - full_name = "John Henry") who are from oxford city and their second last character of their last name is 'e' and are not from finance and shipping department.
SELECT concat(first_name, ' ', last_name) AS FULL_NAME FROM employees e 
JOIN departments d ON d.department_id=e.department_id 
JOIN locations l ON l.location_id=d.location_id 
WHERE l.city='Oxford' AND last_name LIKE '%e_' AND department_name NOT IN ('Finance','Shipping');

-- 22.	 Display the first name and phone number of employees who have less than 50 months of experience
SELECT first_name, phone_number FROM employees
WHERE months_between(sysdate(), hire_date) < 50;

-- 23.	 Display Employee id, first_name, last name, hire_date and salary for employees who has the highest salary for each hiring year. (For eg: John and Deepika joined on year 2023,  and john has a salary of 5000, and Deepika has a salary of 6500. Output should show Deepika’s details only).
SELECT e.employee_id, e.first_name, e.last_name, e.hire_date, e.salary FROM employees e
JOIN (
    SELECT year(hire_date) AS hire_year, MAX(salary) AS max_salary FROM employees
    GROUP BY year(hire_date)
) AS max_salary_year
ON year(e.hire_date) = max_salary_year.hire_year AND e.salary = max_salary_year.max_salary;


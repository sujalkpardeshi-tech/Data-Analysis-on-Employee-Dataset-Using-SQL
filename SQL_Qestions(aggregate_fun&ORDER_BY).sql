CREATE TABLE employee (
     empid INT,
	 emp_name VARCHAR(255),
	 age INT,
	 salary DECIMAL(10,2),
	 department VARCHAR(50)
);

SELECT * FROM employee;
INSERT INTO employee( empid , emp_name , age , salary , department)
VALUES (
--Directly imported .csv file

--LEVEL 1: BASIC (foundation)
--1) Get all employess sorted by salary (low - high)
SELECT * FROM employee
ORDER BY salary ASC;

--2) Get all employee sorted by age (high - low)
SELECT * FROM employee
ORDER BY salary DESC;

--3) show employee names and salaries sorted alphabetically by name
SELECT * FROM employee
ORDER BY emp_name , salary ASC;

--4) Get top 5 highest paid employees
SELECT * FROM employee
ORDER BY salary DESC
LIMIT 5;

--5) Get bottom 3 lowset salary employee
SELECT * FROM employee
ORDER BY salary ASC
LIMIT 3;

--6) Count total number of employee
SELECT COUNT(*) FROM employee;

--7) Find the maximum salary in company
SELECT MAX(salary) AS max_salary FROM employee;

--8)Find minimum age of employees
SELECT MIN(salary) AS min_salary FROM employee;

--9) Find avg salary of employees
SELECT AVG(salary) AS avg_salary FROM employee;

--10) Get total salary payout of company
SELECT SUM(salary) AS total_salary FROM employee;

--LEVEL 2:Intermediate
--11) Get department wise total salary
SELECT department , SUM(salary) AS total_salary FROM employee
GROUP BY department;

--12) Find avg salary per department 
SELECT department , AVG(salary) AS avg_salary FROM employee
GROUP BY department;

--13) Count num of employees in each department 
SELECT department , COUNT(*) AS num_employee FROM employee
GROUP BY department;

--14) Show department sorted by highest avg salary
SELECT department , AVG(salary) AS avg_salary FROM employee
GROUP BY department 
ORDER BY avg_salary DESC;

--15) Get highest salary in each department 
SELECT department , MAX(salary) AS max_salary FROM employee
GROUP BY department;

--16) Get lowest salary in each department 
SELECT department , MIN(salary) AS min_salary FROM employee
GROUP BY department;

--17) find departments where avg salary > 50,000
SELECT department , AVG(salary) AS avg_salary FROM employee
GROUP BY department 
HAVING AVG(salary)> 50000;

SELECT * FROM employee;

--18) Display departments with more than 3 employees
SELECT department , COUNT(*) AS emp FROM employee
GROUP BY department
HAVING COUNT(*) > 3;

--19) Show employees sorted by department , then salary DESC
SELECT * FROM employee
ORDER BY department ASC, salary DESC;

--20) Get 2nd highest salary
SELECT MAX(salary) AS second_highest FROM employee
WHERE salary < (SELECT MAX(salary) FROM employee);

SELECT salary 
FROM  ( 
       SELECT salary , DENSE_RANK() OVER(ORDER BY salary DESC) AS rnk FROM employee)
t
WHERE rnk=2;

--LEVEL 3: ADVANCED (interview fav)
--21) Find top 3 highest salaries in each department
SELECT department , MAX(salary) AS highest_salary FROM employee
GROUP BY department 
ORDER BY highest_salary DESC
LIMIT 3;

--22) Find employees who earn more than avg salary of their department 
SELECT * FROM employee e
WHERE salary > (
      SELECT AVG(salary) AS avg_salary FROM employee
	  WHERE department = e.department );

--23) display departments ordered by total salary expenditure (highest first)
SELECT department , SUM(salary) AS total_salary FROM employee
GROUP BY department 
ORDER BY total_salary DESC;

--24) Find department with highest total salary
SELECT department , SUM(salary) AS total_salary FROM employee
GROUP BY department 
ORDER BY total_salary DESC
LIMIT 1;

--25) Find employees  with max salary in each department 
SELECT * FROM employee e
WHERE salary = (
      SELECT MAX(salary) FROM employee
	  WHERE department = e.department 
	  );

--26) Find employees whose salary is equal to minimum salary in their department
SELECT * FROM employee e 
WHERE salary = (
      SELECT MIN(salary) FROM employee
	  WHERE department = e.department 
	  );

--27) Find department where max salary >2x min salary 	  
SELECT department 
FROM employee
GROUP BY department 
HAVING MAX(salary) > 2* MIN(salary);

--
SELECT * FROM employee;
--

--28) show employees ranked by salary within each department 
SELECT empid , emp_name , department , salary, 
       RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS rank_in_dept
FROM employee;	   

--29)Get nth highest salary (dynamic)
SELECT salary
FROM (
      SELECT salary , 
	         DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
      FROM employee
	  )t
WHERE rnk = n;	  

--30)Find employees whose salary is above overall avg salary
SELECT * FROM employee
WHERE salary > (
      SELECT AVG(salary) AS avg_salary FROM employee);

--LEVEL 4: Hard/Real Interview Qestions
--31) Find second highest salary in each department
SELECT *
FROM (
      SELECT *,
	         DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS rnk FROM employee) t
	  WHERE rnk = 2;		 

--32) Get top 2 earnes from each department (use DENSE_RANK)
SELECT *
FROM (
      SELECT *,
	         DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS rnk
      FROM employee
)t
WHERE rnk <= 2;

--33) Find department where total salary is greater than company avg salary
SELECT department , SUM(salary) AS total_salary FROM employee 
GROUP BY department
HAVING SUM(salary)> (
      SELECT AVG(salary) AS avg_salary FROM employee); 
	  
--34) show employees whose salary is in top 10% of company 
SELECT * FROM
(   
   SELECT *, 
            PERCENT_RANK() OVER(ORDER BY salary) AS pr
   FROM employee
   )t
WHERE pr >= 0.9;   

--
SELECT * FROM employee;
--

--35) Find salary distribution (how many employees fall in salary ranges like 30k-60k , 60k-90k)
SELECT 
      CASE 
	      WHEN salary >= 60000 AND salary < 90000 THEN '60k-90k'
		  WHEN salary >= 30000 AND salary < 60000 THEN '30k-60k'
		  ELSE '0-30k'
		  END AS salary_range,
		  COUNT(*) AS employee_count
FROM employee
GROUP BY salary_range
ORDER BY salary_range;
	  
--36)Get running total of salary ordered by empid (cumulative sum of each row)
SELECT 
      empid,
	  emp_name,
	  salary,
	  SUM(salary) OVER(ORDER BY empid) AS running_total
FROM employee;	  
	  
--37)Find difference between highest and lowest salary per department 
SELECT 
      department,
	  MAX(salary) - MIN(salary) AS salary_difference
FROM employee
GROUP BY department;

--38) Find employees who have same salary as someone else(duplicate)
SELECT * 
FROM employee
WHERE salary IN (
      SELECT salary
	  FROM employee
	  GROUP BY salary
	  HAVING COUNT(*)>1
	  );

--39)Sort employees by salary, but show highest salary first in each department (partition logic)
SELECT empid, emp_name , department , salary,
RANK() OVER(
 PARTITION BY department ORDER BY salary DESC) AS sort_emp
 FROM employee;
 
--40)  Find employees  with max salary in each department 
SELECT * FROM employee e
WHERE salary = (
      SELECT MAX(salary) FROM employee
	  WHERE department = e.department 
	  );

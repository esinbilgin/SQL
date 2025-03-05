SHOW DATABASES; 
USE Company;
SHOW TABLES;  --SHOWS ALL TABLE BELONGS TO SELECTED DATABASE

-- 1. RETRIEVE ALL EMPLOYEES
SELECT*
FROM employee;

-- 2. FIND EMPLOYEES WITH FIRST NAME "MICHAEL"
SELECT*
FROM employee
WHERE first_name = 'Michael';

-- 3. GET EMPLOYEES WITH SALARY GREATER THAN 70,000
SELECT*
FROM employee
WHERE salary > 70000;

-- 4. RETRIEVE ALL FEMALE EMPLOYEES
SELECT*
FROM employee
WHERE sex = 'F';

-- 5. FIND EMPLOYEES BORN BEFORE 1970
SELECT*
FROM employee
WHERE birth_day < '1970-01-01';

-- 6. COUNT DISTINCT BRANCHES (remove duplicate values for branch_id)
SELECT DISTINCT branch_id FROM employee;

-- 7. LIST EMPLOYEES ORDERED BY SALARY (DESCENDING)
SELECT*
FROM employee
ORDER BY salary DESC;

-- 8. FIND THE HIGHEST-PAID EMPLOYEE
SELECT*
FROM employee
ORDER BY salary DESC
LIMIT 1;   

        --WHAT IF THERE IS DUPLICATE VALUES WERE IN THE TABLE ? 

        SELECT MAX(salary) AS MaxSalary
        FROM employee; -- NO EMPLOYEE DETAILS   

        SELECT*
        FROM employee -- WITH EMPLOYEE DETAILS  
        WHERE salary = (SELECT MAX(salary) FROM employee);

-- 9. COUNT TOTAL NUMBER OF EMPLOYEES
SELECT COUNT(emp_id)
FROM employee;

-- 10. CALCULATE TOTAL SALARY BUDGET
SELECT SUM(salary) AS budget
FROM employee;

-- 11. FIND AVERAGE SALARY
SELECT ROUND(AVG(salary), 2) AS AvgSalary
FROM employee;

-- 12. COUNT EMPLOYEES IN EACH BRANCH
SELECT branch_id, COUNT(branch_id)
FROM employee
GROUP BY branch_id;

-- 13. FIND BRANCHES WITH AT LEAST 2 EMPLOYEES
DESCRIBE employee;

SELECT branch_id, COUNT(*) AS total_employees
FROM employee
GROUP BY branch_id
HAVING COUNT(*) > 2;

-- 14. FIND EMPLOYEE WITH HIGHEST TOTAL SALES
SELECT TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'total_sales'; --TO FIND where total_sales column stored

SELECT emp_id, SUM(total_sales) AS highest_total_sales
FROM works_with
GROUP BY emp_id
ORDER BY highest_total_sales DESC;

-- 15. EMPLOYEES WITH TOTAL SALES OF AT LEAST 100,000
SELECT emp_id, SUM(total_sales) AS highest_total_sales
FROM works_with
GROUP BY emp_id
HAVING highest_total_sales > 100000
ORDER BY highest_total_sales DESC;

-- 16. CATEGORIZE EMPLOYEES BASED ON SALARY
SELECT emp_id, first_name, last_name, salary,
    CASE
        WHEN salary > 100000 THEN 'High'
        WHEN salary BETWEEN 70000 AND 100000 THEN 'Medium'
        WHEN salary < 70000 THEN 'Low'
    END AS Salary_level
FROM employee
ORDER BY salary DESC;

-- 17. FIND THE EMPLOYEE WITH THE LOWEST SALARY
SELECT*
FROM employee
WHERE salary = (SELECT MIN(salary) FROM employee);

-- 18. FIND THE HIGHEST SALARY IN EACH BRANCH
SELECT branch_id, MAX(salary) AS highest_salary
FROM employee
GROUP BY branch_id
ORDER BY highest_salary DESC;


-- 19. FIND BRANCHES WITH MORE THAN 3 EMPLOYEES
SELECT branch_id, COUNT(branch_id)
FROM employee
GROUP BY branch_id
HAVING COUNT(branch_id) > 3;

-- 20. SHOW DIFFERENT BRANCH ID
SELECT DISTINCT branch_id
FROM employee;

-- 21. FIND ALL EMPLOYEES WHOSE FIRST NAME STARTS WITH 'M'
SELECT*
FROM employee
WHERE first_name LIKE 'M%';

-- 22. FIND ALL EMPLOYEES WHOSE LAST NAME CONTAINS 'ON' ANYWHERE
SELECT*
FROM employee
WHERE last_name LIKE '%ON';

-- 23. FIND ALL EMPLOYEES WHOSE FIRST NAME HAS EXACTLY 5 LETTERS
SELECT*
FROM employee
WHERE first_name LIKE '_____';         -- WHERE LENGTH(first_name) = 5;

-- 24. FIND ALL EMPLOYEES WHOSE LAST NAME ENDS WITH 'N'
SELECT*
FROM employee
WHERE last_name LIKE '%N';

-- 25. FIND ALL EMPLOYEES WHOSE FIRST NAME STARTS WITH 'J' AND ENDS WITH 'E'
SELECT*
FROM employee
WHERE first_name LIKE 'J%N';

-- 26. RETRIEVE A LIST OF ALL EMPLOYEE FIRST NAMES AND ALL BRANCH NAMES IN A SINGLE COLUMN
SELECT first_name
FROM employee
UNION
SELECT branch_name
FROM branch;

-- 27. FIND ALL EMPLOYEE IDs AND ALL CLIENT IDs IN A SINGLE COLUMN, WITHOUT DUPLICATES
SELECT emp_id
FROM employee
UNION
SELECT client_id
FROM client;

-- 28. RETRIEVE ALL EMPLOYEES FROM THE SCRANTON BRANCH AND ALL EMPLOYEES FROM THE STAMFORD BRANCH IN A SINGLE LIST
SELECT emp_id
FROM employee
WHERE branch_id = 2
UNION ALL
SELECT emp_id
FROM employee
WHERE branch_id = 3;

-- 29. RETRIEVE THE TOP 5 HIGHEST-PAID EMPLOYEES AND THE TOP 5 LOWEST-PAID EMPLOYEES IN A SINGLE LIST

(SELECT emp_id, first_name, last_name, salary
FROM employee
ORDER BY salary DESC
LIMIT 5)
UNION ALL
(SELECT emp_id, first_name, last_name, salary
FROM employee
ORDER BY salary ASC
LIMIT 5);

-- 30. RETRIEVE THE NAMES OF ALL EMPLOYEES AND CLIENTS IN A SINGLE LIST, SORTED ALPHABETICALLY
SELECT first_name AS name
FROM employee
UNION ALL
SELECT client_name
FROM client
ORDER BY name ASC;

-- 38. RETRIEVE EMPLOYEE AND CLIENT NAMES IN A SINGLE LIST, BUT DISPLAY THEM IN UPPERCASE
SELECT UPPER(first_name) 
FROM employee
UNION ALL
SELECT UPPER(client_name)
FROM client;

-- 39. COUNT THE TOTAL NUMBER OF RECORDS FROM A UNION QUERY THAT COMBINES EMPLOYEES AND CLIENTS
SELECT COUNT(*) AS total 
FROM 
(SELECT(first_name) 
FROM employee
UNION ALL
SELECT UPPER(client_name)
FROM client)
AS total;

-- CHALLANGE EXTERNAL: RETRIEVE ALL EMPLOYEE AND CLIENT EMAIL ADDRESSES, ADDING '@company.com' TO EACH EMAIL
SELECT LOWER(CONCAT(email, '@company.com')) AS company_email
FROM employee
UNION ALL
SELECT LOWER(CONCAT(client_email, '@company.com'))
FROM client;

--IF TWO DOMAINS
SELECT 
    CASE 
        WHEN email IS NOT NULL THEN LOWER(CONCAT(email, '@company.com')) 
        ELSE 'no-email@company.com' 
    END AS company_email
FROM employee
UNION ALL
SELECT 
    CASE 
        WHEN client_email IS NOT NULL THEN LOWER(CONCAT(client_email, '@client.com')) 
        ELSE 'no-email@client.com' 
    END 
FROM client;

-- FIND ALL BRANCHES AND THE NAMES OF THEIR MANAGERS (inner join based on shared column)
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
JOIN branch
ON employee.emp_id = branch.mgr_id;

-- LEFT JOIN (ALL ROWS FROM LEFT TABLE)
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
LEFT JOIN branch
ON employee.emp_id = branch.mgr_id;

-- RIGHT JOIN (ALL ROWS FROM RIGHT TABLE)
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
RIGHT JOIN branch
ON employee.emp_id = branch.mgr_id;

-- FULL OUTER JOIN = RIGHT AND LEFT ALL 

-- FIND NAMES OF ALL EMPLOYEES WHO HAVE SOLD OVER 50.000 TO A SINGLE CLIENT
SELECT emp_id 
FROM works_with 
WHERE total_sales > 50000;

-- FIND NAMES OF ALL EMPLOYEES WHO HAVE SOLD OVER 50,000 TO A SINGLE CLIENT
SELECT e.first_name, e.last_name
FROM employee e
JOIN works_with w ON e.emp_id = w.emp_id
WHERE w.total_sales > 50000;

-- FIND ALL CLIENTS WHO ARE SERVED BY EMPLOYEES FROM THE SCRANTON BRANCH
SELECT DISTINCT client_name
FROM client
JOIN works_with
ON works_with.client_id = client.client_id
JOIN employee
ON works_with.emp_id = employee.emp_id
WHERE employee.branch_id = (SELECT branch_id FROM branch WHERE branch_name = 'Scranton');

-- Find all clients who are handled by the branch
-- that Michael Scott manages
-- Assume you know Michael's
SELECT client.client_name
FROM client
WHERE client.branch_id = (
    SELECT branch.branch_id
    FROM branch 
    WHERE branch.mgr_id = 102
    );

SELECT c.client_name
FROM client c
JOIN branch b ON c.branch_id = b.branch_id
WHERE b.mgr_id = 102;

-- TRIGGERS 
/*
Bu yapı, bir SQL TRIGGER oluşturmak için kullanılır.
TRIGGER, belirli bir işlem (INSERT, UPDATE, DELETE) gerçekleştiğinde otomatik olarak çalışır.

CREATE TRIGGER trigger_adi
{BEFORE | AFTER} {INSERT | UPDATE | DELETE}
ON tablo_adi
FOR EACH ROW
BEGIN
    -- Yapılacak işlemler
END;*/




CREATE DATABASE IF NOT EXISTS Company;
USE Company;

DESCRIBE employee;
DROP TABLE employee;
SHOW TABLES;
SHOW COLUMNS FROM employee;

CREATE TABLE employee (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(40),
    last_name VARCHAR(40),
    birth_day DATE,
    sex VARCHAR(1),
    salary INT,
    super_id INT,
    branch_id INT
) AUTO_INCREMENT = 100;

--ALTER TABLE employee MODIFY emp_id INT AUTO_INCREMENT PRIMARY KEY;
--ALTER TABLE employee AUTO_INCREMENT = 100;
--ALTER TABLE Employee RENAME employee; 
--IF WE NEEDED

ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

DESCRIBE branch;

CREATE TABLE branch (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(20),
    mgr_id INT,
    mgr_start_date DATE,
    FOREIGN KEY (mgr_id) REFERENCES Employee(emp_id) ON DELETE SET NULL
);

DESCRIBE client;

CREATE TABLE client (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    client_name VARCHAR(40),
    branch_id INT,
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
) AUTO_INCREMENT = 400;


DESCRIBE works_with;

CREATE TABLE works_with (
    emp_id INT,
    client_id INT,
    total_sales INT,
    PRIMARY KEY(emp_id, client_id),
);

ALTER TABLE works_with 
ADD CONSTRAINT fk_emp_id
FOREIGN KEY (emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE;

ALTER TABLE works_with 
ADD CONSTRAINT fk_client_id
FOREIGN KEY (client_id) REFERENCES client(client_id) ON DELETE CASCADE;

SHOW TABLE STATUS WHERE Name = 'works_with';
SHOW CREATE TABLE works_with;

DESCRIBE branch_supplier;

CREATE TABLE branch_supplier (
    branch_id INT,
    supplier_name VARCHAR(40),
    supply_type VARCHAR(40),
    PRIMARY KEY(branch_id, supplier_name),
    Foreign KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);

INSERT INTO employee (first_name, last_name, birth_day, sex, salary, super_id, branch_id)
VALUES 
('David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL),
('Michael', 'Scott', '1964-03-15', 'M', 75000, NULL, NULL),
('Josh', 'Porter', '1969-09-05', 'M', 78000, NULL, NULL),
('Jan', 'Levinson', '1961-05-11', 'F', 110000, NULL, NULL),
('Angela', 'Martin', '1971-06-25', 'F', 63000, NULL, NULL),
('Kelly', 'Kapoor', '1980-02-05', 'F', 55000, NULL, NULL),
('Stanley', 'Hudson', '1958-02-19', 'M', 69000, NULL, NULL),
('Andy', 'Bernard', '1973-07-22', 'M', 65000, NULL, NULL),
('Jim', 'Halpert', '1978-10-01', 'M', 71000, NULL, NULL);



SELECT*
FROM employee;


SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM employee;
ALTER TABLE employee AUTO_INCREMENT = 100;
SET FOREIGN_KEY_CHECKS = 1;


-- Corporate 
INSERT INTO branch VALUES (1, 'Corporate', 100, '2006-02-09');

UPDATE employee 
SET branch_id = 1 
WHERE emp_id = 100;

-- Scranton 

INSERT INTO branch VALUES (2, 'Scranton', 101, '1992-04-06');
DELETE FROM branch WHERE branch_id = 2;
INSERT INTO branch VALUES (2, 'Scranton', 102, '1992-04-06');

UPDATE employee 
SET branch_id = 2 
WHERE emp_id = 102;

-- Stamford

INSERT INTO branch VALUES (3, 'Stamford', 106, '1998-02-13');

UPDATE employee 
SET branch_id = 3 
WHERE emp_id = 106;

UPDATE employee SET branch_id = 1 WHERE emp_id IN (100, 101);  -- David ve Jan -> Corporate
UPDATE employee SET branch_id = 2 WHERE emp_id IN (102, 103, 104, 105);  -- Michael ve ekibi -> Scranton
UPDATE employee SET branch_id = 3 WHERE emp_id IN (106, 107, 108);  -- Josh ve ekibi -> Stamford

UPDATE employee SET super_id = NULL WHERE emp_id = 100;  -- David Wallace, en üst düzey yöneticidir.
UPDATE employee SET super_id = 100 WHERE emp_id = 101;  -- Jan Levinson, David Wallace'a bağlıdır.
UPDATE employee SET super_id = 100 WHERE emp_id = 102;  -- Michael Scott, David Wallace'a bağlıdır.
UPDATE employee SET super_id = 102 WHERE emp_id IN (103, 104, 105);  -- Angela, Kelly, Stanley -> Michael Scott'a bağlıdır.
UPDATE employee SET super_id = 100 WHERE emp_id = 106;  -- Josh Porter, David Wallace'a bağlıdır.
UPDATE employee SET super_id = 106 WHERE emp_id IN (107, 108);  -- Andy ve Jim, Josh Porter'a bağlıdır.

SELECT*
FROM client;

INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);

INSERT INTO client(client_id, client_name, branch_id) 
VALUES
(403, 'John Daly Law, LLC', 3),
(404, 'Scranton Whitepages', 2),
(405, 'Times Newspaper', 3),
(406, 'FedEx', 2);

SELECT*
FROM branch_supplier;

INSERT INTO branch_supplier(branch_id, supplier_name, supply_type) 
VALUES
(2, 'Hammer Mill', 'Paper'),
(2, 'Uni-ball', 'Writing Utensils'),
(3, 'Patriot Paper', 'Paper'),
(2, 'J.T. Forms & Labels', 'Custom Forms'),
(3, 'Uni-ball', 'Writing Utensils'),
(3, 'Hammer Mill', 'Paper'),
(3, 'Stamford Labels', 'Custom Forms');

SELECT*
FROM works_with;

INSERT INTO works_with (emp_id, client_id, total_sales)
VALUES 
(105, 400, 55000),
(102, 401, 267000),
(108, 402, 22500),
(107, 403, 5000),
(108, 403, 12000),
(105, 404, 33000),
(107, 405, 26000),
(102, 406, 15000),
(105, 406, 130000);


SELECT COUNT(*) AS total_tables --NUMBER OF TABLE 
FROM information_schema.tables 
WHERE table_schema = 'company';

INSERT INTO branch VALUES (4, 'Buffalo', NULL, NULL);
SELECT*
FROM Branch;

CREATE TABLE trigger_test (
    message VARCHAR(100)
)

DELIMITER $$
CREATE my_trigger BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
        INSERT INTO trigger_test VALUES('added new employee');
    END $$
DELIMETER;
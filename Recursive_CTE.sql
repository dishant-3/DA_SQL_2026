USE sample1;
---- Create Employee table
--CREATE TABLE Employee (
--    emp_id INT PRIMARY KEY,
--    name VARCHAR(100) NOT NULL,
--    man_id INT NULL
--);

---- Insert sample data
--INSERT INTO Employee (emp_id, name, man_id)
--VALUES
--(1, 'Alice', 6),   -- reports to CTO
--(2, 'Bob',   1),   -- reports to Alice
--(3, 'Charlie', 1), -- reports to Alice
--(4, 'David',  2),  -- reports to Bob
--(5, 'Eva',    3),  -- reports to Charlie
--(6, 'CTO',   NULL); -- top boss, no manager


SELECT * FROM Employee;

WITH emphierarchy AS
(
SELECT e.emp_id,e.name AS emp_name,COALESCE(m.name,'Unavailable') AS manager_name
FROM Employee AS e
INNER Join
Employee AS m
ON e.man_id = m.emp_id 
where e.man_id IS NULL

UNION ALL
SELECT e.emp_id,e.name AS emp_name,COALESCE(m.name,'Unavailable') AS manager_name
FROM Employee AS e
INNER Join
emphierarchy AS h
ON e.man_id = h.emp_id
INNER JOIN
Employee AS m
ON e.man_id = m.emp_id
)
SELECT emp_id, emp_name, manager_name
FROM emphierarchy;
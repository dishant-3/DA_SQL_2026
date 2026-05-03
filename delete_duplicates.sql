use sample1;

--CREATE TABLE cust1 (
--    id INT,
--    name VARCHAR(15),
--    email VARCHAR(40),
--    contact_no INT
--);
---- Insert values into cust1
--INSERT INTO cust1 (id, name, email, contact_no)
--VALUES
--(1, 'Harry', 'har@gmail.com', 889900),
--(1, 'Harry', 'har@gmail.com', 889900),
--(2, 'Ben', 'ben@gmail.com', 112233),
--(3, 'Barry', 'bar@gmail.com', 778899),
--(3, 'Barry', 'bar@gmail.com', 778899);

-- Scenario 1: When you do not have any column with unique values
-- Approach 1 : Create a backup table and then truncate cust1 table. Use DISTINCT to insert non-duplicate records into cust1 table

-- Create backup table with same structure
--CREATE TABLE cust1_bkp (
--    id INT,
--    name VARCHAR(50),
--    email VARCHAR(100),
--    contact_no INT
--);

---- Insert records from cust1 into cust1_bkp
--INSERT INTO cust1_bkp (id, name, email, contact_no)
--SELECT id, name, email, contact_no
--FROM cust1;

--TRUNCATE TABLE cust1;


INSERT INTO cust1
SELECT DISTINCT * FROM cust1_bkp;

-- Approach2: Use WHERE EXISTS clause if backup table not allowed 
WITH CTE AS (
    SELECT 
        id,
        name,
        email,
        contact_no,
        ROW_NUMBER() OVER (
            PARTITION BY id, name, email, contact_no 
            ORDER BY id
        ) AS row_num
    FROM cust1
)
DELETE FROM cust1
WHERE EXISTS (
    SELECT 1
    FROM CTE
    WHERE CTE.id = cust1.id
      AND CTE.name = cust1.name
      AND CTE.email = cust1.email
      AND CTE.contact_no = cust1.contact_no
      AND CTE.row_num > 1
);

--Approach3: Directly DELETE Join operation
WITH CTE AS (
    SELECT 
        id,
        name,
        email,
        contact_no,
        ROW_NUMBER() OVER (
            PARTITION BY id, name, email, contact_no 
            ORDER BY id
        ) AS row_num
    FROM cust1
)
DELETE cust1
FROM cust1
INNER JOIN CTE
  ON cust1.id = CTE.id
 AND cust1.name = CTE.name
 AND cust1.email = CTE.email
 AND cust1.contact_no = CTE.contact_no
WHERE CTE.row_num > 1;

-- Scenario 2 : When we have unique id for each record

TRUNCATE TABLE CUST1;
INSERT INTO cust1 
VALUES
(1, 'Harry', 'har@gmail.com', 889900),
(2, 'Harry', 'har@gmail.com', 889900),
(3, 'Ben', 'ben@gmail.com', 112233),
(4, 'Barry', 'bar@gmail.com', 778899),
(5, 'Barry', 'bar@gmail.com', 778899);

-- Approach 1: Self Join
-- In scenario 2 we will not use id column in join condition
DELETE c1
FROM cust1 c1
INNER JOIN cust1 c2
  ON c1.name = c2.name
 AND c1.email = c2.email
 AND c1.contact_no = c2.contact_no
WHERE c1.id > c2.id;

SELECT * FROM cust1;
--Approach 2: Using ROW_NUMBER Within Subquery
-- In scenario 2 we will not use id column in partition condition
DELETE FROM cust1
WHERE id IN (
    SELECT id
    FROM (
        SELECT id,
               ROW_NUMBER() OVER (
                   PARTITION BY  name, email, contact_no
                   ORDER BY id
               ) AS row_num
        FROM cust1
    ) t
    WHERE t.row_num > 1
);

SELECT * FROM cust1;
-- Using CTE instead of subquery with ROW_NUMBER() function
WITH dup_check_cte AS
(
    SELECT *,
    ROW_NUMBER() OVER(PARTITION BY name,email,contact_no ORDER BY id) AS r_num
FROM cust1
)
DELETE FROM cust1
WHERE id IN
(
    SELECT DISTINCT id 
    FROM dup_check_cte 
    WHERE r_num >1
);

-- Using GROUP BY
DELETE FROM cust1
WHERE id NOT IN
(SELECT t1.id
FROM
(
SELECT MIN(id) as id,CONCAT(name,email,CAST(contact_no AS VARCHAR)) As key_col
FROM cust1
GROUP BY CONCAT(name,email,CAST(contact_no AS VARCHAR))
)AS t1);
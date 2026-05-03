Country - cntry_name
Rows - A,B,C,D
Fixtures without duplicates

-- Cross Join 
WITH cte AS
(
SELECT *
FROM country AS t1
CROSS JOIN country As t2
)
SELECT 
FROM cte


-- Suppose your table is called Country with column cntry_name
SELECT 
    c1.cntry_name AS Team1,
    c2.cntry_name AS Team2
FROM 
    Country c1
JOIN 
    Country c2 
    ON c1.cntry_name < c2.cntry_name
ORDER BY 
    Team1, Team2;

AB
AC 
AD
BA
BC
BD
---------------------------------

col1 - 
6 Rows-  1 to 6
Output - Odd , Even 
Odd - 1,3,5
Even -2,4,6
--
SELECT  CASE WHEN CASE WHEN col1%2 !=0 THEN col1 ELSE NULL END AS Odd
,CASE WHEN col1%2 ==0 THEN col1 ELSE NULL END AS Even 
FROM tb1

WITH OddNumbers AS (
    SELECT col1, ROW_NUMBER() OVER (ORDER BY col1) AS rn
    FROM tb1
    WHERE col1 % 2 = 1
),
EvenNumbers AS (
    SELECT col1, ROW_NUMBER() OVER (ORDER BY col1) AS rn
    FROM tb1
    WHERE col1 % 2 = 0
)
SELECT 
    o.col1 AS Odd,
    e.col1 AS Even
FROM OddNumbers o
JOIN EvenNumbers e
    ON o.rn = e.rn;


--------------------------------------



INSERT INTO dev.bkp_tbl
SELECT * FROM dev.src_tbl;

write 6th highest salary without using window function/max/min/limit/top/max/min
 
find list of employee having salary greater than manager

cols - emp_id, salary, man_id

SELECT DISTINCT e.emp_id
FROM emp AS e
INNER JOIN 
emp as m 
ON  e.man_id  = m.emp_id
WHERE e.sal > m.sal
----------------------------------------------------------------------
-- without using lag/lead - find customer who ordered 3 days consecutive.
WITH DistinctOrders AS (
    SELECT DISTINCT customer_id, CAST(order_date AS DATE) AS order_date
    FROM Orders
)
SELECT DISTINCT d1.customer_id
FROM DistinctOrders d1
JOIN DistinctOrders d2 
    ON d1.customer_id = d2.customer_id
   AND d2.order_date = DATEADD(DAY, 1, d1.order_date)
JOIN DistinctOrders d3 
    ON d1.customer_id = d3.customer_id
   AND d3.order_date = DATEADD(DAY, 2, d1.order_date);



WITH DistinctOrders AS (
    SELECT DISTINCT customer_id, CAST(order_date AS DATE) AS order_date
    FROM Orders
)
SELECT DISTINCT customer_id
FROM (
    SELECT 
        customer_id,
        order_date,
        LEAD(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS next_day,
        LEAD(order_date, 2) OVER (PARTITION BY customer_id ORDER BY order_date) AS next2_day
    FROM DistinctOrders
) AS t
WHERE next_day = DATEADD(DAY, 1, order_date)
  AND next2_day = DATEADD(DAY, 2, order_date);

------------------------------------------------------------------
write query to generate employee and their respective manager side by side 
company CTO is boss  . having no manager.
 
--assume 1lakh employee in company so create a recursive CTE based query
--cols - emp_id, name, man_id

Select e.emp_id, COAlesce(m.man_id,"Unavailable") AS man_id
FROM emp AS e 
LEFT JOIN 
emp AS m 
ON e.man_id = m.emp_id;

WITH EmployeeHierarchy AS (
    -- Anchor member: start with the CTO (no manager)
    SELECT 
        e.emp_id,
        e.name,
        e.man_id,
        CAST('Unavailable' AS VARCHAR(100)) AS manager_name
    FROM Employee e
    WHERE e.man_id IS NULL   -- CTO has no manager

    UNION ALL

    -- Recursive member: join employees to their managers
    SELECT 
        e.emp_id,
        e.name,
        e.man_id,
        m.name AS manager_name
    FROM Employee e
    INNER JOIN EmployeeHierarchy h
        ON e.man_id = h.emp_id
    INNER JOIN Employee m
        ON e.man_id = m.emp_id
)
SELECT emp_id, name, manager_name
FROM EmployeeHierarchy
ORDER BY emp_id;



i/p - today is good day
o/p - yad doog si yadot

input_li = [today is good day]

rev_li =input_li[::-1]

res_li
for i in range(len(

-- flatten nested json
explode
explode_outer



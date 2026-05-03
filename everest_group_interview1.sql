SELECT *
FROM employees
WHERE ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) <= 2;

SELECT *
FROM (
    SELECT * 
    FROM employees
    ORDER BY salary DESC
) AS sorted_employees
WHERE department = 'Engineering';

SELECT * 
FROM employees 
WHERE department = 'Engineering'
ORDER BY salary DESC;


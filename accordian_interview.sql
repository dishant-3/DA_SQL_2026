customer - name, age, postode,contact_no

WITH dup_checkcte AS
( SELECT *, ROW_NUMBER() OVER(PARTITION BY name,age,postcode,contact_no ORDER BY age) AS r_num
FROM customer)
DELETE FROM customer
WHERE r_num >1;

customer - name, age, gender(M,F,O)

--------------------------------------------------------

WITH cte1 AS(

SELECT *, CASE WHEN gender= 'M' THEN 'Male'
WHEN gender = 'F' THEN 'Female'
WHEN gender = 'O' THEN 'Others' ElsE Null End AS detail_gender
FROM customers
)
SELECT name, age, detail_gender AS gender 
FROM cte1;

UPDATE customer
SET gender = 
CASE WHEN gender= 'M' THEN 'Male'
WHEN gender = 'F' THEN 'Female'
WHEN gender = 'O' THEN 'Others' ElsE Null End AS gender


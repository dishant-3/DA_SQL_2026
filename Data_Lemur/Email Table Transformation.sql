-- Problem : Pivot the users table on email_type  column
WITH ranked_emails AS
(
SELECT *,
ROW_NUMBER () OVER(PARTITION BY user_id ORDER BY email_type ) AS r_num
FROM users
)
SELECT user_id,
MAX(CASE WHEN r_num =2 THEN email ELSE NULL END) AS personal,
MAX(CASE WHEN r_num =1 THEN email ELSE NULL END) AS business,
MAX(CASE WHEN r_num =3 THEN email ELSE NULL END) AS recovery
FROM ranked_emails 
GROUP BY user_id
ORDER BY user_id;

-- We use the MAX() function with CASE WHEN to filter out NULLS.
-- We can use MIN() as well for the above problem
-- If we have sales data with numeric year wise alues then we can use SUM().
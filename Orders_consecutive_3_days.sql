USE sample1;

---- Create Orders table
--CREATE TABLE Orders (
--    order_id INT IDENTITY(1,1) PRIMARY KEY,
--    customer_id INT NOT NULL,
--    order_date DATE NOT NULL,
--    value DECIMAL(10,2) NOT NULL
--);

---- Insert sample data for customer 101
--INSERT INTO Orders (customer_id, order_date, value)
--VALUES
--(101, '2026-04-01', 500.00),
--(101, '2026-04-02', 600.00),
--(101, '2026-04-03', 550.00),
--(101, '2026-04-04', 700.00),
--(101, '2026-04-05', 650.00);

---- Insert sample data for customer 102
--INSERT INTO Orders (customer_id, order_date, value)
--VALUES
--(102, '2026-04-01', 400.00),
--(102, '2026-04-02', 450.00),
--(102, '2026-04-03', 500.00),
--(102, '2026-04-04', 480.00),
--(102, '2026-04-05', 520.00);

-- Verify data
SELECT * FROM Orders;
WITH order_cte AS
(
SELECT *,
LEAD(order_date,1)OVER(PARTITION BY customer_id ORDER BY order_date) AS next_date,
LEAD(order_date,2)OVER(PARTITION BY customer_id ORDER BY order_date) AS next_2_date
FROM Orders
)
SELECT order_id, customer_id,order_date,value 
FROM order_cte 
WHERE DATEADD(DAY,1,order_date) = next_date AND DATEADD(DAY,2,order_date)=next_2_date;
USE sample1;

-- Step 1: Create the table
CREATE TABLE transactions (
    patient_id INT,
    transaction_id INT,
    transaction_dt DATE,
    transaction_amt DECIMAL(10,2)
);

-- Step 2: Insert sample data
INSERT INTO transactions (patient_id, transaction_id, transaction_dt, transaction_amt) VALUES
(1, 1001, '2023-01-15', 250.00),
(1, 1002, '2023-03-10', 180.00),
(1, 1003, '2023-07-22', 300.00),
(1, 1004, '2024-02-05', 220.00),
(1, 1005, '2024-11-18', 400.00),

(2, 2001, '2023-02-12', 150.00),
(2, 2002, '2023-02-25',  90.00),
(2, 2003, '2023-06-14', 200.00),
(2, 2004, '2024-01-09', 175.00),
(2, 2005, '2024-08-21', 210.00),

(3, 3001, '2023-04-03', 500.00),
(3, 3002, '2023-09-19', 320.00),
(3, 3003, '2024-03-11', 280.00),
(3, 3004, '2024-07-25', 350.00),

(4, 4001, '2023-05-07', 600.00),
(4, 4002, '2023-12-15', 450.00),
(4, 4003, '2024-04-20', 500.00),
(4, 4004, '2024-12-30', 700.00);

-- Step 1: Generate all months between Jan 2023 and Dec 2024
WITH Months AS (
    SELECT DATEFROMPARTS(2023,1,1) AS MonthStart
    UNION ALL
    SELECT DATEADD(MONTH,1,MonthStart)
    FROM Months
    WHERE MonthStart < '2024-12-01'
),

-- Step 2: Distinct patient-months where transactions exist
PatientMonths AS (
    SELECT DISTINCT 
           patient_id,
           DATEFROMPARTS(YEAR(transaction_dt), MONTH(transaction_dt), 1) AS MonthStart
    FROM transactions
),

-- Step 3: Cross join patients with all months
PatientCalendar AS (
    SELECT p.patient_id, m.MonthStart
    FROM (SELECT DISTINCT patient_id FROM transactions) p
    CROSS JOIN Months m
)

-- Step 4: Find missing months
SELECT pc.patient_id, pc.MonthStart
FROM PatientCalendar pc
LEFT JOIN PatientMonths pm
    ON pc.patient_id = pm.patient_id
   AND pc.MonthStart = pm.MonthStart
WHERE pm.patient_id IS NULL
  AND pc.MonthStart IN ('2024-08-01','2024-12-01')
ORDER BY pc.patient_id, pc.MonthStart
OPTION (MAXRECURSION 0);


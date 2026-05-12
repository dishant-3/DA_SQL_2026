-- 1. Create Trips Table
CREATE TABLE Trips (
    id INT PRIMARY KEY,
    client_id INT,
    driver_id INT,
    city_id INT,
    status VARCHAR(50) CHECK (status IN ('completed', 'cancelled_by_driver', 'cancelled_by_client')),
    request_at DATE
);

-- 2. Create Users Table
CREATE TABLE Users (
    users_id INT PRIMARY KEY,
    banned VARCHAR(50),
    role VARCHAR(50) CHECK (role IN ('client', 'driver', 'partner'))
);

-- 3. Insert into Trips (Batch Insert)
INSERT INTO Trips (id, client_id, driver_id, city_id, status, request_at) VALUES 
('1', '1', '10', '1', 'completed', '2013-10-01'),
('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01'),
('3', '3', '12', '6', 'completed', '2013-10-01'),
('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01'),
('5', '1', '10', '1', 'completed', '2013-10-02'),
('6', '2', '11', '6', 'completed', '2013-10-02'),
('7', '3', '12', '6', 'completed', '2013-10-02'),
('8', '2', '12', '12', 'completed', '2013-10-03'),
('9', '3', '10', '12', 'completed', '2013-10-03'),
('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03');

-- 4. Insert into Users (Batch Insert)
INSERT INTO Users (users_id, banned, role) VALUES 
('1', 'No', 'client'),
('2', 'Yes', 'client'),
('3', 'No', 'client'),
('4', 'No', 'client'),
('10', 'No', 'driver'),
('11', 'No', 'driver'),
('12', 'No', 'driver'),
('13', 'No', 'driver');

/* Write your T-SQL query statement below */
WITH trips_cte AS
(
    SELECT t.id, 
    t.client_id,
    t.driver_id,
    t.status,
    t.request_at,
    uc.role AS client_role,
    ud.role AS driver_role
    
    FROM Trips t
    INNER JOIN
    Users uc
    ON t.client_id = uc.users_id AND uc.banned = 'No'
    INNER JOIN 
    Users ud
    ON t.driver_id = ud.users_id AND ud.banned = 'No'

    
) SELECT request_at AS day, 
ROUND(COUNT(CASE WHEN status = 'cancelled_by_driver' OR status = 'cancelled_by_client' THEN id ELSE NULL END )*1.0/COUNT(id) ,2) AS "Cancellation Rate"
     
FROM trips_cte
WHERE request_at BETWEEN CAST('2013-10-01' AS DATE) AND CAST('2013-10-03' AS DATE)
GROUP BY request_at
HAVING COUNT(id) >=1;

-- Here Inner join with AND banned = 'No' condition removes banned users 
-- We have to use Double quotes ("") or [] for column names with spaces

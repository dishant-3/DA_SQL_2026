USE sample1;
-- REPLACE, STUFF, SUBSTRING, TRANSLATE functions
-- Create the table
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

-- Insert values
INSERT INTO Departments (dept_id, dept_name)
VALUES
    (100, 'Analytics'),
    (200, 'IT'),
    (300, 'HR'),
    (400, 'Text Analytics');


SELECT *,
REPLACE(dept_name,'Analytic','Mining') AS replace_string,
STUFF(dept_name,1,3,'demo') AS stuff_string,
SUBSTRING(dept_name,2,3) AS substr_string,
TRANSLATE(dept_name,'AR','ST') AS translate_string
FROM Departments;
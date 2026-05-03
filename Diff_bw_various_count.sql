SELECT * FROM emp;
--INSeRT INTO emp VALUES (9,'Chandra',NULL,NULL,2);
--INSERT INTO emp VALUES (NULL,NULl,NULL,NULL,NULL);
SELECT COUNT(*) FROM emp; -- Output: 11
SELECT COUNT(1) FROM emp; -- Output: 11
SELECT COUNT(department_id) FROM emp; -- Output: 9
-- When we do count on a column it only counts Non NULL records
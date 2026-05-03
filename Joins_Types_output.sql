---- Create table t1
--CREATE TABLE t1 (
--    id1 INT
--);

---- Insert values into t1
--INSERT INTO t1 (id1) VALUES
--(1),
--(1),
--(2),
--(3),
--(4),
--(5),
--(NULL),
--(NULL);

---- Create table t2
--CREATE TABLE t2 (
--    id2 INT
--);

---- Insert values into t2
--INSERT INTO t2 (id2) VALUES
--(1),
--(2),
--(6),
--(NULL);

SELECT *
FROM t1
INNER  JOIN
t2 
ON t1.id1 = t2.id2;
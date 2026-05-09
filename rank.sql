Create table Scores (id int, score DECIMAL(3,2));
Truncate table Scores;
insert into Scores (id, score) values ('1', '3.5')
insert into Scores (id, score) values ('2', '3.65')
insert into Scores (id, score) values ('3', '4.0')
insert into Scores (id, score) values ('4', '3.85')
insert into Scores (id, score) values ('5', '4.0')
insert into Scores (id, score) values ('6', '3.65');

SELECT s1.score, COUNT(s2.score)+1 AS my_rank
FROM Scores AS s1
LEFT JOIN Scores AS s2
ON s2.score > s1.score
GROUP BY s1.id,s1.score
ORDER BY s1.score DESC;

SELECT s1.score, COUNT(DISTINCT s2.score) AS dense_rank
FROM Scores As s1
INNER JOIN Scores AS s2
ON s2.score>= s1.score 
GROUP BY s1.id, s1.score
ORDER BY s1.score DESC;
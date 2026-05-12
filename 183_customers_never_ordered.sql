Input: 

Customers table:

+----+-------+

| id | name  |

+----+-------+

| 1  | Joe   |

| 2  | Henry |

| 3  | Sam   |

| 4  | Max   |

+----+-------+

Orders table:

+----+------------+

| id | customerId |

+----+------------+

| 1  | 3          |

| 2  | 1          |

+----+------------+     
 
 select c.name
 from 
 customers AS c
 LEFT JOIN 
 orders AS o
 ON c.id = o.customerId
 WHERE o.id IS NULL
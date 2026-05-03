You are given a products table 
  create table products (
      name varchar(20) primary key,
      price integer not null,
      quantity integer not null
  );
name - unique key, name of the product
price - price per single item of the product in dollars
quantity - the no of items of the product available in the shop.

What is the maximum no of items that can be bought with atmost 100 dollars?
Create a SQL expression for below cases.
Case1:
  +------------+-------+----------+
  | name       | price | quantity |
  +------------+-------+----------+
  | Pencil     | 3     | 30       |
  | Eraser     | 5     | 3        |
  | Notebook   | 5     | 3        |
  | Pen        | 6     | 20       |
  +------------+-------+----------+
Output for case 1:
  +----------+
  | quantity |
  +----------+
  | 32       |
  +----------+
case2:
  +------------+-------+----------+
  | name       | price | quantity |
  +------------+-------+----------+
  +------------+-------+----------+
Output for case 2:
  +----------+
  | quantity |
  +----------+
  | 0        |
  +----------+
Case 3:
  +------------+-------+----------+
  | name       | price | quantity |
  +------------+-------+----------+
  | Backpack   | 99    | 4        |
  | Jacket     | 101   | 2        |
  +------------+-------+----------+
Output for case 3:
  +----------+
  | quantity |
  +----------+
  | 1        |
  +----------+
Case 4:
  +------------+-------+----------+
  | name       | price | quantity |
  +------------+-------+----------+
  | Eraser     | 10    | 3        |
  | Jacket     | 30    | 2        |
  +------------+-------+----------+
Output for case4:
  +----------+
  | quantity |
  +----------+
  | 5        |
  +----------+
  --- SOlution 1
  WITH RECURSIVE buy(budget, total_items, product, remaining_qty) AS (
    -- Start with all products available
    SELECT 100, 0, name, quantity
    FROM products

    UNION ALL

    -- At each step, pick one unit of the cheapest product still affordable
    SELECT b.budget - p.price,
           b.total_items + 1,
           p.name,
           b.remaining_qty - 1
    FROM buy b
    JOIN products p ON p.name = b.product
    WHERE b.remaining_qty > 0
      AND p.price <= b.budget
)
SELECT MAX(total_items) AS quantity
FROM buy;

--Solution2
WITH ordered AS (
    SELECT name, price, quantity
    FROM products
    ORDER BY price
),
calc AS (
    SELECT SUM(
        LEAST(quantity, FLOOR(remaining_budget/price))
    ) AS total_items
    FROM (
        SELECT o.*,
               100 - SUM(o.price * o.quantity) OVER (ORDER BY o.price ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS remaining_budget
        FROM ordered o
    ) t
)
SELECT total_items AS quantity
FROM calc;

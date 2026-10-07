/*
Topic: Subqueries: Scalar, Correlated, EXISTS / NOT EXISTS vs IN / NOT IN 
 Using the same e-commerce tables: 
 (a) Scalar subquery in SELECT: each order alongside the overall average order amount. 
 (b) Use EXISTS to find customers who placed an order in the last 30 days. Rewrite using IN. 
    Explain which is more performant on large tables and why. 
 (c) Use NOT EXISTS to find customers who have NEVER placed an order. 
    Compare with NOT IN -- explain the NULL trap. 
 (d) Use a derived table (subquery in FROM) to calculate per-customer totals, 
    then select customers above the overall average. 
 (e) Predict the result set: -- orders: (1,100),(2,200),(3,300),(4,400),(5,500) 
    SELECT id, total_amount,   (SELECT AVG(total_amount) FROM orders) AS avg FROM orders WHERE 
    total_amount > (SELECT AVG(total_amount) FROM orders); 
*/

-- (a) Scalar subquery in SELECT: each order alongside the overall average order amount. 
SELECT
    id,
    total_amount,
    (SELECT AVG(total_amount) FROM orders) AS avg_amount
FROM orders; 


-- (b) Use EXISTS to find customers who placed an order in the last 30 days. Rewrite using IN. 
--    Explain which is more performant on large tables and why. 
SELECT *
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.id
      AND o.order_date > '2025-01-20'
);

SELECT * 
FROM customers 
WHERE id IN(
   SELECT customer_id 
   from orders
   WHERE order_date > '2025-01-20')


-- (c) Use NOT EXISTS to find customers who have NEVER placed an order. 
--    Compare with NOT IN -- explain the NULL trap.
SELECT *
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.id
) 

SELECT *
FROM customers
WHERE id NOT IN (
    SELECT customer_id
    FROM orders
);



-- (d) Use a derived table (subquery in FROM) to calculate per-customer totals, 
--    then select customers above the overall average.
SELECT id, per_customer_total, (SELECT AVG(per_customer_total) FROM customers) FROM
(SELECT c.id, c.name, SUM(o.total_amount) as per_customer_total
FROM customers c
JOIN orders o
ON  c.id = o.customer_id
GROUP BY c.id) t
WHERE per_customer_total > (SELECT AVG(per_customer_total) FROM customers)
GROUP BY id



-- (e) Predict the result set: -- orders: (1,100),(2,200),(3,300),(4,400),(5,500) 
--    SELECT id, total_amount,   (SELECT AVG(total_amount) FROM orders) AS avg FROM orders WHERE 
--    total_amount > (SELECT AVG(total_amount) FROM orders); 
/* Expected output - 
(id, total_amount, avg)
(4, 400, 300)
(5, 500, 300)

*/



SELECT * FROM orders;
SELECT * FROM products;
SELECT * from customers;

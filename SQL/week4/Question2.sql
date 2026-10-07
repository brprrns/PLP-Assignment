
/*
Topic: Aggregates: COUNT, SUM, AVG + GROUP BY & HAVING 
 Using orders (id, customer_id, order_date, total_amount) and customers (id, name, city): 
 (a) Show city, number of customers, and total revenue. Only include cities with revenue > 
    10000. Sort by revenue descending. 
 (b) Find the month with the highest total order amount. Group by month using DATE_TRUNC or EXTRACT. 
 (c) Average order amount per customer. Only show customers with 3+ orders AND average > 500. 
 (d) Count distinct customers who placed an order each month of 2024. 
 (e) Predict the result set: -- orders: 
(1,'Mumbai',500),(2,'Mumbai',300),(3,'Delhi',800),(4,'Delhi',400),(5,'Mumbai',700) SELECT 
city, COUNT(*) cnt, SUM(total_amount) rev FROM orders GROUP BY city HAVING 
SUM(total_amount)>1000 ORDER BY rev DESC;
*/

-- Create the Customer and Orders Table

use plp_week4

CREATE TABLE customers(
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT Null,
    city VARCHAR(50)
)

INSERT INTO customers(id, name, city) 
VALUES
(1, 'Alice', 'Mumbai'),
(2, 'Bob', 'Mumbai'),
(3, 'Carol', 'Delhi'),
(4, 'David', 'Delhi'),
(5, 'Emma', 'Bangalore'),
(6, 'Frank', 'Bangalore'),
(7, 'Grace', 'Chennai'),
(8, 'Henry', 'Pune');


CREATE TABLE orders(
    id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),

    FOREIGN KEY (customer_id) REFERENCES customers(id)
)

INSERT INTO orders(id, customer_id, order_date, total_amount)
VALUES
-- Mumbai
(1, 1, '2024-01-10', 4000),
(2, 1, '2024-02-15', 3000),
(3, 2, '2024-03-20', 5000),
-- Delhi
(4, 3, '2024-01-12', 2500),
(5, 3, '2024-02-18', 3500),
(6, 4, '2024-03-25', 4500),
-- Bangalore
(7, 5, '2024-01-05', 2000),
(8, 5, '2024-04-10', 2500),
(9, 6, '2024-05-15', 3000),
-- Chennai
(10, 7, '2024-06-20', 1500),
-- Additional orders for customers with 3+ orders
(11, 1, '2024-04-05', 2000),
(12, 1, '2024-05-10', 2500),
(13, 2, '2024-06-15', 1000),
-- 2025 orders, useful for understanding date filtering
(14, 3, '2025-01-10', 6000),
(15, 5, '2025-02-20', 4000);


SELECT * FROM orders;

SELECT * FROM customers;


-- (a) Show city, number of customers, and total revenue. Only include cities with revenue > 
--    10000. Sort by revenue descending.
SELECT 
    c.city, 
    COUNT(DISTINCT c.id) AS customer_count,
    SUM(o.total_amount) AS revenue
FROM customers c
JOIN orders o
    ON c.id = o.customer_id 
GROUP BY c.city
HAVING SUM(o.total_amount)>10000
ORDER BY SUM(o.total_amount) DESC


--  (b) Find the month with the highest total order amount. 
--      Group by month using DATE_TRUNC or EXTRACT. 
SELECT (EXTRACT(MONTH from order_date)) AS month, SUM(total_amount) as total_order_amount
FROM orders
GROUP BY month
LIMIT 1;

SELECT MONTHNAME(order_date) AS month, MAX(total_amount)
FROM orders
GROUP BY month;




--  (c) Average order amount per customer. Only show customers with 3+ orders AND average > 500. 
SELECT 
    customer_id, 
    COUNT(customer_id) AS order_count, 
    ROUND(AVG(total_amount), 2) AS avg_order_amount
FROM orders
GROUP BY customer_id
HAVING COUNT(customer_id) >= 3 and AVG(total_amount)>500;


--  (d) Count distinct customers who placed an order each month of 2024. 
SELECT 
    EXTRACT(MONTH from order_date) AS month , 
    COUNT(DISTINCT customer_id) AS distinct_customer_count
FROM orders
WHERE order_date >= '2024-01-01'
  AND order_date < '2025-01-01'
GROUP BY EXTRACT(MONTH from order_date)
ORDER BY month;


-- (e) Predict the result set: -- orders: 
-- (1,'Mumbai',500),(2,'Mumbai',300),(3,'Delhi',800),(4,'Delhi',400),(5,'Mumbai',700)  
-- SELECT city, COUNT(*) cnt, SUM(total_amount) rev FROM orders GROUP BY city HAVING 
-- SUM(total_amount)>1000 ORDER BY rev DESC;

/* Expected Output
(city, cnt, rev)
('Mumbai', 3, 1500)
('Delhi', 2, 1200)
*/


SELECT * from customers;
SELECT * from orders;

-- Active: 1790082456666@@127.0.0.1@3306@plp_week4
/*
Topic: JOINs: INNER, LEFT, RIGHT & FULL OUTER 
 Using customers, orders, and products tables: 
 (a) INNER JOIN: customer name, order date, total amount for all 2024 orders. 
 (b) LEFT JOIN: ALL customers and their order count (show 0 if no orders). 
    Explain LEFT vs INNER in a comment. 
 (c) Find products that have NEVER appeared in any order. 
    Use LEFT JOIN + IS NULL or NOT EXISTS -- explain your choice. 
 (d) Write a FULL OUTER JOIN example and explain which rows appear 
    that would NOT appear in INNER, LEFT, or RIGHT JOINs. 
 (e) Predict the result set: -- customers: (1,'Alice'),(2,'Bob'),(3,'Carol') -- orders: 
(101,1,500),(102,1,300) SELECT c.name, COUNT(o.id) AS order_count FROM customers c 
LEFT JOIN orders o ON c.id=o.customer_id GROUP BY c.name ORDER BY c.name;
*/

--- Seeing all the Tables
SELECT * FROM customers;
SELECT * FROM orders;
SELECT* FROM products;

-- Adding the product_id to the orders table
ALTER Table orders
ADD COLUMN product_id INT;

ALTER Table orders
ADD CONSTRAINT fk_orders_product
FOREIGN KEY (product_id) REFERENCES products(id)

UPDATE orders SET product_id = 1 WHERE id = 1;
UPDATE orders SET product_id = 2 WHERE id = 2;
UPDATE orders SET product_id = 4 WHERE id = 3;
UPDATE orders SET product_id = 1 WHERE id = 4;
UPDATE orders SET product_id = 6 WHERE id = 5;
UPDATE orders SET product_id = 2 WHERE id = 6;


-- (a) INNER JOIN: customer name, order date, total amount for all 2024 orders.
SELECT
    c.name, 
    o.order_date,
    o.total_amount
FROM customers c
INNER JOIN orders o 
    ON c.id = customer_id
    AND EXTRACT(YEAR FROM o.order_date) = 2024
;


--  (b) LEFT JOIN: ALL customers and their order count (show 0 if no orders). 
--    Explain LEFT vs INNER in a comment
SELECT 
    c.name, COUNT(o.customer_id) as order_count
FROM customers c
LEFT JOIN orders o
ON c.id = o.customer_id
GROUP BY c.name
-- LEFT JOIN - returns all rows from the left table and INNER JOIN - returns only the rows where there is a match in both tables



-- (c) Find products that have NEVER appeared in any order. 
--    Use LEFT JOIN + IS NULL or NOT EXISTS -- explain your choice. 

SELECT
    p.name
FROM products p 
LEFT JOIN  orders o 
    ON p.id = o.product_id  
WHERE o.product_id is NULL
-- LEFT JOIN keeps every product.
-- If a product has no matching order, the order columns are NULL,
-- so IS NULL identifies products that were never ordered 



-- (d) Write a FULL OUTER JOIN example and explain which rows appear 
--    that would NOT appear in INNER, LEFT, or RIGHT JOINs. 
SELECT *
FROM customers c
FULL OUTER JOIN orders o
    ON c.id = o.customer_id;
-- OUTER JOIN - appears all the data from both tables if null exists also which is different from other joins


-- (e) Predict the result set: -- customers: (1,'Alice'),(2,'Bob'),(3,'Carol') -- orders: 
-- (101,1,500),(102,1,300) SELECT c.name, COUNT(o.id) AS order_count FROM customers c 
-- LEFT JOIN orders o ON c.id=o.customer_id GROUP BY c.name ORDER BY c.name;

/* EXpected Output
(name, order_count)
('Alice', 2)
('Bob', 0)
('Carol', 0)
*/

SELECT * FROM customers;
SELECT * FROM orders;
SELECT* FROM products;
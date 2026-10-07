/*

Q1 Topic: SELECT, WHERE, ORDER BY, LIMIT, Aliases & NULL Handling 
 Using a products table (id, name, category, price, stock_qty, supplier_id -- supplier_id may be 
NULL): 
 (a) List all 'Electronics' products costing more than 500, ordered by price descending. Alias 
name as product_name, price as unit_price. 
 (b) Find the 5 most expensive products overall. 
 (c) Use COALESCE to show supplier_id if available, otherwise 'No Supplier'. Use NULLIF to 
return NULL if stock_qty = 0. 
 (d) Find products where supplier_id IS NULL and where IS NOT NULL. Show counts using 
COUNT(). 
 (e) Predict the result set: -- products: 
(1,'Phone',999,NULL),(2,'Laptop',1500,10),(3,'Tablet',500,NULL) SELECT name, 
COALESCE(supplier_id::text,'No Supplier') AS supplier, NULLIF(price,500) AS price FROM 
products ORDER BY price DESC NULLS LAST;

*/



-- Create the database
CREATE DATABASE plp_week4;

-- Use the database
USE plp_week4;


-- Create the table
CREATE TABLE products(
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10, 2),
    stock_qty INT,
    supplier_id INT

);


-- Insert sample data into the table
INSERT INTO products(id, name, category, price, stock_qty, supplier_id) 
VALUES
(1, 'Smartphone', 'Electronics', 999.00, 25, 101),
(2, 'Laptop', 'Electronics', 1500.00, 10, 102),
(3, 'Tablet', 'Electronics', 500.00, 0, NULL),
(4, 'Headphones', 'Electronics', 250.00, 50, 103),
(5, 'Smart TV', 'Electronics', 2200.00, 5, 104),
(6, 'Gaming Laptop', 'Electronics', 2500.00, 8, NULL),
(7, 'Office Chair', 'Furniture', 300.00, 20, 105),
(8, 'Dining Table', 'Furniture', 800.00, 7, 106),
(9, 'Bookshelf', 'Furniture', 150.00, 15, NULL),
(10, 'Premium Sofa', 'Furniture', 1800.00, 3, 107),
(11, 'Keyboard', 'Electronics', 100.00, 40, 108),
(12, '4K Monitor', 'Electronics', 1200.00, 12, 109);


-- Verify the data in the table
SELECT * FROM products;


-- (a) List all 'Electronics' products costing more than 500, ordered by price descending. 
-- Alias name as product_name, price as unit_price.
SELECT name as product_name, price as unit_price
FROM products
WHERE category = 'Electronics' AND price > 500
ORDER BY price DESC;


-- (b) Find the 5 most expensive products overall.
SELECT name, price 
FROM products
ORDER BY price DESC
LIMIT 5


-- (c) Use COALESCE to show supplier_id if available, otherwise 'No Supplier'. 
-- Use NULLIF to return NULL if stock_qty = 0. 
SELECT id, name, category, price, stock_qty, COALESCE(supplier_id, 'No Supplier') FROM products

SELECT id, name, category, price, NULLIF(stock_qty, 0), COALESCE(supplier_id, 'No Supplier') FROM products


-- (d) Find products where supplier_id IS NULL and where IS NOT NULL. 
-- Show counts using COUNT().
SELECT * FROM products WHERE supplier_id is NULL

SELECT * FROM products WHERE supplier_id is NOT NULL

SELECT COUNT(*) from products

SELECT COUNT(*) FROM products WHERE supplier_id is NULL

SELECT COUNT(*) FROM products WHERE supplier_id is NoT NULL


-- (e) Predict the result set: -- products: 
-- (1,'Phone',999,NULL),(2,'Laptop',1500,10),(3,'Tablet',500,NULL) SELECT name, 
-- COALESCE(supplier_id::text,'No Supplier') AS supplier, NULLIF(price,500) AS price FROM 
-- products ORDER BY price DESC NULLS LAST; 

/* Expected Output
(name, supplier, price)
(Laptop,10, 1500 )
(Phone,No Supplier, 999 )
(Tablet,No Supplier, NUll )
 
*/

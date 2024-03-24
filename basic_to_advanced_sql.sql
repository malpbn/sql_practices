-- SQL basic to advance SHOWCASE

-- SELECT * FROM products;

-- SELECT * FROM products
-- WHERE productid > 60;

-- SELECT p.categoryid, c.categoryname, COUNT(p.categoryid) categorycount FROM products p
-- INNER JOIN Categories c ON p.categoryid = c.categoryid
-- GROUP BY p.categoryid, c.categoryname
-- ORDER BY categorycount DESC;

-- SELECT p.categoryid, c.categoryname, ROUND(AVG(p.price),2) categoryavgprice FROM products p
-- INNER JOIN Categories c ON p.categoryid = c.categoryid
-- GROUP BY p.categoryid, c.categoryname
-- ORDER BY categoryavgprice DESC;

-- SELECT p.categoryid, c.categoryname, SUM(p.price) categorytotalprice FROM products p
-- INNER JOIN Categories c ON p.categoryid = c.categoryid
-- GROUP BY p.categoryid, c.categoryname
-- ORDER BY categorytotalprice DESC;

-- SELECT DISTINCT p.productid, p.productname, p.price FROM products p
-- INNER JOIN orderdetails o ON p.productid = o.productid
-- ORDER BY p.price DESC;

-- SELECT p.categoryid, c.categoryname, MAX(p.price) highestcategoryproductprice 
-- FROM products p
-- INNER JOIN Categories c ON p.categoryid = c.categoryid
-- GROUP BY p.categoryid, c.categoryname
-- ORDER BY highestcategoryproductprice DESC;

-- SELECT od.productid, p.productname, p.price, MIN(od.quantity) lowestquantity FROM orderdetails od
-- INNER JOIN Products p ON od.productid = p.productid
-- GROUP BY od.productid, p.productname, p.price
-- ORDER BY lowestquantity;

-- SELECT p.categoryid, c.categoryname, COUNT(p.categoryid) categorycount FROM products p
-- INNER JOIN Categories c ON p.categoryid = c.categoryid
-- GROUP BY p.categoryid, c.categoryname
-- HAVING COUNT(p.categoryid) > 9
-- ORDER BY categorycount DESC;

-- SELECT productname, SUM(quantity) totalproductquantity FROM products p
-- LEFT JOIN orderdetails od ON p.productid = od.productid
-- GROUP BY productname
-- ORDER BY productname;

-- SELECT productname, s.supplierid, suppliername, country FROM products p
-- RIGHT JOIN Suppliers s ON p.supplierid = s.supplierid
-- ORDER BY s.supplierid;

-- SELECT productname, categoryname FROM products p 
-- FULL OUTER JOIN Categories c on p.categoryid = c.categoryid;

-- SELECT orderid, productname, quantity, price, ROUND((quantity * price),2) AS totalprice 
-- FROM Products p 
-- INNER JOIN orderdetails od ON p.productid = od.productid
-- ORDER BY totalprice DESC;

-- WITH CTE AS (
-- 	SELECT productname, price, quantity FROM products p
-- 	CROSS JOIN orderdetails
-- 	WHERE categoryid = 1
-- 	ORDER BY productname, price DESC)
-- SELECT productname, price, quantity, (price*quantity) AS bestcombination 
-- FROM CTE
-- ORDER BY bestcombination DESC
-- LIMIT 20;

-- SELECT categoryid FROM products
-- UNION
-- SELECT categoryid FROM categories
-- ORDER BY categoryid;

-- SELECT productname, quantity, price, 
-- (CASE WHEN quantity > 20 THEN price - (price * 0.2) ELSE price END) AS finalprice
-- FROM Products p
-- LEFT JOIN orderdetails od ON p.productid = od.productid
-- ORDER BY quantity DESC;

-- SELECT employeeid, CONCAT(firstname,' ',lastname) AS fullname 
-- FROM Employees; 

-- SELECT productname, categoryname, COUNT(p.categoryid) OVER (PARTITION BY p.categoryid) AS TotalCategoryCount
-- FROM Products p
-- JOIN Categories c ON p.categoryid = c.categoryid
-- WHERE p.categoryid = 1 OR p.categoryid = 5;

-- CREATE TEMP TABLE products_catg_one (
-- 	productname VARCHAR(255),
-- 	categoryid VARCHAR(255),
-- 	categoryname VARCHAR(255),
-- 	price VARCHAR(255));

-- INSERT INTO products_catg_one
-- SELECT productname, p.categoryid, categoryname, price FROM products p
-- INNER JOIN Categories c ON p.categoryid = c.categoryid
-- WHERE p.categoryid = 1
-- ORDER BY price DESC;

-- SELECT * FROM products_catg_one;

-- SELECT categoryid, categoryname, UPPER(SUBSTRING(categoryname,1,3)) AS categorycharctcode
-- FROM Categories;

-- CREATE OR REPLACE FUNCTION tabla_temp_categoria_2()
-- RETURNS TABLE (
--     productname VARCHAR(255),
-- 	categoryid VARCHAR(255),
-- 	categoryname VARCHAR(255),
-- 	price VARCHAR(255)
-- ) AS
-- $$
-- BEGIN
--     -- Crear la tabla temporal
--     CREATE TEMPORARY TABLE temp_category_2 (
--     productname VARCHAR(255),
-- 	categoryid VARCHAR(255),
-- 	categoryname VARCHAR(255),
-- 	price VARCHAR(255)
--     );

--     -- Insertar algunos datos de ejemplo en la tabla temporal
--     INSERT INTO temp_category_2
-- 	SELECT p.productname, p.categoryid, c.categoryname, p.price FROM products p
-- 	INNER JOIN Categories c ON p.categoryid = c.categoryid
-- 	WHERE p.categoryid = 1
-- 	ORDER BY p.price DESC;
	
  

-- END;
-- $$
-- LANGUAGE plpgsql;

-- SELECT tabla_temp_categoria_2();

-- SELECT * FROM temp_category_2;

-- SELECT productname, categoryid, price FROM products
-- WHERE productid IN (
-- 		SELECT productid FROM orderdetails
-- 		WHERE quantity > 100);

-- SELECT productname, unit, CONCAT(CAST(price AS VARCHAR),' ', 'per unit') price_per_unit 
-- FROM products;

-- SELECT
--     ROW_NUMBER() OVER (ORDER BY productid) AS numero_fila,
--     *
-- FROM Products;

-- SELECT productname, price,
--     SUM(price) OVER (ORDER BY productid) AS suma_acumulativa
-- FROM Products;

-- SELECT
--     price,
--     LAG(price) OVER (ORDER BY productid) AS valor_posterior
-- FROM
--     Products;

-- SELECT
--     RANK() OVER (ORDER BY productid) AS ranking,
--     price
-- FROM
--     Products;

-- CREATE VIEW top_5_products AS
-- SELECT od.productid, p.productname, SUM(p.price*od.quantity) total_price
-- FROM products p
-- INNER JOIN orderdetails od ON p.productid = od.productid
-- GROUP BY od.productid, p.productname
-- ORDER BY total_price DESC
-- LIMIT 5;

-- SELECT * FROM top_5_products;

-- SELECT customerid, contactname, COALESCE(postalcode, 'Not registered') AS postalcode
-- FROM Customers;

-- SELECT * FROM customers
-- WHERE contactname IS NULL;

-- SELECT customerid, contactname, CONCAT(address,' ', city, ' ', postalcode, ', ', country) full_address
-- FROM Customers
-- WHERE postalcode IS NOT NULL;

-- SELECT description FROM Categories
-- WHERE LENGTH(description) > 30;

-- SELECT * FROM orders;

-- SELECT DISTINCT a.orderid, a.customerid, a.orderdate, a.shipperid FROM Orders a, Orders b
-- WHERE a.orderdate > b.orderdate
-- AND a.shipperid BETWEEN 1 AND 2;

-- SELECT od.productid, p.productname, od.quantity, p.price 
-- FROM orderdetails od
-- LEFT JOIN Products p ON od.productid = p.productid
-- WHERE COALESCE(od.quantity,0) > 90;

-- SELECT productid, MAX(quantity) maxquantity FROM Orderdetails
-- GROUP BY productid
-- ORDER BY maxquantity DESC
-- LIMIT 1 OFFSET 1;

-- SELECT productid, productname, price 
-- FROM products
-- WHERE productname LIKE '%Choco%';

-- SELECT categoryid, ROUND(AVG(CASE WHEN price > 20 THEN price ELSE 0 END),2) AS top_category_prices
-- FROM products
-- GROUP BY categoryid
-- ORDER BY categoryid;
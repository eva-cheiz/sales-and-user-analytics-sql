-- ============================================
-- CASE 2: Sales & HR Analytics
-- Platform: MySQL | DB: mini_project
-- ============================================


-- Schema Setup
-- ============================================

CREATE DATABASE mini_project;
USE mini_project;

CREATE TABLE T_TAB1 (
    ID          INT         UNIQUE,
    GOODS_TYPE  VARCHAR(50),
    QUANTITY    INT,
    AMOUNT      INT,
    SELLER_NAME VARCHAR(50)
);

CREATE TABLE T_TAB2 (
    ID     INT        UNIQUE,
    NAME   VARCHAR(50),
    SALARY INT,
    AGE    INT
);

INSERT INTO T_TAB1 VALUES
(1,'MOBILE PHONE',2,400000,'MIKE'),
(2,'KEYBOARD',1,10000,'MIKE'),
(3,'MOBILE PHONE',1,50000,'JANE'),
(4,'MONITOR',1,110000,'JOE'),
(5,'MONITOR',2,80000,'JANE'),
(6,'MOBILE PHONE',1,130000,'JOE'),
(7,'MOBILE PHONE',1,60000,'ANNA'),
(8,'PRINTER',1,90000,'ANNA'),
(9,'KEYBOARD',2,10000,'ANNA'),
(10,'PRINTER',1,80000,'MIKE');

INSERT INTO T_TAB2 VALUES
(1,'ANNA',110000,27),
(2,'JANE',80000,25),
(3,'MIKE',120000,25),
(4,'JOE',70000,24),
(5,'RITA',120000,29);


-- Task 2.1: Unique product categories
-- Result: 4 categories (MOBILE PHONE, KEYBOARD, MONITOR, PRINTER)

SELECT DISTINCT GOODS_TYPE
FROM T_TAB1;


-- Task 2.2: Total quantity and revenue for mobile phones
-- Result: qty = 5, amount = 640,000

SELECT
    SUM(QUANTITY) AS total_qty,
    SUM(AMOUNT)   AS total_amount
FROM T_TAB1
WHERE GOODS_TYPE = 'MOBILE PHONE';


-- Task 2.3: Employees with salary > 100,000
-- Result: 3 employees (ANNA, MIKE, RITA)

SELECT NAME, SALARY
FROM T_TAB2
WHERE SALARY > 100000;


-- Task 2.4: Min/max age and salary across all employees

SELECT
    MIN(AGE)    AS min_age,
    MAX(AGE)    AS max_age,
    MIN(SALARY) AS min_salary,
    MAX(SALARY) AS max_salary
FROM T_TAB2;


-- Task 2.5: Avg quantity sold for keyboards and printers
-- Note: AVG calculated across all rows of both types combined

SELECT AVG(QUANTITY) AS avg_qty
FROM T_TAB1
WHERE GOODS_TYPE IN ('KEYBOARD', 'PRINTER');


-- Task 2.6: Total revenue per employee

SELECT
    SELLER_NAME,
    SUM(AMOUNT) AS total_sales
FROM T_TAB1
GROUP BY SELLER_NAME;


-- Task 2.7: Full sales profile for employee MIKE (JOIN)
-- Joins sales data with HR data to get complete employee picture

SELECT
    t2.NAME,
    t.GOODS_TYPE,
    t.QUANTITY,
    t.AMOUNT,
    t2.SALARY,
    t2.AGE
FROM T_TAB1 t
JOIN T_TAB2 t2 ON t.SELLER_NAME = t2.NAME
WHERE t2.NAME = 'MIKE';


-- Task 2.8: Employees with zero sales
-- LEFT JOIN + IS NULL is safer than NOT IN (handles NULLs correctly)
-- Result: 1 employee (RITA)

SELECT t2.NAME, t2.AGE
FROM T_TAB2 t2
LEFT JOIN T_TAB1 t ON t2.NAME = t.SELLER_NAME
WHERE t.SELLER_NAME IS NULL;


-- Task 2.9: Employees under 26 years old with their salary
-- Result: 3 rows (JANE, MIKE, JOE)

SELECT NAME, SALARY
FROM T_TAB2
WHERE AGE < 26;


-- Task 2.10: JOIN result for RITA
-- RITA has no sales records in T_TAB1 → JOIN returns 0 rows

SELECT * FROM T_TAB1 t
JOIN T_TAB2 t2 ON t2.NAME = t.SELLER_NAME
WHERE t2.NAME = 'RITA';
-- Result: 0 rows
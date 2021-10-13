use classicmodels;

SELECT * 
FROM products p
INNER JOIN productlines  pl
ON p.productline = pl.productline;

-- Exercise 1 
SELECT *
FROM orders o
INNER JOIN orderdetails od
ON o.ordernumber = od.orderNumber;

-- Exercise 2 
SELECT o.orderNumber, o.status, sum(od.quantityOrdered * od.priceEach) AS sum_of_totalsales
FROM orders o 
INNER JOIN orderdetails od
ON o.ordernumber = od.orderNumber
GROUP BY ordernumber,status;

-- Exercise 3 
SELECT o.orderDate,e.lastName, e.firstName
FROM orders o
INNER JOIN customers c
ON o.customernumber = c.customerNumber
INNER JOIN employees e 
ON c.salesRepEmployeeNumber = e.employeeNumber;




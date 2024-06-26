use classicmodels;
select * from customers;

/*Question 1. 
Find the top 10 customers who have placed the most orders. Display customer name and the count of orders placed.*/

select * from customers; select * from orders; select * from orderdetails;
SELECT DISTINCT concat(contactfirstname,' ',contactlastname) AS customer_name, 
	COUNT(o.orderNumber) OVER (PARTITION BY customername) AS count_of_orders
FROM 
	customers c 
JOIN
	orders o 
ON 	c.customerNumber=o.customerNumber
ORDER BY
	count_of_orders DESC
LIMIT 10;


/* Question 2
2. Retrieve the list of customers who have placed orders but haven't made any payments yet.*/
select * from customers; select * from orders; select * from orderdetails; SELECT * from payments;
 SELECT concat(contactfirstname,' ',contactlastname) AS Customer_Name , Amount as payment_not_made
	 FROM customers c 
 left JOIN 
	orders o ON c.customerNumber=o.customerNumber
LEFT JOIN 
	payments p ON o.customernumber= p.customernumber
WHERE ordernumber IS NOT NULL 
AND amount IS NULL;
select * from customers; SELECT * from payments;
select distinct customername from customers c
join payments p on c.customerNumber=p.customernumber
;

 /* Question 3
3. Retrieve a product that has been ordered the least number of times. Display the product code, product name,
 and the number of times it has been ordered.*/
 
SELECT DISTINCT P.ProductCode, p.ProductName, Count(*) OVER(PARTITION BY productcode) AS Number_of_times 
FROM	  
	Products P
LEFT JOIN  
	orderdetails od ON p.productCode=od.productCode
ORDER BY Number_of_times
LIMIT 1;
 
 
/* Question 4
4. Classic Models has a product line called "Vintage Cars." 
The management wants to know the total revenue generated by this product line in the last quarter of the year 2003
(from October to December). Write a MySQL stored procedure that takes no input parameters and returns total revenue 
of the "Vintage Cars" product line for the last quarter of 2003.*/ 
SELECT * from products; select * from payments; select * from orders; select * from orderdetails;
Delimiter //
CREATE PROCEDURE vintagecars()
BEGIN
SELECT productline , 
	QUARTER(pa.paymentDate) AS quart, 
    SUM(pa.amount) AS totalrevenue FROM 	products p 
JOIN 	orderdetails od ON p.productcode=od.productCode
JOIN    orders o ON od.ordernumber=o.ordernumber
JOIN 	payments pa ON o.customernumber= pa.customernumber 
WHERE 	productline='vintage cars' AND Year(pa.paymentdate)='2003'
GROUP BY productline
HAVING 	quart = 4 ;
END //
Delimiter ;
CALL vintagecars();


/* Question 5
5. Write an SQL query using CTE's and window functions inside it to retrieve the top 5 customers along with their total 
order values across all orders.*/
select * from customers; select * from orders; select * from orderdetails;
WITH CTE_customer 
AS
(
SELECT DISTINCT customername , sum(quantityordered*PriceEach) OVER(PARTITION BY customername) AS totalorder
FROM customers c JOIN orders o ON c.customernumber=o.customernumber
JOIN orderdetails od ON o.ordernumber=od.ordernumber
)
SELECT * FROM CTE_customer
ORDER BY totalorder DESC
LIMIT 5;



/* Question 6
Display the product codes and names for products with a buy price greater than the average buy price.*/

select * from products ;
select productcode , productname 
from products 
where buyprice > (
					select avg(buyprice) from products
				 );

/* Question 7 
Show the lead and lag values of order dates for each order, ordered by order date.*/
select * from orders;	
select orderdate, 
Lead(orderdate) over(order by orderdate) lead_date,
Lag(orderdate) over(order by orderdate) Lag_date 
from orders;



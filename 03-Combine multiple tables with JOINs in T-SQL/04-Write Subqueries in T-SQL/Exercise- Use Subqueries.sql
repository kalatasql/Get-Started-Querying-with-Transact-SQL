--In this exercise, you’ll use subqueries to retrieve data from tables in the adventureworks database.

--Challenge 1: Retrieve product price information
--Adventure Works products each have a standard cost price that indicates the cost of manufacturing the product, 
--and a list price that indicates the recommended selling price for the product. This data is stored in 
--the SalesLT.Product table. Whenever a product is ordered, the actual unit price at which it was sold 
--is also recorded in the SalesLT.SalesOrderDetail table. You must use subqueries to compare the cost 
--and list prices for each product with the unit prices charged in each sale.

--1. Retrieve products whose list price is higher than the average unit price.

--Retrieve the product ID, name, and list price for each product where the list price 
--is higher than the average unit price for all products that have been sold.

--Tip: Use the AVG function to retrieve an average value.

SELECT ProductID, [Name], ListPrice
FROM SalesLT.[Product]
WHERE ListPrice > (SELECT AVG(UnitPrice) 
				   FROM SalesLT.SalesOrderDetail)
ORDER BY ProductID;

--2. Retrieve Products with a list price of 100 or more that have been sold for less than 100.

--Retrieve the product ID, name, and list price for each product where
--the list price is 100 or more, and the product has been sold for less than 100.

SELECT p.ProductID, p.[Name], p.ListPrice
FROM SalesLT.[Product] AS p
WHERE p.ListPrice >= 100 
  AND EXISTS 
	  (SELECT * -- can be 1 too
	   FROM SalesLT.SalesOrderDetail so
	   WHERE p.ProductID = so.ProductID
	     AND so.UnitPrice < 100);

SELECT p.ProductID, p.[Name], p.ListPrice
FROM SalesLT.[Product] AS p
WHERE p.ListPrice >= 100 
  AND ProductID IN (SELECT ProductID
					FROM  SalesLT.SalesOrderDetail so
					WHERE so.UnitPrice < 100);

	--Challenge 2: Analyze profitability

	--The standard cost of a product and the unit price at which it is sold determine its profitability.
	--You must use correlated subqueries to compare the cost and average selling price for each product.

	--1. Retrieve the cost, list price, and average selling price for each product
	--Retrieve the product ID, name, cost, and list price for each product along with the average unit price for which that product has been sold.

SELECT ProductID, Name, StandardCost, ListPrice,
			  (SELECT AVG(UnitPrice)
			   FROM SalesLT.SalesOrderDetail so 
			   WHERE p.ProductID = so.ProductID) AS AverageSellingPrice
FROM   SalesLT.Product p
WHERE  EXISTS (SELECT * 
			   FROM SalesLT.SalesOrderDetail so
			   WHERE p.ProductID = so.ProductID);

--2. Retrieve products that have an average selling price that is lower than the cost.
--Filter your previous query to include only products where the cost price is higher than the average selling price.

SELECT ProductID, Name, StandardCost, ListPrice,
			  (SELECT AVG(UnitPrice)
			   FROM SalesLT.SalesOrderDetail so 
			   WHERE p.ProductID = so.ProductID) AS AverageSellingPrice
FROM   SalesLT.Product p
WHERE  StandardCost > (SELECT AVG(UnitPrice)
					   FROM SalesLT.SalesOrderDetail so 
					   WHERE p.ProductID = so.ProductID);

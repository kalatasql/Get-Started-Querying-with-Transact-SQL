Exercise - Use built-in functions


--Challenge 1: Retrieve order shipping information
--The operations manager wants reports about order shipping based on data in the SalesLT.SalesOrderHeader table.

--1. Retrieve the order ID and freight cost of each order.
--Write a query to return the order ID for each order, together with the the Freight value rounded to two decimal places in a column named FreightCost.

SELECT SalesOrderID, ROUND(Freight, 2) AS FreightCost FROM SalesLT.SalesOrderHeader

--2. Add the shipping method.
--Extend your query to include a column named ShippingMethod that contains the ShipMethod field, formatted in lower case.

SELECT SalesOrderID, 
	   ROUND(Freight, 2) AS FreightCost, 
	   LOWER(ShipMethod) as ShippingMethod 
FROM SalesLT.SalesOrderHeader

--3. Add shipping date details.
--Extend your query to include columns named ShipYear, ShipMonth, and ShipDay that contain the year, month, 
--and day of the ShipDate. The ShipMonth value should be displayed as the month name (for example, June)

SELECT SalesOrderID, 
	   ROUND(Freight, 2) AS FreightCost, 
	   LOWER(ShipMethod) AS ShippingMethod, 
	   YEAR(ShipDate) AS ShipYear,
	   DATENAME(MONTH,ShipDate) AS ShipMonth,
	   DAY(ShipDate) AS ShipDay
FROM SalesLT.SalesOrderHeader

--Challenge 2: Aggregate product sales
--The sales manager would like reports that include aggregated information about product sales.

--1. Retrieve total sales by product
--Write a query to retrieve a list of the product names from the SalesLT.Product table 
--and the total number of sales of each product, calculated as the sum of OrderQty from the 
--SalesLT.SalesOrderDetail table, with the results sorted in descending order of total sales.

SELECT prd.Name, ISNULL(SUM(sod.OrderQty), 0) AS [TotalSales]
FROM SalesLT.Product prd
LEFT JOIN SalesLT.SalesOrderDetail sod
	   ON prd.ProductID = sod.ProductID
GROUP BY prd.Name
ORDER BY [TotalSales] DESC

--2. Filter the product sales list to include only products that cost over 1,000
--Modify the previous query to include only sales of products that have a list price of more than 1000.

SELECT prd.Name, ISNULL(SUM(sod.OrderQty), 0) AS [TotalSales]
FROM SalesLT.Product prd
LEFT JOIN SalesLT.SalesOrderDetail sod
	   ON prd.ProductID = sod.ProductID
WHERE prd.ListPrice > 1000
GROUP BY prd.Name
ORDER BY [TotalSales] DESC

--3. Filter the product sales groups to include only products for which over 20 have been sold
--Modify the previous query to only include only product groups with a total order quantity greater than 20.

SELECT prd.Name, ISNULL(SUM(sod.OrderQty), 0) AS [TotalSales]
FROM SalesLT.Product prd
LEFT JOIN SalesLT.SalesOrderDetail sod
	   ON prd.ProductID = sod.ProductID
WHERE prd.ListPrice > 1000
GROUP BY prd.Name
HAVING ISNULL(SUM(sod.OrderQty), 0) > 20
ORDER BY [TotalSales] DESC

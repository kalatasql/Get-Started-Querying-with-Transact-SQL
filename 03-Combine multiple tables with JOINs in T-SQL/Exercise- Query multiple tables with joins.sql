--Query Multiple Tables with Joins

--Challenge 1: Generate invoice reports

--Adventure Works Cycles sells directly to retailers, who must be invoiced for their orders. You have been tasked 
--with writing a query to generate a list of invoices to be sent to customers.

--1. Retrieve customer orders

--As an initial step towards generating the invoice report, write a query that 
--returns the company name from the SalesLT.Customer table, and the purchase order number 
--and total due (calculated as the sub-total + tax + freight) 
--from the SalesLT.SalesOrderHeader table.

SELECT cm.CompanyName, so.PurchaseOrderNumber, (SubTotal + TaxAmt + Freight) AS TotalDue
FROM   SalesLT.Customer cm
INNER JOIN SalesLT.SalesOrderHeader so 
		ON cm.CustomerID = so.CustomerID 

--2. Retrieve customer orders with addresses

--Extend your customer orders query to include the Main Office address for each customer,
--including the full street address, city, state or province, postal code, and country or region

--Tip: Note that each customer can have multiple addressees in the SalesLT.Address table,
--so the database developer has created the SalesLT.CustomerAddress table to enable a many-to-many 
--relationship between customers and addresses. Your query will need to include both of these tables,
--and should filter the results so that only Main Office addresses are included.

SELECT cm.CompanyName, 
	   so.PurchaseOrderNumber, 
	   (so.SubTotal + so.TaxAmt + so.Freight) AS TotalDue,
	   a.AddressLine1 + ISNULL(' ' + AddressLine2, '') AS [Full Street Address], 
	   a.City,
	   a.StateProvince,
	   a.PostalCode,
	   a.CountryRegion
FROM   SalesLT.Customer cm
INNER JOIN SalesLT.SalesOrderHeader AS so 
		ON cm.CustomerID = so.CustomerID 
INNER JOIN SalesLT.CustomerAddress AS ca 
		ON cm.CustomerID = ca.CustomerID
INNER JOIN SalesLT.[Address] AS a 
		ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Main Office'

--Challenge 2: Retrieve customer data
--As you continue to work with the Adventure Works customer and sales data, 
--you must create queries for reports that have been requested by the sales team.

--1. Retrieve a list of all customers and their orders

--The sales manager wants a list of all customer companies and their contacts (first name and last name), 
--showing the purchase order number and total due for each order they have placed. Customers who have not 
--placed any orders should be included at the bottom of the list with NULL values for the purchase order number and total due.

SELECT c.CompanyName, 
	   c.FirstName, 
	   c.LastName, 
	   so.PurchaseOrderNumber, 
	  (so.SubTotal + so.TaxAmt + so.Freight) AS TotalDue
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.SalesOrderHeader AS so
	   ON c.CustomerID = so.CustomerID
ORDER BY PurchaseOrderNumber DESC, TotalDue DESC

--2. Retrieve a list of customers with no address
--A sales employee has noticed that Adventure Works does not have address information 
--for all customers. You must write a query that returns a list of customer IDs, company names,
--contact names (first name and last name), and phone numbers for customers with no address stored in the database.

SELECT c.CustomerID, c.CompanyName, c.FirstName, c.LastName, c.Phone
FROM   SalesLT.Customer AS c
LEFT JOIN SalesLT.CustomerAddress ca 
	   ON c.CustomerID = ca.CustomerID
WHERE ca.AddressID IS NULL

--Challenge 3: Create a product catalog

--The marketing team has asked you to retrieve data for a new product catalog.

--1. Retrieve product information by category

--The product catalog will list products by parent category and subcategory, 
--so you must write a query that retrieves the parent category name,
--subcategory name, and product name fields for the catalog.

SELECT ppc.Name AS ParentCategoryName, pc.Name as SubCategoryName, p.Name AS ProductName
FROM [SalesLT].[ProductCategory] AS pc
INNER JOIN SalesLT.ProductCategory AS ppc 
		ON pc.ParentProductCategoryID = ppc.ProductCategoryID
INNER JOIN SalesLT.[Product] AS p
		ON pc.ProductCategoryID = p.ProductCategoryID
ORDER BY ParentCategoryName, SubCategoryName, ProductName;

--Challenge 1: Retrieve customer data

--1. Retrieve customer details
--Familiarize yourself with the SalesLT.Customer table by writing a Transact-SQL query that retrieves all columns for all customers.

SELECT * 
FROM SalesLT.Customer;

--2. Retrieve customer name data
--Create a list of all customer contact names that includes the title, first name, middle name (if any), last name, and suffix (if any) of all customers.

SELECT [Title], 
       [FirstName], 
       [MiddleName], 
       [LastName], 
       [Suffix] 
FRom SalesLT.Customer;

--3. Retrieve customer names and phone numbers
--Each customer has an assigned salesperson. You must write a query to create a call sheet that lists:
--The salesperson
--A column named CustomerName that displays how the customer contact should be greeted (for example, Mr Smith)
--The customer’s phone number.

SELECT [Salesperson],  
        ISNULL(Title + ' ', '') + LastName AS CustomerName,
       [Phone]
FROM SalesLT.Customer;

--Challenge 2: 

-- 1. Retrieve customer order data
--You have been asked to provide a list of all customer companies 
--in the format Customer ID : Company Name - for example, 78: Preferred Bikes.

SELECT CONVERT(VARCHAR, CustomerID) + ': ' + CompanyName AS [Customer ID and Company]
FROM SalesLT.Customer

-- 2. Retrieve a list of sales order revisions
-- The SalesLT.SalesOrderHeader table contains records of sales orders. You have been asked to retrieve data for a report that shows:
-- The purchase order number and revision number in the format * ()* – for example *PO348186287 (2)*.
-- The order date converted to ANSI standard 102 format (yyyy.mm.dd – for example 2015.01.31).

SELECT 
	  '*' + PurchaseOrderNumber + ' (' + CAST([RevisionNumber] AS NVARCHAR(10)) + ')*' AS [Purchase Order and revision number],
	  CONVERT(NVARCHAR(30), OrderDate, 102) AS [Formatted Order Date] 
FROM SalesLT.SalesOrderHeader

--Challenge 3: Retrieve customer contact details
--Some records in the database include missing or unknown values that are returned as NULL. 
--You must create some queries that handle these NULL values appropriately.

--1. Retrieve customer contact names with middle names if known
--You have been asked to write a query that returns a list of customer names. 
--The list must consist of a single column in the format first last 
--(for example Keith Harris) if the middle name is unknown, 
--or first middle last (for example Jane M. Gates) if a middle name is known.

SELECT FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName  AS [Customer Name]
FROM SalesLT.Customer

--2. Retrieve primary contact details
--Customers may provide Adventure Works with an email address,
--a phone number, or both. If an email address is available, 
--then it should be used as the primary contact method; if not, 
--then the phone number should be used. 
--You must write a query that returns a list of customer IDs in one column,
--and a second column named PrimaryContact that contains the email address if known, and otherwise the phone number.

SELECT CustomerID,
       COALESCE(EmailAddress, Phone) AS [PrimaryContact]
FROM SalesLT.Customer

--IMPORTANT: In the sample data provided, there are no customer records without an email address. 
--Therefore, to verify that your query works as expected, 
--run the following UPDATE statement to remove some existing email addresses before creating your query:

UPDATE SalesLT.Customer
SET EmailAddress = NULL
WHERE CustomerID % 7 = 1;

--3. Retrieve shipping status
--You have been asked to create a query that returns a list of sales order 
--IDs and order dates 
--with a column named ShippingStatus that contains the text Shipped for orders with a known ship date, 
--and Awaiting Shipment for orders with no ship date.

SELECT [SalesOrderID], 
	   [OrderDate], 
	   [DueDate], 
	   [ShipDate],
	   (CASE 
		WHEN (ShipDate IS NOT NULL) THEN 'Shipped'
		ELSE 'Awaiting Shipment'
	    END) AS ShippingStatus
FROM SalesLT.SalesOrderHeader

--IMPORTANT: In the sample data provided, there are no sales order header records without a ship date. 
--Therefore, to verify that your query works as expected, 
--run the following UPDATE statement to remove some existing ship dates before creating your query.

UPDATE SalesLT.SalesOrderHeader
SET ShipDate = NULL
WHERE SalesOrderID > 71899;

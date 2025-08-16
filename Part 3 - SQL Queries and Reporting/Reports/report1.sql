--------------------------------------------------------------------------------
-- CPRG 250 Project 2
--Author: Joao Santiago
--Name: Report 1
--Description: Find all customers that live in Calgary
--Concepts: Single row functions(Concat) and data filtering (Where)
--------------------------------------------------------------------------------

--Select relevant columns
SELECT 
	customer_id, 
	CONCAT(customer_first_name, ' ', customer_last_name) AS "Customer Name", 
	customer_email, 
	city
--From customers table
FROM customers
--Only return customers living in calgary
WHERE city = 'Calgary'
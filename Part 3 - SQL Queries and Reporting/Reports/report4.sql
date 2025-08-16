--------------------------------------------------------------------------------
-- CPRG 250 Project 2
--Author: Joao Santiago
--Name: Report 4 
--Description: For each city, find number of rentals, total spent
--Concepts: Data aggregation(Count, Sum), Combining Tables(Join), Grouping, Sorting data(Order By) 
--------------------------------------------------------------------------------

--Select relevant information
SELECT 
	city,
	COUNT(rental_id) AS "Total Rentals",  --Total number of rentals
	SUM(rental_amount) AS "Total Spent"   --Total amount spent
FROM CUSTOMERS c
JOIN rentals USING (customer_id)
GROUP BY c.city
ORDER BY "Total Rentals" DESC, city


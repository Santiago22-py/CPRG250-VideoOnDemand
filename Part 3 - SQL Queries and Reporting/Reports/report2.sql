--------------------------------------------------------------------------------
-- CPRG 250 Project 2
--Author: Joao Santiago
--Name: Report 2
--Description: Find all movies rented by customers living in calgary
--Concepts: Combining data (Joins) and Restricting/Ordering(Where, Order By)
--------------------------------------------------------------------------------

--Select relevant columns
SELECT 
	city,
	CONCAT(customer_first_name, ' ', customer_last_name) AS "Customer Name",
	title,
	date_rented
FROM CUSTOMERS
--Join with rentals and movie tables to get the date the movies were rented and the name of the movies
JOIN rentals USING(customer_id)
JOIN movies  USING(movie_id)
WHERE city = 'Calgary'
--Order by the movie title and customer name in alphabetical order
ORDER BY title, "Customer Name"
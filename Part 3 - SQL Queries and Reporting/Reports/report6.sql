--------------------------------------------------------------------------------
-- CPRG 250 Project 2
--Author: Joao Santiago
--Name: Report 5
--Description: Find the most rented movie
--Concepts: Queries within queries (subquery), Aggregating data (MAX), Combining data(Joins), Grouping (Group By), Restricting data(Having)
--------------------------------------------------------------------------------

SELECT 
	title AS "Movie",
	--Count the amount of times the movie has been rented
	COUNT(CONCAT(customer_first_name, ' ', customer_last_name)) as "Times rented"
FROM movies
JOIN rentals USING (movie_id)
JOIN customers USING (customer_id)
GROUP BY title --Groups by the movie title so each row is one movie
HAVING COUNT(CONCAT(customer_first_name, ' ', customer_last_name)) = (
	--Finds the biggest number from the inner inner query
	SELECT MAX("grand total")
	FROM
		(SELECT COUNT(CONCAT(customer_first_name, ' ', customer_last_name)) AS "grand total"
		FROM
			movies
			JOIN rentals   USING (movie_id)
			JOIN customers USING(customer_id)
			GROUP BY title --Same as before
		)
);



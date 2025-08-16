--------------------------------------------------------------------------------
-- CPRG 250 Project 2
--Author: Joao Santiago
--Name: Report 5
--Description: Find the most expensive hd price for each category, excluding subcategories
--Concepts: Queries within queries (subquery), Aggregating data (MAX), Combining data(Joins), Ordering(Order By)
--------------------------------------------------------------------------------

--Select the three relevant columns
SELECT
  category_name,
  title,
  hd_price
FROM category c1

--Join with movies table using the bridging table
JOIN moviescategory USING (category_id)
JOIN movies         USING (movie_id)

--Only take the max value for each category
WHERE hd_price = (
	--Subquery to find the maximum price for each category
	SELECT MAX(hd_price)
	FROM moviescategory mc1
	JOIN movies USING(movie_id)
	WHERE mc1.category_id = c1.category_id --Makes the connection between the inner and outer query
		AND c1.parent_category_id ISNULL --Only take parent categories
)
ORDER BY(hd_price) DESC --Order by most expensive to cheapest

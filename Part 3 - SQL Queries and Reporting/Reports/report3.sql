--------------------------------------------------------------------------------
-- CPRG 250 Project 2
--Author: Joao Santiago
--Name: Report 3
--Description: Find how many movies were rented per year
--Concepts: Single row functions (Coalesce), data aggregation (Count, GroupBy) and Analytical Queries(Rollup)
--------------------------------------------------------------------------------

--Select relevant columns and information
SELECT 
	--If cell is null (rollup row), return "Grand total"
    COALESCE(EXTRACT(YEAR FROM date_rented) || '', 'Grand Total') AS "Year", --The concatenation ensures the type of the column is text
    COUNT(rental_id) AS "Total Rentals" -- Counts total number of rentals for that year
FROM rentals
GROUP BY ROLLUP (EXTRACT(YEAR FROM date_rented)) -- Groups by year and adds a summary row(containing total rentals)
ORDER BY EXTRACT(YEAR FROM date_rented) -- Orgers by year in ascending order
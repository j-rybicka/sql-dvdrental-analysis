-- List movies that:
-- a) are rated PG or PG-13;
-- b) have a running time between 95 and 130 minutes;
-- c) do not contain the word “boring” in their description.

SELECT rating, length, title, description
FROM film
WHERE (rating = 'PG' OR rating = 'PG-13') 
AND length BETWEEN 95 AND 130 
AND LOWER(description) NOT LIKE '%boring%'
;
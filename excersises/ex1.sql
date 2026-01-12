-- Wypisz filmy, które: 
-- a) mają rating PG lub PG-13; 
-- b) czas trwania jest pomiędzy 95 a 130 minut 
-- c) nie zawierają w opisie (description) słowa “boring”

SELECT rating, length, title, description
FROM film
WHERE (rating = 'PG' OR rating = 'PG-13') 
AND length BETWEEN 95 AND 130 
AND LOWER(description) NOT LIKE '%boring%'
;
-- Find categories of movies in which no movie is longer than 180 minutes.

SELECT category_id, COUNT(title) as movies, AVG(length) as avg_length, MAX(length) as max_length
FROM film_category
INNER JOIN film
ON film_category.film_id=film.film_id
GROUP BY category_id
HAVING MAX(length) <= 180
ORDER BY MAX(length) ASC
;
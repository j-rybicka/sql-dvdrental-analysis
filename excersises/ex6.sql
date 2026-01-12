-- Znajdź aktorów, którzy nie grali w żadnym filmie z kategorii Horror
SELECT first_name, last_name
FROM actor
INNER JOIN film_actor
ON film_actor.actor_id=actor.actor_id
INNER JOIN film
ON film_actor.film_id=film.film_id
INNER JOIN film_category
ON film.film_id=film_category.film_id
INNER JOIN category
ON category.category_id=film_category.category_id
GROUP BY first_name, last_name 
HAVING EVERY(name != 'Horror')
;
-- Znajdź filmy, które były wypożyczane wyłącznie za cenę ≤ 2.99
SELECT title, MAX(amount) as max_payment_amount, AVG(amount) as avg_payment_amount
FROM payment
INNER JOIN rental
ON payment.rental_id=rental.rental_id
INNER JOIN inventory
ON rental.inventory_id=inventory.inventory_id
INNER JOIN film
ON inventory.film_id=film.film_id
GROUP BY title
HAVING EVERY(amount <= 2.99)
ORDER BY 1

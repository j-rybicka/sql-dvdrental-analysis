-- Znajdź klientów, którzy nigdy nie mieli adresu e-mail kończącego się na .org
SELECT customer_id
FROM customer
GROUP BY customer_id
HAVING EVERY(email NOT LIKE '%.org')
;
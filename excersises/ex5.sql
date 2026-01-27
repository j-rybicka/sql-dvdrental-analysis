-- Find customers who have never had an email address ending in .org
SELECT customer_id
FROM customer
GROUP BY customer_id
HAVING EVERY(email NOT LIKE '%.org')
;
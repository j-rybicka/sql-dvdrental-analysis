-- We are looking for suspicious rentals...
-- Find rentals for which:
-- the rental lasted ≤ 3 days
-- if it lasted > 3 days, it must have an amount paid ≥ 4.99

SELECT rental.rental_id, rental_date, return_date, amount, EXTRACT(DAY FROM return_date-rental_date) as rental_duration_days, 
CASE
	WHEN EXTRACT(DAY FROM return_date-rental_date) <= 3 THEN 'fraud'
	WHEN EXTRACT(DAY FROM return_date-rental_date) > 3 AND amount >= 4.99 THEN 'fraud'
	WHEN return_date IS NULL THEN 'not returned'
	ELSE 'ok'
END as rental_label
FROM rental
INNER JOIN payment
ON rental.rental_id=payment.rental_id
WHERE CASE
	WHEN EXTRACT(DAY FROM return_date-rental_date) <= 3 THEN 'fraud'
	WHEN EXTRACT(DAY FROM return_date-rental_date) > 3 AND amount >= 4.99 THEN 'fraud'
	WHEN return_date IS NULL THEN 'not returned'
	ELSE 'ok'
END IN ('fraud')
-- Znajdź wypożyczenia, które: 
-- a) zostały dokonane między 22:00 a 05:00 
-- b) nie zostały jeszcze zwrócone

-- 0,1,2,3,4,5,6,7,8,9,.....,20,21,22,23
-- XXXXXXXXXXX                     XXXXX

SELECT rental_date, EXTRACT(HOUR FROM rental_date)
FROM rental
WHERE 
(EXTRACT(HOUR FROM rental_date) >= 22 OR EXTRACT(HOUR FROM rental_date) < 5) OR 
(EXTRACT(HOUR FROM rental_date) = 5 AND EXTRACT(MINUTE FROM rental_date) = 0)
;
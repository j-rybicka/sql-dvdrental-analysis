--Dla każdego filmu wyświetl:
-- tytuł
-- długość filmu
-- kolumnę length_label, która:
	-- przyjmuje wartość 'short', jeśli film trwa < 90 minut
	-- 'medium', jeśli trwa od 90 do 120 minut
	-- 'long', jeśli trwa > 120 minut

SELECT title, length, CASE
    WHEN length < 90 THEN 'short'
    WHEN length BETWEEN 90 AND 120 THEN 'medium'
    WHEN length > 120 THEN 'long'
END as length_label
FROM film
;
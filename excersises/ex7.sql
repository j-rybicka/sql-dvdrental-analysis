--For each movie, display:
-- title
-- movie length
-- length_label column, which:
    -- takes the value ‘short’ if the movie is < 90 minutes long
    -- ‘medium’ if it is between 90 and 120 minutes long
    -- ‘long’ if it is > 120 minutes long

SELECT title, length, CASE
    WHEN length < 90 THEN 'short'
    WHEN length BETWEEN 90 AND 120 THEN 'medium'
    WHEN length > 120 THEN 'long'
END as length_label
FROM film
;
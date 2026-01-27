# DVD Rental Data Analysis

## Task 1 - Popular Genres

### Problem
What are the most and least rented genres, and what are their total sales?

### Solution

```sql
SELECT category.name as category, COUNT(*) as total_rentals, SUM(amount) as payment_amount
FROM payment
INNER JOIN rental
ON rental.rental_id = payment.rental_id
INNER JOIN inventory
ON inventory.inventory_id = rental.inventory_id
INNER JOIN film
ON inventory.film_id=film.film_id
INNER JOIN film_category
ON film.film_id=film_category.film_id
INNER JOIN category
ON film_category.category_id=category.category_id
GROUP BY category.category_id, name
ORDER BY COUNT(*)
;
```

### Results

|"category"|"total_rentals"|"payment_amount"|
|-|-|-|
|Music|750|3071.52|
|Travel|765|3227.36|
|Horror|773|3401.27|
|Comedy|851|4002.48|
|Classics|860|3353.38|
|Children|861|3309.39|
|New|864|3966.38|
|Games|884|3922.18|
|Documentary|937|3749.65|
|Foreign|953|3934.47|
|Drama|953|4118.46|
|Family|988|3830.15|
|Sci-Fi|998|4336.01|
|Action|1013|3951.84|
|Animation|1065|4245.31|
|Sports|1081|4892.19|

### Insights
The most frequently rented film genre is “Sports,” which customers rented 1,081 times, spending a total of $4,892.19. In second place is the “Animation” genre, with 1,065 rentals and total revenue of $4,245.31. We can see that despite fewer rentals, the “Comedy” genre earned a total of $4,002.48, which accounts for 80% of animated film rentals and 94% of their revenue. Films in the “Music” category rank last in popularity with a total of 750 rentals, and are also the least profitable, generating $3,071.52 in revenue.

Based on the above, a decision could be made to increase the price of animated films. I would also suggest launching a marketing campaign to which we could invite people from the music industry, which would encourage fans to rent films from the “Music” category.


-----------------


## Task 2 - Preferred genres

### Problem
Can we find out how many different users rented each genre?

### Solution

```sql
SELECT category.name as category, COUNT(DISTINCT rental.customer_id) as unique_customers
FROM payment
INNER JOIN rental
ON rental.rental_id = payment.rental_id
INNER JOIN inventory
ON inventory.inventory_id = rental.inventory_id
INNER JOIN film
ON inventory.film_id=film.film_id
INNER JOIN film_category
ON film.film_id=film_category.film_id
INNER JOIN category
ON film_category.category_id=category.category_id
GROUP BY category.category_id, name
ORDER BY 2 DESC
;
```

### Results
|"category"|"unique_customers"|
|-|-|
|Sports|507|
|Action|498|
|Sci-Fi|490|
|Animation|480|
|Comedy|477|
|Foreign|476|
|Drama|475|
|Family|475|
|Documentary|465|
|Children|462|
|Games|456|
|Classics|450|
|New|446|
|Horror|436|
|Music|431|
|Travel|428|

### Insights
The largest number of customers can be classified as fans of the “Sports” genre. Not far behind are fans of the ‘Action’ genre. At the very bottom, we see that the “Travel” category has the smallest audience, even though it was not in last place in the rental popularity ranking.

-----------------




## Task 3 - Profitability of film categories

### Problem
What is the average rental rate for each species? (from highest to lowest)

### Solution

```sql
SELECT category.name as category, ROUND(AVG(rental_rate), 2) as avg_rental
FROM film
INNER JOIN film_category
ON film.film_id=film_category.film_id
INNER JOIN category
ON film_category.category_id=category.category_id
GROUP BY category.category_id, name
ORDER BY AVG(rental_rate) DESC
;
```

### Results
|"category"|"avg_rental"|
|-|-|
|Games|3.25|
|Travel|3.24|
|Sci-Fi|3.22|
|Comedy|3.16|
|Sports|3.13|
|New|3.12|
|Foreign|3.10|
|Horror|3.03|
|Drama|3.02|
|Music|2.95|
|Children|2.89|
|Animation|2.81|
|Family|2.76|
|Classics|2.74|
|Documentary|2.67|
|Action|2.65|

### Insights
We can see that the category “Games” has the highest average rental rate, at $3.25. The next few places in the ranking are relatively close in terms of average rental price. Nine out of 16 genres have an average rental price above $3. The cheapest are movies in the “Action” genre, and the price difference between the most expensive and cheapest genres is $0.60. 

-----------------


## Task 4 - On-time returns

### Problem
How many rented movies were returned late, early, and on time?

### Solution

```sql
-- option 1, three columns with category
SELECT 
rental_duration > EXTRACT(DAY FROM return_date-rental_date) as is_early,
rental_duration = EXTRACT(DAY FROM return_date-rental_date) as is_on_time,
rental_duration < EXTRACT(DAY FROM return_date-rental_date) as is_late,
COUNT(*) as total_returned_movies
FROM rental
INNER JOIN inventory
ON inventory.inventory_id = rental.inventory_id
INNER JOIN film
ON inventory.film_id=film.film_id
GROUP BY 1,2,3
;

-- option 2, CASE - conditions and text label assignment
SELECT 
CASE 
	WHEN rental_duration > EXTRACT(DAY FROM return_date-rental_date) THEN 'early'
	WHEN rental_duration = EXTRACT(DAY FROM return_date-rental_date) THEN 'on time'
	WHEN rental_duration < EXTRACT(DAY FROM return_date-rental_date) THEN 'late'
	WHEN return_date IS NULL THEN 'not_returned_yet'
	ELSE 'unknown'
END as category,
COUNT(*) as total_returned_movies
FROM rental
INNER JOIN inventory
ON inventory.inventory_id = rental.inventory_id
INNER JOIN film
ON inventory.film_id=film.film_id
GROUP BY 1
ORDER BY 2 DESC
;
```

### Results
|"category"|"total_returned_movies"|
|-|-|
|early|7738|
|late|6403|
|on time|1720|
|not_returned_yet|183|


### Insights
In this ranking, we can see that 1,720 customers returned their rented movies on time, while as many as 7,738 customers returned their movies before the maximum allowed return time. The number of customers who were late in returning their rented movies is 6,043. 183 movies have not yet been returned.

On this basis, we could impose higher fines on customers who do not return rented movies on time.
Rental stores could also conduct a survey among customers who return movies ahead of time to better understand the reason for the early return. Depending on the results, some movies could have their maximum rental period shortened, while others could be withdrawn from sale due to poor quality. To deal with customers who return movies after the deadline, a reward system for returning movies on time could be considered.

-----------------



## Task 5 - Sales coverage

### Problem
In which countries does our company operate, and what is the customer base in each of these countries?

What are the total sales in each country? (from largest to smallest)

### Author's notes
The people who defined the question did not clearly state what they meant by “activity” in the country, so I decided to consider three options:
- **A** - Sales based on the location of the rental place
- **B** - Sales based on the location of the customer
- **C** - Sales based on the location of the rental place and the customer (customers from which country rent from locations in which country)


### Solution A (location of the rental place)

```sql
SELECT country, SUM(amount) as total_sales, COUNT(*) as total_payments, COUNT(DISTINCT rental.customer_id) as unique_customers, COUNT(DISTINCT staff.staff_id) as employees
FROM country
INNER JOIN city
ON country.country_id=city.country_id
INNER JOIN address
ON city.city_id=address.city_id
INNER JOIN store
ON address.address_id=store.address_id
INNER JOIN staff
ON store.store_id=staff.store_id
INNER JOIN rental
ON staff.staff_id=rental.staff_id
INNER JOIN payment
ON payment.rental_id=rental.rental_id
GROUP BY country
ORDER BY SUM(amount) desc
;
```

### Results A (location of the rental place)
|"country"|"total_sales"|"total_payments"|"unique_customers"|"employees"|
|-|-|-|-|-|
|Australia|30813.33|7265|599|1|
|Canada|30498.71|7331|599|1|




### Solution B (location of the customer)

```sql
SELECT country, SUM(amount) as total_sales, COUNT(*) as total_payments, COUNT(DISTINCT customer.customer_id) as unique_customers
FROM customer
INNER JOIN address
ON customer.address_id=address.address_id
INNER JOIN city
ON address.city_id=city.city_id
INNER JOIN country
ON city.country_id=country.country_id
INNER JOIN rental
ON customer.customer_id=rental.customer_id
INNER JOIN payment
ON rental.rental_id=payment.rental_id
GROUP BY country
ORDER BY SUM(amount) desc
;
```

### Results B (location of the customer)
|"country"|"total_sales"|"total_payments"|"unique_customers"|
|-|-|-|-|
|India|6032.79|1421|60|
|China|5247.04|1296|53|
|United States|3694.27|873|36|
|Japan|3121.52|748|31|
|Mexico|2984.82|718|30|
|*100 countries omitted*|....|....|...|
|Afghanistan|67.82|18|1|
|Tonga|64.84|16|1|
|Saint Vincent and the Grenadines|64.82|18|1|
|Lithuania|63.78|22|1|
|American Samoa|47.85|15|1|


### Solution C (location of the rental place and the customer)

```sql
CREATE TEMPORARY TABLE customer_countries_store_countries AS
SELECT country, customer_country, SUM(amount) as total_sales, COUNT(*) as total_payments, COUNT(DISTINCT rental.customer_id) as unique_customers
FROM country
INNER JOIN city
ON country.country_id=city.country_id
INNER JOIN address
ON city.city_id=address.city_id
INNER JOIN store
ON address.address_id=store.address_id
INNER JOIN staff
ON store.store_id=staff.store_id
INNER JOIN rental
ON staff.staff_id=rental.staff_id
INNER JOIN payment
ON payment.rental_id=rental.rental_id
INNER JOIN (
	SELECT rental_id, customer.customer_id, country as customer_country
	FROM customer
	INNER JOIN address
	ON customer.address_id=address.address_id
	INNER JOIN city
	ON address.city_id=city.city_id
	INNER JOIN country
	ON city.country_id=country.country_id
	INNER JOIN rental
	ON customer.customer_id=rental.customer_id
) as client_rental
ON client_rental.rental_id = rental.rental_id
GROUP BY country, customer_country
ORDER BY SUM(amount) desc;
```

### Results C (location of the rental place and the customer)

|"country"|"customer_country"|"total_sales"|"total_payments"|"unique_customers"|
|-|-|-|-|-|
|Australia|India|3140.57|743|60|
|Canada|India|2892.22|678|60|
|Australia|China|2630.59|640|53|
|Canada|China|2616.45|656|53|
|*100 countries omitted*|...|...|...|...|...|
|Australia|American Samoa|22.93|7|1|
|Canada|Nepal|20.96|4|1|
|Australia|Tunisia|20.94|6|1|
|Canada|Saint Vincent and the Grenadines|13.94|6|1|


### Additional questions to option C (location of the rental place and the customer)
1) Is there any country where the number of unique customers varies between rental locations? 
```sql
SELECT c1.customer_country as customer_coutry, c1.country as kraj1, c2.country as kraj2, c1.unique_customers as uc_kraj1, c2.unique_customers as uc_kraj2
FROM customer_countries_store_countries as c1
INNER JOIN customer_countries_store_countries as c2
ON c1.customer_country = c2.customer_country AND c1.country != c2.country AND c1.country > c2.country
WHERE c1.unique_customers != c2.unique_customers
;
```
2) Is there a country where customers would only rent from one location?
```sql
SELECT customer_country, count(*), ARRAY_AGG(country)
FROM customer_countries_store_countries
GROUP BY 1
HAVING count(*) = 1
;

```


### Insights
1. Analyzing sales in the context of rental location, we can easily see that revenues in Australia ($30,813.33) are higher than in Canada ($30,498.71) – the difference in revenue between these countries is less than $314.62, or 1%. In total, movies worth $61,312.04 were rented in both countries. The number of transactions is similar for both countries, but Canada had more transactions despite lower overall revenue. Rental stores in both countries have 599 customers and 1 employee each.


2. The highest number of rentals was recorded among customers from India, where we have 60 individual customers who made 1,421 payments for a total of $6,032.79. The Chinese rent almost as much as the Indians, which puts them in second place in the ranking. Customers from the United States came in third, with significantly fewer rentals and customers, which translated into total sales of $3,694.27. Comparing the top 5 countries, we can conclude that revenue is correlated with the number of unique customers - 60 customers means revenue of around $60k, and 36 customers means approximately $36k.
Customers from American Samoa and Lithuania were at the bottom of the ranking, with one customer each and $47 and $64 in sales, respectively.


3. Sales results when analyzed in terms of rental location and customer location are relatively similar to those in variant B (customer location analysis) – once again, customers from India and China are at the top of the ranking, while customers from American Samoa and Saint Vincent and the Grenadines are at the bottom. <br>It is clear that we have exactly the same number of unique customers in each country, and customers from no country rented from only one location. This is evident from the answers to the additional questions for variant C. <br>There is no significant difference in sales and the number of transactions between the two rental locations when looking at each customer country. In fact, this indicates a similar distribution of data in the prepared set - transactions were distributed so that each customer rented almost equally from each store.


-----------------


## Task 6 - Best customers

### Problem
Who are the top 5 customers in terms of total sales, and can we get their details in case the company wants to reward them?

### Solution

```sql
CREATE TEMPORARY TABLE top_5_customers as 
SELECT customer.customer_id, SUM(amount) as total_sales
FROM customer
INNER JOIN rental
ON customer.customer_id=rental.customer_id
INNER JOIN payment
ON rental.rental_id=payment.rental_id
GROUP BY customer.customer_id
ORDER BY SUM(amount) desc
LIMIT 5
;

SELECT first_name, last_name, total_sales, email, postal_code ||' ' || city || ', '|| address as postal_address
FROM top_5_customers
INNER JOIN customer
ON customer.customer_id=top_5_customers.customer_id
INNER JOIN address
ON customer.address_id=address.address_id
INNER JOIN city
ON address.city_id=city.city_id
;
```

### Results
|"first_name"|"last_name"|"total_sales"|"email"|"postal_address"|
|-|-|-|-|-|
|Eleanor|Hunt|211.55|eleanor.hunt@sakilacustomer.org|92150 Saint-Denis, 1952 Pune Lane|
|Karl|Seal|208.58|karl.seal@sakilacustomer.org|31342 Cape Coral, 1427 Tabuk Place|
|Marion|Snyder|194.61|marion.snyder@sakilacustomer.org|47288 Santa Brbara dOeste, 1891 Rizhao Boulevard|
|Rhonda|Kennedy|191.62|rhonda.kennedy@sakilacustomer.org|11044 Apeldoorn, 1749 Daxian Place|
|Clara|Shaw|189.60|clara.shaw@sakilacustomer.org|30861 Molodetno, 1027 Songkhla Manor|

### Insights
The address details of the five customers who spent the most on movie rentals were presented. <br>The customer who spent the most ($211.55) is Eleanor Hunt from Saint-Denis. In second place is Karl Seal from Cape Coral, who spent just $3 less than Eleanor ($208.58). With $189.6 spent, Clara Shaw from Molodetno came in fifth place.

-----------------


## Task 7 - Customer segments

### Problem
DVD Rental wants to better understand its customers in order to:
 * identify its most valuable customers,
 * find active customers who generate low revenue,
 * lay the groundwork for future marketing campaigns.

Your task is to prepare a customer segmentation analysis based on historical data.

For each customer:
1. calculate their activity (number of rentals),
2. calculate their financial value (total amount paid),
3. assign them to a simple business segment.

Show how many customers we have in each segment.


### Notes
Definition of segments:
* **VIP** - more than 30 rentals and total payments > $150
* **Regular** - 10-30 rentals
* **Occasional** - less than 10 rentals
* **High activity / low value** - more than 20 rentals and total payments < $100



### Solution

```sql
-- performing aggregation for the customer
CREATE TEMPORARY TABLE customer_stats as
SELECT customer.customer_id, first_name, last_name, COUNT(rental.rental_id) as rentals, SUM(amount) as total_payment
FROM customer
INNER JOIN rental
ON customer.customer_id=rental.customer_id
INNER JOIN payment
ON rental.rental_id=payment.rental_id
GROUP BY customer.customer_id, first_name, last_name
;

-- customer segmentation
CREATE TEMPORARY TABLE customers_segments as
SELECT customer_id, first_name, last_name, rentals, total_payment, CASE
WHEN total_payment > 150 AND rentals > 30 THEN 'VIP'
WHEN rentals BETWEEN 10 AND 30 THEN 'Regular'
WHEN rentals < 10 THEN 'Occasional'
WHEN rentals > 20 AND total_payment < 100 THEN 'High activity/low value'
END as segments
FROM customer_stats
;

-- we group the results to view segments
SELECT segments, COUNT(*)
FROM customers_segments
GROUP BY segments
ORDER BY COUNT(*) desc;

-- let's look at customers who haven't assigned themselves to any group
SELECT *
FROM customers_segments
WHERE segments IS NULL
LIMIT 5;
```

### Results
|"segments"|"count"|
|-|-|
|Regular|531|
|null|47|
|VIP|19|
|Occasional|1|
|High activity/low value|1|

<br><br>
**Customers not assigned to any segment:**

|"customer_id"|"first_name"|"last_name"|"rentals"|"total_payment"|"segments"|
|-|-|-|-|-|-|
|406|Nathan|Runyon|31|121.69|null|
|576|Morris|Mccarter|32|135.68|null|
|390|Shawn|Heaton|31|142.69|null|
|257|Marsha|Douglas|34|142.66|null|
|125|Ethel|Webb|31|131.69|null|



### Early conclusions
1. 47 customers do not belong to the segment, but they are apparently active customers who have not yet achieved VIP status but are no longer Regular. 
<br/>Possible solutions:
   * change the range for the ‘High activity/low value’ segment and increase the payment amount to $150.
   * add another segment, but this does not seem to make sense because there are few customers (1) in the ‘High activity/low value’ group
2. the small number of customers in the ‘High activity/low value’ segment may be due to the order in CASE, which means that they are classified as Regular based on the number of rentals, because the conditions of these segments have a common part.
    * Possible solution - change the priority of the assignment rules to segments so that ‘High activity/low value’ is higher than Regular.


### Improved solution
```sql
DROP TABLE IF EXISTS customers_segments;
CREATE TEMPORARY TABLE customers_segments as
SELECT customer_id, first_name, last_name, rentals, total_payment, CASE
WHEN total_payment > 150 AND rentals > 30 THEN 'VIP'
WHEN rentals > 20 AND total_payment <= 150 THEN 'High activity/low value'
WHEN rentals BETWEEN 10 AND 30 THEN 'Regular'
WHEN rentals < 10 THEN 'Occasional'
END as segments
FROM customer_stats
;

-- recounting segments
SELECT segments, COUNT(*)
FROM customers_segments
GROUP BY segments
ORDER BY COUNT(*) desc;
```

### Revised results
|"segments"|"count"|
|-|-|
|High activity/low value|440|
|Regular|139|
|VIP|19|
|Occasional|1|

### Insights
After introducing changes to the rule for assigning customers to segments, i.e., raising the priority for the “High activity/low value” segment and increasing the limit for the total payments in that segment, it can be seen that it has become the most numerous segment.
<br> Among the renters, there are 19 VIPs, 440 customers with high activity but without high revenues, 139 regular customers, and 1 occasional customer.
<br> The distribution of high-ranking customers (‘High activity/low value’ and ‘VIP’) seems too high, while there are few low-activity customers (‘Occasional’). This may indicate a need to modify the rules for assigning customers to segments so that the most numerous group of customers are Occasional or Regular, and the two groups indicating high customer value are not so easily accessible.


-----------------



## Task 8 – Movie Effectiveness

### Problem
**Business need**:
<br/>The team wants to identify movies that are rented frequently but generate relatively low revenue
in order to consider price changes or promotions.

**Expectations:** <br>
- movie title
- number of rentals
- total payment amount
- average payment amount per rental

**Additional information:**
<br>
The analysis should only include movies that have been rented at least 10 times to avoid random cases.

### Solution

```sql
SELECT title, COUNT(*) as total_rentals, SUM(amount) as total_payment_amount, ROUND(AVG(amount), 2) as avg_payment_amount
FROM payment
INNER JOIN rental
ON rental.rental_id = payment.rental_id
INNER JOIN inventory
ON rental.inventory_id = inventory.inventory_id
INNER JOIN film
ON inventory.film_id = film.film_id
GROUP BY title
HAVING COUNT(*) >= 10
ORDER BY 4 ASC
LIMIT 10
;
```

### Results
|"title"|"total_rentals"|"total_payment_amount"|"avg_payment_amount"|
|-|-|-|-|
|Smoking Barbarella|17|17.84|1.05|
|Spirit Flintstones|14|14.86|1.06|
|Silence Kane|15|15.85|1.06|
|Hollywood Anonymous|13|13.87|1.07|
|Greedy Roots|13|14.87|1.14|
|Bride Intrigue|18|20.82|1.16|
|Kane Exorcist|12|13.88|1.16|
|Jedi Beneath|18|20.82|1.16|
|Wolves Desire|21|24.79|1.18|
|Clockwork Paradise|10|11.90|1.19|


### Alternative solution
```sql
SELECT title, COUNT(*) as total_rentals, SUM(amount) as total_payment_amount, ROUND(AVG(amount), 2) as avg_payment_amount, ROUND(( SUM(amount)/COUNT(*) ) * (1 / ln(1+ COUNT(*))), 3) as score
FROM payment
INNER JOIN rental
ON rental.rental_id = payment.rental_id
INNER JOIN inventory
ON rental.inventory_id = inventory.inventory_id
INNER JOIN film
ON inventory.film_id = film.film_id
GROUP BY title
ORDER BY 5 ASC
LIMIT 10
;
```

### Alternative results
|"title"|"total_rentals"|"total_payment_amount"|"avg_payment_amount"|"score"|
|-|-|-|-|-|
|Smoking Barbarella|17|17.84|1.05|0.363|
|Silence Kane|15|15.85|1.06|0.381|
|Wolves Desire|21|24.79|1.18|0.381|
|Spirit Flintstones|14|14.86|1.06|0.391|
|Jedi Beneath|18|20.82|1.16|0.392|
|Bride Intrigue|18|20.82|1.16|0.392|
|Shepherd Midsummer|23|28.77|1.25|0.393|
|Roman Punk|21|25.79|1.23|0.397|
|Dracula Crystal|19|22.81|1.20|0.400|
|Hollywood Anonymous|13|13.87|1.07|0.404|


### Insights
The least profitable film was “Smoking Barbarella,” which was rented 17 times and cost customers an average of $1.05.
The 10 least profitable films were rented for approximately $1.


The basic measure used to calculate profitability was the arithmetic mean, which had to be reinforced by a minimum number of rentals (empirically set at 10). Alternatively, I used a weight that imposed a penalty on the average in the case of a small number of rentals - this favored films with low average revenue but a higher number of rentals (no need to filter the data).


In both cases, the list of films is very similar, but differs in terms of their position on the list. Each of the selected films could have a higher price because there is demand for them, but customers do not pay as much as they could.


-----------------



## Task 9 – Operationally problematic movies

### Problem
**Business need**:
<br/>The operations team wants to identify movies that are often not returned on time.

**Expectations:** <br>
Return a list of movies with:
- title
- total number of rentals
- number of rentals lasting longer than 7 days
- percentage of such rentals

**Additional information:**
<br>
Only movies that have been rented more than 5 times are of interest.


### Solution

```sql
-- simple aggregations
CREATE TEMPORARY TABLE film_rentalsa as
SELECT title, COUNT(*) as total_rental, SUM(
CASE
WHEN EXTRACT(DAY FROM return_date-rental_date) > 7 THEN 1
ELSE 0
END) as longer_than_7_days
FROM film
INNER JOIN inventory
ON film.film_id = inventory.film_id
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id
GROUP BY title
HAVING COUNT(*) > 5;

-- calculation of the percentage share
SELECT title, total_rental, longer_than_7_days, ROUND(100*(longer_than_7_days/(total_rental*1.0)), 2) as ratio
FROM film_rentals
ORDER BY (longer_than_7_days/(total_rental*1.0)) desc
;
```

### Results
|"title"|"total_rental"|"longer_than_7_days"|"ratio"|
|-|-|-|-|
|Reds Pocus|9|5|55.56|
|Gilbert Pelican|9|5|55.56|
|Crusade Honey|8|4|50.00|
|Notorious Reunion|14|7|50.00|
|Smile Earring|10|5|50.00|
|936 wierszy|...|...|...|
|School Jacket|6|0|0.00|
|Won Dares|9|0|0.00|
|Youth Kick|6|0|0.00|
|Jawbreaker Brooklyn|10|0|0.00|
|Lights Deer|8|0|0.00|

### Insights

We can see that the highest percentage of rentals lasting longer than a week are for the films “Reds Pocus” and “Gilbert Pelican”—these films are kept in 55% of rentals. There are also films that have never been returned after a week, such as “Lights Deer” and “Won Dares”.

Rental stores could conduct a survey among late customers to better understand why they decide to keep these specific titles—depending on the results for some films, a larger number of copies could be introduced.


-----------------





## Task 10 - Employee workload

### Problem
**Business need**:
<br/>The manager wants to check whether the workload is evenly distributed among employees.


**Expectations:** <br>
For each employee, return:
- first and last name
- total number of rentals handled
- number of unique customers
- average number of rentals per customer

**Additional information:**
<br>
The result should allow for a comparison of the workload between employees.



### Solution

```sql
SELECT staff.staff_id, COUNT(DISTINCT customer.customer_id) as unique_customers, COUNT(*) as total_rentals, ROUND(1.0*COUNT(*)/COUNT(DISTINCT customer.customer_id), 2) as rentals_per_customer
FROM staff
INNER JOIN rental
ON staff.staff_id = rental.staff_id
INNER JOIN customer
ON rental.customer_id = customer.customer_id
GROUP BY staff.staff_id
;
```

### Results
|"staff_id"|"unique_customers"|"total_rentals"|"rentals_per_customer"|
|-|-|-|-|
|1|599|8040|13.42|
|2|599|8004|13.36|

### Insights
In this analysis, we can see that the employees of the two stores have the same number of unique customers, while the total number and average number of rentals do not differ significantly.

In the case of employee number 1, we can see that the total number of rentals (8,040) is 0.5% higher than in the case of employee number 2 (8,004).

The workload among employees is evenly distributed and, in my opinion, too high—both rental companies should hire additional staff.


-----------------



## Task 11 – Customers with broad preferences

### Problem
**Business need:**<br>
The product team wants to identify customers with diverse movie tastes
who may be more open to recommendations.

**Expectations:**<br>
- customer ID
- first and last name
- number of different movie categories rented
- total number of rentals

**Additional information:**<br>
The goal is to find customers who regularly rent different types of movies.


### Solution

```sql
SELECT customer.customer_id, first_name, last_name, COUNT (DISTINCT name) as unique_genres, COUNT(*) as total_rentals,
ROUND(100.0*COUNT (DISTINCT name) / (SELECT COUNT (DISTINCT name) FROM category), 2) as percentage_of_watched_genres
FROM customer
INNER JOIN rental
ON customer.customer_id = rental.customer_id
INNER JOIN inventory
ON rental.inventory_id = inventory.inventory_id
INNER JOIN film
ON inventory.film_id = film.film_id
INNER JOIN film_category
ON film.film_id = film_category.film_id
INNER JOIN category
ON film_category.category_id = category.category_id
GROUP BY customer.customer_id, first_name, last_name
ORDER BY COUNT (DISTINCT name) desc
;
```

### Results
|"percentage_of_watched_genres"|"users"|"percentage_users"|
|-|-|-|
|100|19|3.17|
|<25;50)|1|0.17|
|<50;75)|100|16.69|
|<75;100)|479|79.97|

### Insights
As many as 599 customers regularly watch different types of films. The rental database contains 16 film genres.

Only 3% of customers have watched films from all available genres. For comparison, 16% have watched films from 50-75% of the available categories, and the vast majority, as many as 80%, have chosen films from almost the entire range of available genres.


-----------------




## Task 12 – Movie retention time

### Problem
**Business need:**<br>
The company wants to check which movies are most often retained longer than the expected rental period, which may affect the availability of the offer for other customers.

**Expectations:**<br>
For each movie, return:
- movie title
- average actual rental period (in days)
- expected rental period based on movie data
- difference between actual and expected periods

**Additional information:**<br>
The actual period should be calculated based on rental and return dates.
Only completed (returned) rentals are of interest.

### Solution

```sql
CREATE TEMPORARY TABLE actual_rental_durations as 
SELECT title, AVG(EXTRACT(DAY FROM return_date-rental_date)) as average_rental_duration
FROM rental
INNER JOIN inventory
ON rental.inventory_id = inventory.inventory_id
INNER JOIN film
ON inventory.film_id = film.film_id
WHERE return_date IS NOT NULL
GROUP BY title
;

SELECT film.title, ROUND(average_rental_duration, 2) as average_rental_duration, rental_duration, ROUND(average_rental_duration-rental_duration, 2) as diff
FROM film
INNER JOIN actual_rental_durations
ON film.title = actual_rental_durations.title
ORDER BY 4
;
```

### Results
|"title"|"average_rental_duration"|"rental_duration"|"diff"|
|-|-|-|-|
|Greedy Roots|2.57|7|-4.43|
|Texas Watch|2.67|7|-4.33|
|Bowfinger Gables|2.73|7|-4.27|
|Adaptation Holes|2.83|7|-4.17|
|License Weekend|3.00|7|-4.00|
|...|...|...|...|
|Tycoon Gathering|5.92|3|2.92|
|Hustler Party|5.95|3|2.95|
|Telegraph Voyage|5.96|3|2.96|
|Run Pacific|6.00|3|3.00|
|Mother Oleander|6.36|3|3.36|

### Insights
A summary of the timeliness of returned rentals was already made in an earlier task. It showed that most rentals are returned before the maximum allowed time.

On average, the longest-held movie is “Mother Oleander,” which can be rented for 3 days but is returned after more than 6 days on average. On the other side of the scale is the movie “Greedy Roots,” which is returned on average 4 days before the expected return date.

-----------------





## Task 13 – Most popular rental times

### Problem
**Business need:**<br>
The company wants to better understand at what times of day customers
most often make rentals in order to better plan its service.

**Expectations:**<br>
Return:
- time of day (e.g., night, morning, afternoon, evening)
- total number of rentals in a given time slot
- information about which time slot is the most popular

**Additional information:**<br>
Time slots should be defined based on the time of rental.
The classification should be clear and unambiguous.

### Solution

```sql
SELECT CASE
	WHEN EXTRACT(HOUR FROM rental_date) BETWEEN 0 AND 3 THEN 'night'
	WHEN EXTRACT(HOUR FROM rental_date) BETWEEN 4 AND 11 THEN 'morning'
	WHEN EXTRACT(HOUR FROM rental_date) BETWEEN 12 AND 18 THEN 'afternoon'
	WHEN EXTRACT(HOUR FROM rental_date) BETWEEN 19 AND 21 THEN 'evening'
	WHEN EXTRACT(HOUR FROM rental_date) BETWEEN 22 AND 23 THEN 'night'
END as time_of_day, COUNT(*) as total_rentals
FROM rental
GROUP BY 1
ORDER BY COUNT(*) desc
;

-- night is more popular than evening, let's check how rentals are distributed across different hours
SELECT EXTRACT(HOUR FROM rental_date) as rental_hour, COUNT(*) as total_rentals
FROM rental
GROUP BY EXTRACT(HOUR FROM rental_date)
ORDER BY COUNT(*) desc
;
```

### Results
**Rentals by time of day**
|“time_of_day”|“total_rentals”|
|-|-|
|morning|5327|
|afternoon|4803|
|night|3909|
|evening|2005|

**Rentals by hour of the day**
|"rental_hour"|"total_rentals"|
|-|-|
|15|887|
|8|696|
|0|694|
|18|688|
|3|684|
|4|681|
|19|676|
|10|673|
|21|671|
|7|667|
|16|664|
|11|663|
|20|658|
|14|653|
|9|652|
|1|649|
|5|648|
|6|647|
|13|645|
|23|642|
|17|634|
|12|632|
|2|630|
|22|610|

### Insights
1. Customers are most likely to rent movies in the morning, and rental stores see the least traffic in the evening.
1. Nighttime is a more popular time of day for rentals than evening.
1. Surprisingly, 11 p.m. ranks second in popularity, midnight ranks sixth, and 1-3 a.m. ranks 14th, 16th, and 17th, respectively, in terms of the number of rentals during the day.
1. Rentals are spread evenly throughout the day and fluctuate around 600 rentals, but we can see that 3 p.m. stands out significantly from the rest with a predominant number of almost 900 rentals.


-----------------
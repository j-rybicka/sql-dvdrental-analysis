# Analiza danych DVD Rental

## Zadanie 1 - Popularne gatunki

### Treść
Jakie są najczęściej i najrzadziej wypożyczane gatunki i jaka jest ich łączna sprzedaż?

### Rozwiązanie

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

### Wyniki

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

### Wnioski
Najczęściej wypożyczanym gatunkiem filmowym jest "Sport", po który klienci sięgnęli 1081 razy, wydając łącznie $4892.19. Na drugim miejscu plasuje się gatunek "Animation", dla którego liczba wypożyczeń to 1065, a suma przychodów to $4245.31. Możemy zauważyć, że gatunek "Comedy" mimo mniejszej liczby wypożyczeń w sumie zarobił $4002.48, co stanowi 80% wypożyczeń filmów animowanych i jednocześnie 94% ich przychodu. Filmy z kategorii "Music" zajmują ostatnie miejsce w rankingu popularności z łączną liczbą wypożyczeń 750, jednocześnie są najmniej kasowymi filmami, bo przyniosły $3071.52 zysku.

Na podstawie powyższego możnaby podjąć decyzję o podwyższeniu ceny filmów animowanych. Sugerowałabym również zrobienie kampanii marketingowej, na którą możemy zaprosić osoby z branży muzycznej, która zachęciłaby fanów do wypożyczania filmów z kategorii "Music".


-----------------


## Zadanie 2 - Preferowane gatunki

### Treść
Czy możemy dowiedzieć się, ilu różnych użytkowników wypożyczyło każdy gatunek?

### Rozwiązanie

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

### Wyniki
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

### Wnioski
Największą liczbę klientów możemy zaliczyć do miłośników gatunku "Sports". Niewiele za nim znajdują się fani gatunku "Action". Na samym końcu widzimy, że kategoria "Travel" ma najmniejsze grono odbiorców, mimo, że nie była na ostatnim miejscu rankingu popularności wypożyczeń.

-----------------




## Zadanie 3 - Rentowność kategorii filmowych

### Treść
Jaka jest średnia stawka wypożyczenia dla każdego gatunku? (od najwyższej do najniższej)

### Rozwiązanie

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

### Wyniki
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

### Wnioski
Możemy zauważyć, że największą średnią stawkę wypożyczeń ma kategoria "Games" i wynosi $3.25. Kilka kolejnych miejsc w rankingu jest stosunkowo zbliżonych, jeśli chodzi o średną cenę za wypożyczenie. 9 gatunków z 16 ma średnią cenę za wypożyczenie powyżej $3. Najtańsze są filmy z gatunku "Action", a różnica w cenie między najdroższym a najtańszym gatunkiem wynosi $0.60. 

-----------------


## Zadanie 4 - Terminowość wypożyczeń

### Treść
Ile wypożyczonych filmów zostało zwróconych z opóźnieniem, przed terminem i na czas?

### Rozwiązanie

```sql
-- opcja 1, trzy kolumny z kategorią
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

-- opcja 2, CASE - warunki i przypisanie etykiety tekstowej
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

### Wyniki
|"category"|"total_returned_movies"|
|-|-|
|early|7738|
|late|6403|
|on time|1720|
|not_returned_yet|183|


### Wnioski
W tym rankingu widzimy, że 1720 klientów zwróciło wypożyczony film na czas, natomiast aż 7738 klientów oddało filmy przed ich maksymalnym, dozwolonym czasem zwrócenia. Liczba klientów, która spóźniła się ze zwrotem wypożyczonego filmu wynosi 6043. 183 filmy nie zostały jeszcze zwrócone.

Na tej podstawie moglibyśmy zastosować większe kary pieniężne dla klientów, którzy nie oddają wypożyczonych filmów na czas.
Wypożyczalnie mogłby również przeprowadzić ankietę wśród klientów, którzy zwracają filmy przed czasem, aby dokładniej zrozumieć przyczynę szybszego zwrotu - w zależności od wyników część filmów mogłaby mieć skrócony czas maksymalnego wypożyczenia, część filmów mogłaby zostać wycofana ze sprzedaży ze względu na niską jakość. Aby uporać się z klientami, którzy oddają filmy po wyznaczonym czasie można rozważyć system nagród za oddanie filmu na czas.

-----------------



## Zadanie 5 - Zasięg sprzedaży

### Treść
W jakich krajach działa nasza firma i jaka jest baza klientów w każdym z tych krajów? 

Jaka jest łączna sprzedaż w każdym z krajów? (od największej do najmniejszej)

### Uwagi autora
Osoby definiujące pytanie nie wyraziły się jasno co rozumieją poprzez "działanie" w kraju, więc postanowiłam rozważyć 3 warianty:
- **A** - Sprzedaż ze względu na lokalizację wypożyczalni
- **B** - Sprzedaż ze względu na lokalizację klienta
- **C** - Sprzedaż ze względu na lokalizację wypożyczalni i klienta (klienci z którego kraju, wypożyczają z lokali z którego kraju)


### Rozwiązanie A (lokalizacja wypożyczalni)

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

### Wyniki A (lokalizacja wypożyczalni)
|"country"|"total_sales"|"total_payments"|"unique_customers"|"employees"|
|-|-|-|-|-|
|Australia|30813.33|7265|599|1|
|Canada|30498.71|7331|599|1|




### Rozwiązanie B (lokalizacja klienta)

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

### Wyniki B (lokalizacja klienta)
|"country"|"total_sales"|"total_payments"|"unique_customers"|
|-|-|-|-|
|India|6032.79|1421|60|
|China|5247.04|1296|53|
|United States|3694.27|873|36|
|Japan|3121.52|748|31|
|Mexico|2984.82|718|30|
|*100 krajów pominięto*|....|....|...|
|Afghanistan|67.82|18|1|
|Tonga|64.84|16|1|
|Saint Vincent and the Grenadines|64.82|18|1|
|Lithuania|63.78|22|1|
|American Samoa|47.85|15|1|


### Rozwiązanie C (lokalizacja klienta i wypożyczalni)

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

### Wyniki C (lokalizacja klienta i wypożyczalni)

|"country"|"customer_country"|"total_sales"|"total_payments"|"unique_customers"|
|-|-|-|-|-|
|Australia|India|3140.57|743|60|
|Canada|India|2892.22|678|60|
|Australia|China|2630.59|640|53|
|Canada|China|2616.45|656|53|
|*100 krajów pominięto*|...|...|...|...|...|
|Australia|American Samoa|22.93|7|1|
|Canada|Nepal|20.96|4|1|
|Australia|Tunisia|20.94|6|1|
|Canada|Saint Vincent and the Grenadines|13.94|6|1|


### Dodatkowe pytania do wariantu C (lokalizacja klienta i wypożyczalni)
1) Czy istnieje jakiś kraj, z którego liczba unikalnych klientów się różni między lokalizacjami wypożyczalni? 
```sql
SELECT c1.customer_country as customer_coutry, c1.country as kraj1, c2.country as kraj2, c1.unique_customers as uc_kraj1, c2.unique_customers as uc_kraj2
FROM customer_countries_store_countries as c1
INNER JOIN customer_countries_store_countries as c2
ON c1.customer_country = c2.customer_country AND c1.country != c2.country AND c1.country > c2.country
WHERE c1.unique_customers != c2.unique_customers
;
```
2) Czy istnieje kraj, z którego klienci wypożyczaliby tylko w jednej lokalizacji?
```sql
SELECT customer_country, count(*), ARRAY_AGG(country)
FROM customer_countries_store_countries
GROUP BY 1
HAVING count(*) = 1
;

```


### Wnioski
1. Analizując sprzedaż w kontekście lokalizacji wypożyczalni możemy łatwo zawuażyć, że dochody w Australii ($30813.33) są większe niż w Kanadzie ($30498.71) - różnica przychodów między tymi krajami to niespełna $314.62, czyli 1%. Łącznie w obu krajach wypożyczono filmy o wartości $61312.04. <br>Liczba transakcji jest podobna w przypadku obu krajów, natomiast Kanada miała więcej przeprowadzonych transakcji, mimo ogólnego mniejszego przychodu. Wypożyczalnie w obu krajach mają po 599 klientów i po 1 pracowniku.


2. Największą liczbę wypożyczeń odnotowano wśród klientów z Indii, gdzie mamy 60 indywidualnych klientów, którzy dokonali 1421 płatności na łączną kwotę $6032.79. Chińczycy wypożyczają prawie tyle co Hindusi, co umieszcza ich na drugim miejscu rankingu. Klienci ze Stanów Zjednoczonych znaleźli się na trzecim miejscu, ze znacznie mniejszą liczbą wypożyczeń i klientów, co przełożyło się na łączną kwotę sprzedaży $3694.27. Porównując ze sobą kraje z pierwszych 5 miejsc, można wysuć wniosek, że przychody są skorelowane z liczbą unikalnych klientów - 60 klientów oznacza przychód w okolicy $60k, a 36 klientów to w przybliżeniu $36k. <br>
Klienci z American Samoa i Litwy znaleźli się na końcu rankingu, mając po jednym kliencie i odpowiednio $47 i $64 w sprzedaży.

3. Wyniki sprzedaży w przypadku analizy w kontekście lokalizacji wypożyczalni i klienta są stosunkowo zbliżone do wyników z wariantu B (badanie pod kątem lokalizacji klienta) - ponownie na samym szczycie rankingu są klienci z Indii i Chin, a na końcu klienci z American Samoa i Saint Vincent and the Grenadines. <br>Widoczne jest to, że w każdym kraju mamy dokładnie taką samą liczbę unikalnych klientów, a klienci z żadnego kraju nie wypożyczali tylko z jednej lokalizacji. Wynika to z odpowiedzi na dodatkowe pytania do wariantu C. <br>Nie widać dużej rozbieżności w sprzedaży i liczbie transakcji obu lokalizacji wypożyczalni, patrząc na każdy kraj kliencki. W rzeczywistości świadczy to o podobnym rozkładzie danych w przygotowanym zbiorze - transakcje zostały rozdzielone tak, żeby każdy klient dokonywał wypożyczeń w każdym sklepie prawie po równo.

-----------------


## Zadanie 6 - Najlepsi klienci

### Treść
Kim jest 5 najlepszych klientów pod względem całkowitej sprzedaży i czy możemy uzyskać ich dane na wypadek, gdyby firma chciała ich nagrodzić?

### Rozwiązanie

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

### Wyniki
|"first_name"|"last_name"|"total_sales"|"email"|"postal_address"|
|-|-|-|-|-|
|Eleanor|Hunt|211.55|eleanor.hunt@sakilacustomer.org|92150 Saint-Denis, 1952 Pune Lane|
|Karl|Seal|208.58|karl.seal@sakilacustomer.org|31342 Cape Coral, 1427 Tabuk Place|
|Marion|Snyder|194.61|marion.snyder@sakilacustomer.org|47288 Santa Brbara dOeste, 1891 Rizhao Boulevard|
|Rhonda|Kennedy|191.62|rhonda.kennedy@sakilacustomer.org|11044 Apeldoorn, 1749 Daxian Place|
|Clara|Shaw|189.60|clara.shaw@sakilacustomer.org|30861 Molodetno, 1027 Songkhla Manor|

### Wnioski
Dane adresowe pięciu klientów, którzy wydali na wypożyczenia filmów najwięcej zostały przedstawione. <br>Klientką, która wydała najwięcej ($211.55) jest Eleanor Hunt z Saint-Denis. Na drugim miejscu znalazł się Karl Seal z Cape Coral, który wydał zaledwie 3 dolary mniej od Eleanor ($208.58). Dzięki wydanym $189.6, na piątym miejscu znalazła się Clara Shaw z Molodetno.

-----------------


## Zadanie 7 - Segmenty klienckie

### Treść
Firma DVD Rental chce lepiej zrozumieć swoich klientów, aby:
 * zidentyfikować najbardziej wartościowych klientów,
 * znaleźć klientów aktywnych, ale generujących niskie przychody,
 * przygotować podstawę pod przyszłe kampanie marketingowe.

Twoim zadaniem jest przygotowanie analizy segmentacji klientów na podstawie danych historycznych.

Dla każdego klienta:
 1. obliczyć jego aktywność (liczba wypożyczeń),
 2. obliczyć jego wartość finansową (łączna kwota płatności),
 3. przypisać go do prostego segmentu biznesowego

Zaprezentuj ilu mamy klientów w każdym segmencie.


### Uwagi
Definicja segmentów:
* **VIP** - więcej niż 30 wypożyczeń i suma płatności > 150
* **Regular** - 10–30 wypożyczeń
* **Occasional** - mniej niż 10 wypożyczeń
* **High activity / low value** - więcej niż 20 wypożyczeń i suma płatności < 100


### Rozwiązanie

```sql
-- przeprowadzenie agregacji dla klienta
CREATE TEMPORARY TABLE customer_stats as
SELECT customer.customer_id, first_name, last_name, COUNT(rental.rental_id) as rentals, SUM(amount) as total_payment
FROM customer
INNER JOIN rental
ON customer.customer_id=rental.customer_id
INNER JOIN payment
ON rental.rental_id=payment.rental_id
GROUP BY customer.customer_id, first_name, last_name
;

-- segmentacja klientów
CREATE TEMPORARY TABLE customers_segments as
SELECT customer_id, first_name, last_name, rentals, total_payment, CASE
WHEN total_payment > 150 AND rentals > 30 THEN 'VIP'
WHEN rentals BETWEEN 10 AND 30 THEN 'Regular'
WHEN rentals < 10 THEN 'Occasional'
WHEN rentals > 20 AND total_payment < 100 THEN 'High activity/low value'
END as segments
FROM customer_stats
;

-- grupujemy wyniki, żeby obejrzeć segmenty
SELECT segments, COUNT(*)
FROM customers_segments
GROUP BY segments
ORDER BY COUNT(*) desc;

-- obejrzyjmy klientów, którzy nie przypisali się do żadnej grupy
SELECT *
FROM customers_segments
WHERE segments IS NULL
LIMIT 5;
```

### Wyniki
|"segments"|"count"|
|-|-|
|Regular|531|
|null|47|
|VIP|19|
|Occasional|1|
|High activity/low value|1|

<br><br>
**Klienci nieprzypisani do żadnej kategorii:**

|"customer_id"|"first_name"|"last_name"|"rentals"|"total_payment"|"segments"|
|-|-|-|-|-|-|
|406|Nathan|Runyon|31|121.69|null|
|576|Morris|Mccarter|32|135.68|null|
|390|Shawn|Heaton|31|142.69|null|
|257|Marsha|Douglas|34|142.66|null|
|125|Ethel|Webb|31|131.69|null|



### Wczesne wnioski
1. 47 klientów nie przynależy do segmentu, ale widocznie są to aktywni klienci, którzy jeszcze nie osiągneli statusu VIP, ale już nie są Regular. 
<br/>Możliwe wyjścia:
   * zmiana widełek dla segmentu 'High activity/low value', i podniesienie sumy płatności do $150.
   * dodanie kolejnego segmentu, ale nie wydaje się to mieć sensu, bo do grupy 'High activity/low value' przynależy niewielu klientów (1)
2. mała liczba klientów w segmencie 'High activity/low value' może wynikać z kolejności w CASE, przez co zaliczają się do Regular na podstawie liczby wypożyczeń, bo warunki tych segmentów mają część wspólną.
    * możliwe wyjście - zmiana priorytetu reguł przypisania do segmentów tak, żeby 'High activity/low value' był wyżej niż Regular


### Poprawione rozwiązanie
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

-- ponowne zliczenie segmentów
SELECT segments, COUNT(*)
FROM customers_segments
GROUP BY segments
ORDER BY COUNT(*) desc;
```

### Poprawione wyniki
|"segments"|"count"|
|-|-|
|High activity/low value|440|
|Regular|139|
|VIP|19|
|Occasional|1|

### Wnioski
Po wprowadzeniu poprawek w regule przypisania klientów do segmentów, tj. podniesieniu priorytetu dla segmentu 'High activity/low value' oraz podwyższeniu limitu dla sumy płatności w tymże segmencie, widać że stał się on najliczniejszym segmentem.
<br> Wśród wypożyczających znajduje się 19 VIP-ów, 440 klientów o statusie wysokiej aktywności, lecz bez wysokich przychodów, 139 stałych klientów oraz 1 klienta okazjonalnego.
<br> Rozkład klientów o wysokiej randze ('High activity/low value' i 'VIP') wydaje się zbyt wysoki, podczas gdy klientów o niskim poziomie aktywności ('Occasional') jest niewielu. Może to świadczyć o konieczności modyfikacji reguł przypisania do segmentów, tak żeby najbardziej liczną grupą klientów byli Occasional lub Regular, a dwie grupy świadczące o wysokiej wartości klienta nie były aż tak łatwo dostępne.

-----------------



## Zadanie 8 – Efektywność filmów

### Treść
**Potrzeba biznesowa**:
<br/>Zespół chce zidentyfikować filmy, które są często wypożyczane, ale generują relatywnie niskie przychody,
aby rozważyć zmianę cen lub promocje.

**Oczekiwania:** <br>
- tytuł filmu
- liczba wypożyczeń
- łączna kwota płatności
- średnia kwota płatności na wypożyczenie

**Dodatkowe informacje:**
<br>
Analiza powinna obejmować tylko filmy, które były wypożyczane co najmniej 10 razy, aby uniknąć przypadków losowych.

### Rozwiązanie

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

### Wyniki
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


### Alternatywne rozwiązanie
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

### Alternatywne wyniki
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


### Wnioski
Najmniej rentownym filmem okazał się być "Smoking Barbarella", który był wypożyczany 17 razy i średnio kosztował klientów $1.05.
Dla 10 filmów najmniej rentownych widać, że wypożyczane są za mniej więcej $1.


Podstawową miarą wykorzystaną do wyliczenia rentowności była średnia arytmetyczna, która musiała zostać wzmocniona warunkiem na minimalną liczbę wypożyczeń (wyznaczona empirycznie na wartość 10). Alternatywnie wykorzystałam wagę, która na średnią nakładała karę w przypadku małej liczby wypożyczeń - dzięki temu faworyzowane były filmy o niewielkim średnim przychodzie, lecz z większą liczbą wypożyczeń (nie trzeba filtrować danych).


W obu przypadkach lista filmów jest bardzo podobna, lecz różnia się miejscem na liście. Każdy z wybranych filmów mógłby mieć podwyższoną cenę, gdyż jest na nie popyt, ale klienci nie płacą tyle ile by mogli.


-----------------



## Zadanie 9 – Filmy problematyczne operacyjnie

### Treść
**Potrzeba biznesowa**:
<br/>Zespół operacyjny chce zidentyfikować filmy, które często nie są zwracane na czas.

**Oczekiwania:** <br>
Zwróć listę filmów wraz z:
- tytułem
- liczbą wszystkich wypożyczeń
- liczbą wypożyczeń trwających dłużej niż 7 dni
- procentowym udziałem takich wypożyczeń

**Dodatkowe informacje:**
<br>
Interesują tylko filmy, które były wypożyczane więcej niż 5 razy.


### Rozwiązanie

```sql
-- proste agregacje
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

-- wyliczenie procentowego udziału
SELECT title, total_rental, longer_than_7_days, ROUND(100*(longer_than_7_days/(total_rental*1.0)), 2) as ratio
FROM film_rentals
ORDER BY (longer_than_7_days/(total_rental*1.0)) desc
;
```

### Wyniki
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

### Wnioski

Możemy zauważyć, że największy odsetek ponad tygodniowych wypożyczeń mają filmy "Reds Pocus" i "Gilbert Pelican" - te filmy są przetrzymywane w 55% przypadków wypożyczeń. Istnieją też filmy, które nigdy nie były zwrócone po tygodniu, takie jak "Lights Deer", czy "Won Dares".

Wypożyczalnie mogłyby przeprowadzić ankietę wśród spóźnialskich klientów, aby dokładniej zrozumieć dlaczego decydują się na przetrzymywanie tych konkretnych tytułów - w zależności od wyników dla części filmów mogłaby być wprowadzona większa liczba kopii.

-----------------





## Zadanie 10

### Treść
**Potrzeba biznesowa**:
<br/>Kierownik chce sprawdzić, czy obciążenie pracowników jest równomierne.


**Oczekiwania:** <br>
Dla każdego pracownika zwróć:
- imię i nazwisko
- łączną liczbę obsłużonych wypożyczeń
- liczbę unikalnych klientów
- średnią liczbę wypożyczeń przypadającą na jednego klienta

**Dodatkowe informacje:**
<br>
Wynik powinien umożliwić porównanie intensywności pracy między pracownikami.


### Rozwiązanie

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

### Wyniki
|"staff_id"|"unique_customers"|"total_rentals"|"rentals_per_customer"|
|-|-|-|-|
|1|599|8040|13.42|
|2|599|8004|13.36|

### Wnioski
W tej analizie możemy zobaczyć, że pracownicy dwóch sklepów mają po tyle samo unikalnych klientów, natomiast sama liczba, jak i średnia wypożyczeń niewiele różnią się od siebie.

W przypadku prcownika numer 1 widzimy, że łączna liczba wypożyczeń (8040) jest o 0.5% większa niż w przypadku pracownika numer 2 (8004).

Obciążenie wśród pracowników jest równomierne i według mnie zbyt wysokie - obie wypożyczalnie powinny zatrudnić dodatkowe osoby.

-----------------



## Zadanie 11 – Klienci z szerokimi preferencjami

### Treść
**Potrzeba biznesowa:**<br>
Zespół produktowy chce zidentyfikować klientów o zróżnicowanych gustach filmowych,
którzy mogą być bardziej otwarci na rekomendacje.

**Oczekiwania:**<br>
- identyfikator klienta
- imię i nazwisko
- liczba różnych kategorii filmów, które wypożyczył
- łączna liczba wypożyczeń

**Dodatkowe informacje:**<br>
Celem jest znalezienie klientów, którzy regularnie sięgają po różne typy filmów.



### Rozwiązanie

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

### Wyniki
|"percentage_of_watched_genres"|"users"|"percentage_users"|
|-|-|-|
|100|19|3.17|
|<25;50)|1|0.17|
|<50;75)|100|16.69|
|<75;100)|479|79.97|

### Wnioski
Aż 599 klientów regularnie sięga po różne typy filmów. W bazie wypożyczalni znajduje się 16 gatunków filmów.

Tylko 3% klientów obejrzało filmy ze wszystkich dostępnych gatunków filmowych. Dla porównania - 16% zapoznało się z 50–75% dostępnych kategorii, a zdecydowana większość, bo aż 80% wybierała filmy z niemal całego wachlarza dostępnych gatunków.

-----------------




## Zadanie 12 – Czas przetrzymywania filmów

### Treść
**Potrzeba biznesowa:**<br>
Firma chce sprawdzić, które filmy są najczęściej przetrzymywane dłużej niż przewidywany czas wypożyczenia, co może wpływać na dostępność oferty dla innych klientów.

**Oczekiwania:**<br>
Dla każdego filmu zwróć:
- tytuł filmu
- średni czas rzeczywistego wypożyczenia (w dniach)
- przewidywany czas wypożyczenia wynikający z danych filmu
- różnicę między czasem rzeczywistym a przewidywanym

**Dodatkowe informacje:**<br>
Czas rzeczywisty należy obliczyć na podstawie dat wypożyczenia i zwrotu.
Interesują tylko wypożyczenia zakończone (zwrócone).

### Rozwiązanie

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

### Wyniki
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

### Wnioski
Zestawienie terminowości zwracanych wypożyczeń była już dokonywana we wcześniejszym zadaniu. Wynikało z niej, że większość wypożyczeń jest zwracana przed maksymalnym dozwolonym czasem.

Średnio najdłużej przetrzymywanym filmem jest "Mother Oleander", który może być wypożyczony na 3 dni, a średnio zostaje zwrócony po ponad 6 dniach. Po drugiej stronie szali znajduje się film pod tytułem "Greedy Roots", który jest zwarany średnio 4 dni przed zakładanym czasem zwrotu.

-----------------





## Zadanie 13 – Najczęściej wybierana pora wypożyczeń

### Treść
**Potrzeba biznesowa:**<br>
Firma chce lepiej zrozumieć, w jakich porach dnia klienci
najczęściej dokonują wypożyczeń, aby lepiej planować obsługę.

**Oczekiwania:**<br>
Zwróć:
- przedział czasowy dnia (np. noc, poranek, popołudnie, wieczór)
- łączną liczbę wypożyczeń w danym przedziale
- informację, który przedział jest najpopularniejszy

**Dodatkowe informacje:**<br>
Przedziały czasowe należy zdefiniować na podstawie godziny wypożyczenia.
Klasyfikacja powinna być czytelna i jednoznaczna.

### Rozwiązanie

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

-- noc jest popularniejsza niż wieczór, sprawdźmy jak wypożyczenia rozkładają się w poszczególnych godzinach
SELECT EXTRACT(HOUR FROM rental_date) as rental_hour, COUNT(*) as total_rentals
FROM rental
GROUP BY EXTRACT(HOUR FROM rental_date)
ORDER BY COUNT(*) desc
;
```

### Wyniki
**Wypożyczenia według pory dnia**
|"time_of_day"|"total_rentals"|
|-|-|
|morning|5327|
|afternoon|4803|
|night|3909|
|evening|2005|

**Wypożyczenia według godzin dnia**
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

### Wnioski
1. Klienci najchętniej wypożyczają film w godzinach porannych, a najmniejszy ruch w wypożyczalniach jest wieczorem.
1. Noc jest popularniejszą porą dnia w kontekście wypożyczeń, niż wieczór.
1. Zadziwiająco  godzina 23 jest na 2 miejscu rankingu popularności, północ jest na 6 miejscu, a godziny 1-3 zajmują kolejno 14, 16 i 17 miejsce w rankingu liczby wypożyczeń w ciągu dnia.
1. Wypożyczenia są porozkładane równomiernie w ciągu doby i oscylują wokół 600 wypożyczeń, jendak możemy zauważyć, że godzina 15 znacznie wyróżnia się na tle pozostałych z przeważającą liczbą prawie 900 wypożyczeń.

-----------------
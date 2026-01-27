# DVD Rental – Portfolio SQL (PostgreSQL)

## 📌 Opis projektu
Repozytorium zawiera zestaw analiz SQL opartych na przykładowej bazie danych **PostgreSQL DVDRental**.  
Celem projektu jest zaprezentowanie praktycznych umiejętności pracy z SQL w kontekście analizy danych, a nie jedynie prostych zapytań technicznych.

Projekt skupia się na:
- logicznym filtrowaniu danych (`WHERE`)
- agregacjach i analizie grup (`GROUP BY`, `HAVING`)
- logice warunkowej (`CASE WHEN`)
- podzapytaniach i konstrukcjach typu `EXISTS / NOT EXISTS`
- rozbijaniu złożonych problemów na podproblemy oraz ich rozwiązywaniu przy użyciu dostępnych narzędzi
- pracy na relacyjnej strukturze bazy danych

------------------

## 🛠️ Wykorzystane technologie
- **PostgreSQL**
- **Baza danych DVDRental**
- **SQL (pgAdmin)**

---

## 📂 Struktura repozytorium

```
sql-dvdrental-analysis/
│
├── README.md
├── dvd_rental_analysis.md
├── schema/
│ └── dvdrental_schema.png
│
├── exercises/
│ ├── 01_basic_filters.sql
│ ├── 02_group_by_having.sql
│ ├── 03_case_when.sql
└──── 04_subqueries.sql

```

## 🗄️ Opis bazy danych DVDRental

Projekt opiera się na przykładowej bazie danych **DVDRental**, która symuluje działalność wypożyczalni filmów i zawiera dane dotyczące filmów, klientów, wypożyczeń, płatności, pracowników oraz struktury geograficznej adresów.  
Baza ma charakter **relacyjny**, a jej diagram ER znajduje się w pliku [schema/dvdrental_schema.png](schema/dvdrental_schema.png)

### Tabele główne

- **film** – każdy wiersz reprezentuje jeden film dostępny w ofercie wypożyczalni wraz z jego metadanymi (tytuł, długość, cena wypożyczenia, czas wypożyczenia, rating).
- **category** – każdy wiersz reprezentuje jedną kategorię filmową (np. Action, Comedy).
- **film_category** – każdy wiersz łączy jeden film z jedną kategorią, umożliwiając przypisanie filmu do kategorii.
- **actor** – każdy wiersz reprezentuje jednego aktora występującego w filmach.
- **film_actor** – każdy wiersz reprezentuje udział jednego aktora w jednym filmie.


### Struktura fizyczna i pracownicy

- **inventory** – każdy wiersz reprezentuje jedną fizyczną kopię filmu przypisaną do konkretnego sklepu.
- **store** – każdy wiersz reprezentuje jeden sklep wypożyczalni.
- **staff** – każdy wiersz reprezentuje jednego pracownika obsługującego wypożyczenia i płatności.

### Klienci i wypożyczenia

- **customer** – każdy wiersz reprezentuje jednego klienta wypożyczalni wraz z danymi kontaktowymi i informacją o aktywności.
- **rental** – każdy wiersz reprezentuje jedno wypożyczenie konkretnej kopii filmu przez klienta w określonym czasie.
- **payment** – każdy wiersz reprezentuje jedną płatność dokonaną przez klienta za wypożyczenie filmu.


### Dane adresowe i geograficzne

- **address** – każdy wiersz reprezentuje jeden adres fizyczny powiązany z klientem, pracownikiem lub sklepem.
- **city** – każdy wiersz reprezentuje jedno miasto, do którego przypisane są adresy.
- **country** – każdy wiersz reprezentuje jedno państwo, w którym znajdują się miasta i adresy.

Baza danych DVDRental umożliwia analizę relacji między klientami, filmami i wypożyczeniami oraz stanowi realistyczne środowisko do ćwiczenia zapytań SQL w kontekście rzeczywistych problemów biznesowych.



## 📊 Przykładowe analizy
W repozytorium znajdują się m.in. zapytania:
- ...

Każda analiza skupia się na konkretnym problemie i zawiera czytelne, udokumentowane zapytania SQL.

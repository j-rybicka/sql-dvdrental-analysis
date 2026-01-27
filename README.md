# DVD Rental – SQL Portfolio (PostgreSQL)

## 📌 Project description
The repository contains a set of SQL analyses based on the sample **PostgreSQL DVDRental** database.  
The aim of the project is to present practical skills in working with SQL in the context of data analysis, rather than just simple technical queries.

The project focuses on:
- logical data filtering (`WHERE`)
- aggregations and group analysis (`GROUP BY`, `HAVING`)
- conditional logic (`CASE WHEN`)
- subqueries and `EXISTS / NOT EXISTS` constructions
- breaking down complex problems into sub-problems and solving them using available tools
- working on a relational database structure

------------------

## 🛠️ Technologies used
- **PostgreSQL**
- **DVDRental database**
- **SQL (pgAdmin)**

---

## 📂 Repository structure

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

## 🗄️ Description of the DVDRental database

The project is based on the sample **DVDRental** database, which simulates the operations of a movie rental store and contains data on movies, customers, rentals, payments, employees, and the geographic structure of addresses.  
The database is **relational**, and its ER diagram can be found in the file [schema/dvdrental_schema.png](schema/dvdrental_schema.png)

### Main tables

- **movie** – each row represents one movie available in the rental store's offer, along with its metadata (title, length, rental price, rental period, rating).
- **category** – each row represents one movie category (e.g., Action, Comedy).
- **film_category** – each row links one movie to one category, allowing the movie to be assigned to a category.
- **actor** – each row represents one actor appearing in movies.
- **film_actor** – each row represents one actor's participation in one movie


### Physical structure and employees

- **inventory** – each row represents one physical copy of a movie assigned to a specific store.
- **store** – each row represents one rental store.
- **staff** – each row represents one employee handling rentals and payments.

### Customers and rentals

- **customer** – each row represents one rental store customer, including contact details and activity information.
- **rental** – each row represents one rental of a specific copy of a movie by a customer at a specific time.
- **payment** – each row represents one payment made by a customer for renting a movie.

### Address and geographic data

- **address** – each row represents one physical address associated with a customer, employee, or store.
- **city** – each row represents one city to which addresses are assigned.
- **country** – each row represents one country in which cities and addresses are located.

The DVDRental database allows you to analyze the relationships between customers, movies, and rentals, and provides a realistic environment for practicing SQL queries in the context of real-world business problems.


## 📊 Analyses

Each analysis focuses on a specific problem and contains clear, documented SQL queries.
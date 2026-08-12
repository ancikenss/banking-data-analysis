# Banking Analytics SQL Project

## About

This project is a simulation of a banking database built in PostgreSQL.

The goal was to practice designing a relational database, generating realistic data and writing SQL queries that answer common business questions a bank might have.

The database contains customers, bank accounts, branches, loans and transactions connected through primary and foreign keys.


## Database

The project consists of five tables:

- Customers
- Accounts
- Branches
- Loans
- Transactions

The data is randomly generated, so every time the generation script is executed a new dataset is created.



## What I practiced

During this project I worked with:

- table design
- primary and foreign keys
- data generation using `generate_series()` and `random()`
- JOINs
- aggregate functions
- GROUP BY and HAVING
- CASE expressions
- subqueries
- window functions
- Common Table Expressions (CTEs)



## Example analyses

Some of the analyses included in this project are:

- number of customers by city
- average income by city
- top 10 customers by total account balance
- branch performance
- loan portfolio analysis
- transaction analysis
- cash inflow vs. outflow
- comparison of customers within the same branch


## Files

- `01_create_tables.sql` – database schema
- `02_generate_data.sql` – data generation
- `03_analysis.sql` – analytical SQL queries



## Author

Ana Ranković

Faculty of Mathematics, University of Belgrade

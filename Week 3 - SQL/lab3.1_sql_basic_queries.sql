# Show all tables.
use sakila;
SHOW TABLES;


# Retrieve all the data from the tables actor, film and customer.
select * from sakila.actor;
select * from sakila.film;
select * from sakila.customer;


# Titles of all films from the film table
select title from sakila.film;

# List of languages used in films, with the column aliased as language from the language table
select name as language from sakila.language;

# List of first names of all employees from the staff table
select first_name from sakila.staff;


# Retrieve unique release years.
select distinct release_year from sakila.film;


# Determine the number of stores that the company has.
select count(store_id) from sakila.store;

# Determine the number of employees that the company has.
select count(staff_id) from sakila.staff;

# Determine how many films are available for rent and how many have been rented.
select count(*) - (select count(*) from sakila.rental
where return_date is null) from sakila.inventory;

select count(*) from sakila.rental
where return_date is null;


# Determine the number of distinct last names of the actors in the database.
select count(distinct last_name) from sakila.actor;


# Retrieve the 10 longest films.
select * from sakila.film
order by length desc
limit 10;


# Retrieve all actors with the first name "SCARLETT".
select * from sakila.actor
where first_name = 'SCARLETT';

# Retrieve all movies that have ARMAGEDDON in their title and have a duration longer than 100 minutes.
select * from sakila.film
where title like '%ARMAGEDDON%' and length > 100;

# Determine the number of films that include Behind the Scenes content
select count(*) from sakila.film
where special_features like '%Behind%'

















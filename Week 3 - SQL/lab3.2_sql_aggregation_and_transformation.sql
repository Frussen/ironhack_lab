
## CHALLENGE 1

# 1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.
select @max_duration:= max(length) from sakila.film;
select @min_duration:= min(length) from sakila.film;

# 1.2 Express the average movie duration in hours and minutes. Don't use decimals.
select concat(cast(floor(avg(length)/60) as char),'h ',cast(floor(avg(length)%60) as char),'m') as avg_duration from sakila.film;


# 2.1 Calculate the number of days that the company has been operating.
select datediff(max(rental_date),min(rental_date)) from sakila.rental;

# 2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.
/*
DELIMITER //
CREATE PROCEDURE CreateMonthColumn()
BEGIN
	IF NOT EXISTS( SELECT NULL
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE table_name = 'rental'
			AND table_schema = 'sakila'
			AND column_name = 'month')  THEN
		ALTER TABLE sakila.rental ADD month int as (date_format(rental_date, '%m')) STORED;
	END IF;
END //
DELIMITER ;
*/
#DROP PROCEDURE CreateMonthColumn;
CALL CreateMonthColumn();

/*
DELIMITER //
CREATE PROCEDURE CreateWeekdayColumn()
BEGIN
	IF NOT EXISTS( SELECT NULL
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE table_name = 'rental'
			AND table_schema = 'sakila'
			AND column_name = 'weekday')  THEN
		alter table sakila.rental add column weekday int as (weekday(rental_date)) STORED;
	END IF;
END //
#DROP PROCEDURE CreateWeekdayColumn;
*/
CALL CreateWeekdayColumn();
SELECT * FROM sakila.rental
LIMIT 20;

# 2.3 Add an additional column called DAY_TYPE with values 'weekend' or 'workday', depending on the day of the week.
/*
DELIMITER //
CREATE PROCEDURE AddDaytypeColumn()
BEGIN
	IF NOT EXISTS( SELECT NULL
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE table_name = 'rental'
			AND table_schema = 'sakila'
			AND column_name = 'daytype')  THEN
		alter table sakila.rental add column daytype char(15) as (IF(weekday<>0 and weekday<>6,'workday','weekend'));
	END IF;
END //
*/
#DROP PROCEDURE CreateWeekdayColumn;
CALL AddDaytypeColumn();
SELECT * FROM sakila.rental;


# 3. Retrieve the film titles and their rental duration, replace NULL with the string 'Not Available', sort by the film title asc
select title, coalesce(rental_duration,'Not Available') as rental_duration from sakila.film
ORDER BY title ASC;

#4. Retrieve the concatenated first and last names of our customers, along with the first 3 characters of their email address
select concat(first_name,' ',last_name) as name,SUBSTRING(email, 1, 3) AS email from sakila.customer;



## CHALLENGE 2

# 1.1 Total number of films that have been released.
SELECT count(release_year) as release_year FROM sakila.film;

# 1.2 Number of films for each rating.
SELECT rating,count(*) FROM sakila.film
GROUP BY rating;

# 1.3 The number of films for each rating, and sort the results in descending order of the number of films.
SELECT rating,count(*) as count FROM sakila.film
GROUP BY rating
ORDER BY count desc;


# 2. Determine the number of rentals processed by each employee
select staff_id,count(*) as count from sakila.rental
group by staff_id
ORDER BY count desc;


# 3.1 The mean film duration for each rating, and sort the results in descending order of the mean duration.
select rating,round(avg(length),2) as avg_length from sakila.film
group by rating
order by avg_length desc;

# 3.2 Identify which ratings have a mean duration of over two hours
select rating,round(avg(length),2) as avg_length from sakila.film
group by rating
having avg_length > 120
order by avg_length desc;


# 4. Determine which last names are not repeated in the table actor.
select last_name from sakila.actor
group by last_name
having count(*) = 1;



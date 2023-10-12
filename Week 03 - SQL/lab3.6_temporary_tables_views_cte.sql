
use sakila;

# 1. Create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count)

CREATE OR REPLACE VIEW customer_info AS
SELECT customer_id, first_name, email, address, count(rental_id) AS rental_count
FROM customer
LEFT JOIN address
USING(address_id)
LEFT JOIN rental
USING(customer_id)
GROUP BY customer_id
ORDER BY rental_count DESC;

SELECT * FROM customer_info;


# 2. Create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE customer_payment
SELECT customer_id, sum(amount) AS total_paid
FROM customer_info
LEFT JOIN payment
USING(customer_id)
GROUP BY customer_id
ORDER BY total_paid DESC;

DROP TEMPORARY TABLE IF EXISTS customer_payment;
SELECT * FROM customer_payment;


# 3. Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_pay

WITH customer_cte AS (
	SELECT customer_id, first_name, email, rental_count, total_paid
	FROM customer_info
	JOIN customer_payment
	USING(customer_id)
)
SELECT first_name, email, rental_count, total_paid, round(avg(amount),2) AS average_pay
FROM customer_cte
JOIN payment
USING(customer_id)
GROUP BY customer_id, total_paid;


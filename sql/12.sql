/* 
 * A new James Bond movie will be released soon, and management wants to send promotional material to "action fanatics".
 * They've decided that an action fanatic is any customer where at least 4 of their 5 most recently rented movies are action movies.
 *
 * Write a SQL query that finds all action fanatics.
 */
WITH recent_films AS (
    -- Get the most recent rental date for each customer-film combination
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        f.film_id,
        MAX(r.rental_date) AS latest_rental_date
    FROM customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    GROUP BY c.customer_id, c.first_name, c.last_name, f.film_id
),
top_five_films AS (
    -- Select only the 5 most recent films per customer
    SELECT
        rf.customer_id,
        rf.first_name,
        rf.last_name,
        rf.film_id
    FROM (
        SELECT
            customer_id,
            first_name,
            last_name,
            film_id,
            ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY latest_rental_date DESC) AS rental_rank
        FROM recent_films
    ) rf
    WHERE rf.rental_rank <= 5
),
action_films AS (
    -- Find out which of these films are action films
    SELECT
        tf.customer_id,
        tf.first_name,
        tf.last_name,
        COUNT(DISTINCT fc.film_id) AS action_film_count
    FROM top_five_films tf
    JOIN film_category fc ON tf.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Action'
    GROUP BY tf.customer_id, tf.first_name, tf.last_name
)
SELECT
    customer_id,
    first_name,
    last_name
FROM action_films
WHERE action_film_count >= 4;

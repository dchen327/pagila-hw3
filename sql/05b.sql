/*
 * Write a SQL query that lists the title of all movies where at least 2 actors were also in 'AMERICAN CIRCUS'.
 */
SELECT f2.title
FROM film f1
JOIN film_actor fa1 ON f1.film_id = fa1.film_id
JOIN film_actor fa2 ON fa1.actor_id = fa2.actor_id
JOIN film f2 ON fa2.film_id = f2.film_id
WHERE f1.title = 'AMERICAN CIRCUS'
GROUP BY f2.title
HAVING COUNT(DISTINCT fa1.actor_id) >= 2
ORDER BY f2.title;

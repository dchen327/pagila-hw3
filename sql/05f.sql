/* 
 * Finding movies with similar categories still gives you too many options.
 *
 * Write a SQL query that lists all movies that share 2 categories with AMERICAN CIRCUS and 1 actor.
 *
 * HINT:
 * It's possible to complete this problem both with and without set operations,
 * but I find the version using set operations much more intuitive.
 */
WITH american_circus_categories AS (
    SELECT category_id
    FROM film_category
    WHERE film_id = (SELECT film_id FROM film WHERE title = 'AMERICAN CIRCUS')
),
american_circus_actors AS (
    SELECT actor_id
    FROM film_actor
    WHERE film_id = (SELECT film_id FROM film WHERE title = 'AMERICAN CIRCUS')
),
movies_with_matching_categories AS (
    SELECT
        f.film_id,
        f.title
    FROM film f
    JOIN film_category fc ON f.film_id = fc.film_id
    WHERE fc.category_id IN (SELECT category_id FROM american_circus_categories)
    AND f.title != 'AMERICAN CIRCUS'
    GROUP BY f.film_id, f.title
    HAVING COUNT(*) = 2
),
movies_with_matching_actors AS (
    SELECT
        f.film_id,
        f.title
    FROM film f
    JOIN film_actor fa ON f.film_id = fa.film_id
    WHERE fa.actor_id IN (SELECT actor_id FROM american_circus_actors)
    AND f.title != 'AMERICAN CIRCUS'
    GROUP BY f.film_id, f.title
    HAVING COUNT(*) = 1
),
matching_movies AS (
    SELECT title
    FROM movies_with_matching_categories
    INTERSECT
    SELECT title
    FROM movies_with_matching_actors
)

SELECT title
FROM matching_movies
UNION
SELECT 'AMERICAN CIRCUS' AS title
ORDER BY title;

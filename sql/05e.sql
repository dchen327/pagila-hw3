/* 
 * You've decided that you don't actually like ACADEMY DINOSAUR and AGENT TRUMAN,
 * and want to focus on more movies that are similar to AMERICAN CIRCUS.
 * This time, however, you don't want to focus only on movies with similar actors.
 * You want to consider instead movies that have similar categories.
 *
 * Write a SQL query that lists all of the movies that share 2 categories with AMERICAN CIRCUS.
 * Order the results alphabetically.
 *
 * NOTE:
 * Recall that the following query lists the categories for the movie AMERICAN CIRCUS:
 * ```
 * SELECT name
 * FROM category
 * JOIN film_category USING (category_id)
 * JOIN film USING (film_id)
 * WHERE title = 'AMERICAN CIRCUS';
 * ```
 * This problem should be solved by a self join on the "film_category" table.
 */
WITH american_circus_categories AS (
    SELECT category_id
    FROM film_category
    WHERE film_id = (SELECT film_id FROM film WHERE title = 'AMERICAN CIRCUS')
),
movies_with_matching_categories AS (
    SELECT
        f.film_id,
        f.title,
        COUNT(*) AS shared_categories
    FROM film f
    JOIN film_category fc ON f.film_id = fc.film_id
    WHERE fc.category_id IN (SELECT category_id FROM american_circus_categories)
    GROUP BY f.film_id, f.title
)

SELECT title
FROM movies_with_matching_categories
WHERE shared_categories >= 2
ORDER BY title;

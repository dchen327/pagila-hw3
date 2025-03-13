/*
 * List all actors with Bacall Number 2;
 * That is, list all actors that have appeared in a film with an actor that has appeared in a film with 'RUSSELL BACALL',
 * but do not include actors that have Bacall Number < 2.
 */
WITH bacall_number_0 AS (
    -- Russell Bacall himself
    SELECT actor_id
    FROM actor
    WHERE first_name = 'RUSSELL' AND last_name = 'BACALL'
),
bacall_number_1 AS (
    -- Actors who have appeared in a film with Russell Bacall
    SELECT DISTINCT a.actor_id
    FROM actor a
    JOIN film_actor fa1 ON a.actor_id = fa1.actor_id
    JOIN film_actor fa2 ON fa1.film_id = fa2.film_id
    WHERE fa2.actor_id IN (SELECT actor_id FROM bacall_number_0)
    AND a.actor_id NOT IN (SELECT actor_id FROM bacall_number_0)
),
bacall_number_2_candidates AS (
    -- Actors who have appeared in a film with a Bacall Number 1 actor
    SELECT DISTINCT a.actor_id, a.first_name, a.last_name
    FROM actor a
    JOIN film_actor fa1 ON a.actor_id = fa1.actor_id
    JOIN film_actor fa2 ON fa1.film_id = fa2.film_id
    WHERE fa2.actor_id IN (SELECT actor_id FROM bacall_number_1)
    AND a.actor_id NOT IN (SELECT actor_id FROM bacall_number_1)
    AND a.actor_id NOT IN (SELECT actor_id FROM bacall_number_0)
)

SELECT first_name || ' ' || last_name AS "Actor Name"
FROM bacall_number_2_candidates
ORDER BY "Actor Name";

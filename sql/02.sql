/*
 * Compute the country with the most customers in it. 
 */
SELECT
    co.country
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
JOIN country co ON ct.country_id = co.country_id
GROUP BY co.country
ORDER BY COUNT(c.customer_id) DESC
LIMIT 1;

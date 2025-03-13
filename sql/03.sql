/*
 * List the total amount of money that customers from each country have payed.
 * Order the results from most to least money.
 */
SELECT
    co.country,
    SUM(p.amount) AS total_payments
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
JOIN country co ON ct.country_id = co.country_id
GROUP BY co.country
ORDER BY total_payments DESC, co.country ASC;

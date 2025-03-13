/*
 * Management wants to rank customers by how much money they have spent in order to send coupons to the top 10%.
 *
 * Write a query that computes the total amount that each customer has spent.
 * Include a "percentile" column that contains the customer's percentile spending,
 * and include only customers in at least the 90th percentile.
 * Order the results alphabetically.
 *
 * HINT:
 * I used the `ntile` window function to compute the percentile.
 */
WITH customer_totals AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS name,
        SUM(p.amount) AS total_payment,
        NTILE(100) OVER (ORDER BY SUM(p.amount)) AS percentile
    FROM
        customer c
    JOIN
        payment p ON c.customer_id = p.customer_id
    GROUP BY
        c.customer_id
)
SELECT
    customer_id,
    name,
    total_payment,
    percentile
FROM
    customer_totals
WHERE
    percentile >= 90
ORDER BY
    name;

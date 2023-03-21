/* Question 1 -> question 1 from working set #1 */
SELECT
    f.title,
    c.name,
    count(f.title)
FROM
    film f
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON r.inventory_id = i.inventory_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
WHERE
    c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY
    1,
    2
ORDER BY
    2,
    1;


/* Question 2 -> question 3 from working set #1 */
WITH cte AS (
    SELECT
        f.title,
        c.name,
        f.rental_duration,
        ntile(4) OVER (ORDER BY f.rental_duration) quartile
    FROM film f
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
)
SELECT
    cte.name Category,
    cte.quartile Rental_length_category,
    count(cte.name)
FROM
    cte
WHERE
    cte.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY
    1,
    2
ORDER BY
    1,
    2;


/* Question 3 -> question 1 from working set #2 */
SELECT
    s.store_id,
    date_part('year', r.rental_date) rental_year,
    date_part('month', r.rental_date) rental_month,
    count(*) count_rentals
FROM
    store s
    JOIN staff st ON s.store_id = st.store_id
    JOIN rental r ON r.staff_id = st.staff_id
GROUP BY
    3,
    2,
    1
ORDER BY
    4 DESC;


/* Question 4 -> question 3 from working set #2 */
WITH base_query AS (
    SELECT
        c.customer_id,
        concat(first_name, ' ', last_name) full_name,
        date_trunc('month', payment_date) payment_month,
        p.amount amount
    FROM
        payment p
        JOIN customer c ON p.customer_id = c.customer_id
),
top_paying_customers AS (
    SELECT
        customer_id,
        sum(amount) sum_total_payments
    FROM
        base_query
    GROUP BY
        1
    ORDER BY
        2 DESC
    LIMIT 10
),
monthly_payments AS (
    SELECT
        b.customer_id,
        b.full_name,
        b.payment_month,
        count(b.amount) number_payments,
        sum(b.amount) sum_month_payments
    FROM
        top_paying_customers t,
        base_query b
    WHERE
        b.customer_id = t.customer_id
    GROUP BY
        1,
        2,
        3
),
diff_payments_table AS (
    SELECT
        customer_id,
        full_name,
        payment_month,
        sum_month_payments,
        sum_month_payments - lag(sum_month_payments) OVER (PARTITION BY customer_id) diff_payments
    FROM
        monthly_payments
    ORDER BY
        2,
        3
),
max_diff_table AS (
    SELECT
        max(diff_payments) max_diff_payment
    FROM
        diff_payments_table
),
top_payer AS (
    SELECT
        dpt.full_name top_full_name,
        dpt.payment_month top_payment_month,
        dpt.diff_payments top_diff_payment
    FROM
        diff_payments_table dpt,
        max_diff_table mdt
    WHERE
        dpt.diff_payments = mdt.max_diff_payment
)
SELECT
    dpt.customer_id,
    dpt.full_name,
    dpt.payment_month,
    dpt.sum_month_payments,
    dpt.diff_payments,
    tp.top_full_name,
    tp.top_payment_month,
    tp.top_diff_payment
FROM
    diff_payments_table dpt,
    top_payer tp;


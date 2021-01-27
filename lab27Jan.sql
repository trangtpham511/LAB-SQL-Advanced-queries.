/*
List all films whose length is longer than the average of all the films.
List all films whose length is longer than the average of all the films.
Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
Customers who spent more than the average payments.*/
-- 1 How many copies of the film Hunchback Impossible exist in the inventory system?
use sakila;
SELECT 
    *, COUNT(inventory_id) AS no_of_copies
FROM
    inventory
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film
        WHERE
            title = 'Hunchback Impossible');
-- 2 List all films whose length is longer than the average of all the films.
SELECT 
    title, length
FROM
    film
WHERE
    length > (SELECT 
            AVG(length)
        FROM
            film)
ORDER BY length DESC;
-- 3 Use subqueries to display all actors who appear in the film Alone Trip.
SELECT 
    first_name AS Name, Last_name AS Surname
FROM
    actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            film_actor
        WHERE
            film_id = (SELECT 
                    film_id
                FROM
                    film
                WHERE
                    title LIKE '%ALONE TRIP%'));
-- 4 Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
use sakila;
SELECT 
    title AS movies
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film_category
        WHERE
            category_id IN (SELECT 
                    category_id
                FROM
                    category
                WHERE
                    name = 'Family'));

-- 5 Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information..Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT 
    c.first_name, c.last_name, c.email
FROM
    customer c
        JOIN
    address a ON c.address_id = a.address_id
        JOIN
    city ci ON a.city_id = ci.city_id
        JOIN
    country co ON ci.country_id = co.country_id
WHERE
    co.country = 'Canada';
SELECT 
    last_name, first_name, email
FROM
    customer
WHERE
    address_id IN (SELECT 
            address_id
        FROM
            address
        WHERE
            city_id IN (SELECT 
                    city_id
                FROM
                    city
                WHERE
                    country_id IN (SELECT 
                            country_id
                        FROM
                            country
                        WHERE
                            country = 'Canada')));
-- 6 Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film_actor f
                JOIN
            (SELECT 
                actor_id, COUNT(film_id) AS no_movies
            FROM
                film_actor
            GROUP BY actor_id
            ORDER BY COUNT(film_id) DESC
            LIMIT 1) AS sub ON f.actor_id = sub.actor_id);

-- 7 Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
use sakila;
SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            inventory
        WHERE
            inventory_id IN (SELECT 
                    inventory_id
                FROM
                    rental r
                        JOIN
                    (SELECT 
                        SUM(amount), customer_id
                    FROM
                        payment
                    GROUP BY customer_id
                    ORDER BY SUM(amount) DESC
                    LIMIT 1) AS sub ON r.customer_id = sub.customer_id));
-- 8 Customers who spent more than the average payments.*/
SELECT 
    first_name, last_name
FROM
    customer
WHERE
    customer_id IN (SELECT 
            customer_id
        FROM
            payment
        WHERE
            amount > (SELECT 
                    AVG(amount)
                FROM
                    payment));



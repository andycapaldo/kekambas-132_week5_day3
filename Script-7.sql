--Question 1

SELECT first_name, last_name, district 
FROM customer
JOIN address
ON customer.address_id = address.address_id
WHERE district = 'Texas';


--first_name|last_name|district|
------------+---------+--------+
--Jennifer  |Davis    |Texas   |
--Kim       |Cruz     |Texas   |
--Richard   |Mccrary  |Texas   |
--Bryan     |Hardison |Texas   |
--Ian       |Still    |Texas   |


-- Question 2
SELECT first_name, last_name, amount
FROM payment
JOIN customer 
ON payment.customer_id = customer.customer_id
WHERE amount > 7.00;

--first_name|last_name   |amount|
------------+------------+------+
--Peter     |Menard      |  7.99|
--Peter     |Menard      |  7.99|
--Peter     |Menard      |  7.99|
--Douglas   |Graf        |  8.99|
--Ryan      |Salisbury   |  8.99|
--Ryan      |Salisbury   |  8.99|
--Ryan      |Salisbury   |  7.99|
--Roger     |Quintanilla |  8.99|
--Joe       |Gilliland   |  8.99|
-- ...


-- Question 3
SELECT customer_id, SUM(amount) -- SUBQUERY
FROM payment
GROUP BY customer_id 
HAVING SUM(amount) > 175;

SELECT *  -- MAIN QUERY WITH SUBQUERY
FROM customer
WHERE customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id 
	HAVING SUM(amount) > 175
);


--customer_id|store_id|first_name|last_name|email                            |address_id|activebool|create_date|last_update            |active|
-------------+--------+----------+---------+---------------------------------+----------+----------+-----------+-----------------------+------+
--        137|       2|Rhonda    |Kennedy  |rhonda.kennedy@sakilacustomer.org|       141|true      | 2006-02-14|2013-05-26 14:49:45.738|     1|
--        144|       1|Clara     |Shaw     |clara.shaw@sakilacustomer.org    |       148|true      | 2006-02-14|2013-05-26 14:49:45.738|     1|
--        148|       1|Eleanor   |Hunt     |eleanor.hunt@sakilacustomer.org  |       152|true      | 2006-02-14|2013-05-26 14:49:45.738|     1|
--        178|       2|Marion    |Snyder   |marion.snyder@sakilacustomer.org |       182|true      | 2006-02-14|2013-05-26 14:49:45.738|     1|
--        459|       1|Tommy     |Collazo  |tommy.collazo@sakilacustomer.org |       464|true      | 2006-02-14|2013-05-26 14:49:45.738|     1|
--        526|       2|Karl      |Seal     |karl.seal@sakilacustomer.org     |       532|true      | 2006-02-14|2013-05-26 14:49:45.738|     1|


-- Question 4

SELECT first_name, last_name, district, city, country
FROM customer 
JOIN address 
ON customer.address_id = address.address_id 
JOIN city 
ON address.city_id = city.city_id 
JOIN country 
ON city.country_id = country.country_id
WHERE country = 'Argentina';


--first_name|last_name|district    |city                |country  |
------------+---------+------------+--------------------+---------+
--Willie    |Markham  |Buenos Aires|Almirante Brown     |Argentina|
--Jordan    |Archuleta|Buenos Aires|Avellaneda          |Argentina|
--Jason     |Morrissey|Buenos Aires|Baha Blanca         |Argentina|
--Kimberly  |Lee      |Crdoba      |Crdoba              |Argentina|
--Micheal   |Forman   |Buenos Aires|Escobar             |Argentina|
--Darryl    |Ashcraft |Buenos Aires|Ezeiza              |Argentina|
--Julia     |Flores   |Buenos Aires|La Plata            |Argentina|
--Florence  |Woods    |Buenos Aires|Merlo               |Argentina|
--Perry     |Swafford |Buenos Aires|Quilmes             |Argentina|
--Lydia     |Burke    |Tucumn      |San Miguel de Tucumn|Argentina|
--Eric      |Robert   |Santa F     |Santa F             |Argentina|
--Leonard   |Schofield|Buenos Aires|Tandil              |Argentina|
--Willie    |Howell   |Buenos Aires|Vicente Lpez        |Argentina|


-- Question 5

SELECT c.category_id, name, COUNT(*) AS num_movies_in_cat 
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
GROUP BY c.category_id 
ORDER BY COUNT(*) DESC;



--category_id|name       |num_movies_in_cat|
-------------+-----------+-----------------+
--         15|Sports     |               74|
--          9|Foreign    |               73|
--          8|Family     |               69|
--          6|Documentary|               68|
--          2|Animation  |               66|
--          1|Action     |               64|
--         13|New        |               63|
--          7|Drama      |               62|
--         14|Sci-Fi     |               61|
--         10|Games      |               61|
--          3|Children   |               60|
--          5|Comedy     |               58|
--          4|Classics   |               57|
--         16|Travel     |               57|
--         11|Horror     |               56|
--         12|Music      |               51|



-- Question 6

SELECT MAX(num_actors)  -- SUBQUERY WHICH RETURNS THE HIGHEST # OF ACTORS IN A FILM
FROM (
	SELECT film_id, COUNT(*) AS num_actors -- SUBQUERY OF A SUBQUERY WHICH GIVES A DESCENDING ROW OF FILMS BY HOW MANY ACTORS ARE IN THEM
	FROM film_actor
	GROUP BY film_id
	ORDER BY COUNT(*) DESC
);

SELECT film.film_id, film.title, COUNT(*) AS num_actors -- FINAL QUERY WHICH GIVES RESULT
FROM film
JOIN film_actor 
ON film.film_id = film_actor.film_id 
GROUP BY film.film_id
HAVING COUNT(*) = (
	SELECT MAX(num_actors)
	FROM (
		SELECT film_id, COUNT(*) AS num_actors
		FROM film_actor
		GROUP BY film_id
		ORDER BY COUNT(*) DESC
));

--film_id|title           |num_actors|
---------+----------------+----------+
--    508|Lambs Cincinatti|        15|


-- Question 7  
SELECT actor_id, COUNT(*) AS num_films  -- SUBQUERY WHICH GIVES ASCENDING ROWS OF ACTORS BY # OF FILMS THEY'VE BEEN IN
FROM film_actor
GROUP BY actor_id 
ORDER BY COUNT(*);

SELECT MIN(num_films) -- SUBQUERY WHICH GIVES US THE LOWEST NUMBER OF FILMS AN ACTOR HAS BEEN IN
FROM (
	SELECT actor_id, COUNT(*) AS num_films 
	FROM film_actor
	GROUP BY actor_id 
	ORDER BY COUNT(*)
);

SELECT actor.actor_id, first_name, last_name, COUNT(*) AS num_films -- FINAL QUERY WHICH GIVES US RESULT
FROM actor 
JOIN film_actor 
ON actor.actor_id = film_actor.actor_id 
GROUP BY actor.actor_id 
HAVING COUNT(*) = (
	SELECT MIN(num_films) 
		FROM (
			SELECT actor_id, COUNT(*) AS num_films 
			FROM film_actor
			GROUP BY actor_id 
			ORDER BY COUNT(*)
));


--actor_id|first_name|last_name|num_films|
----------+----------+---------+---------+
--     148|Emily     |Dee      |       14|


-- Question 8

SELECT country_id, COUNT(city_id) AS num_cities -- SUBQUERY GIVING US ALL COUNTRY_ID ROWS SORTED BY NUMBER OF CITIES DESCENDING
FROM city
GROUP BY country_id 
ORDER BY COUNT(*) DESC;

SELECT MAX(num_cities)  -- SUBQUERY WHICH RETURNS THE HIGHEST NUMBER OF CITIES FOR A COUNTRY AMONGST ALL COUNTRY_ID'S
FROM (
	SELECT country_id, COUNT(city_id) AS num_cities
	FROM city
	GROUP BY country_id 
	ORDER BY COUNT(*) DESC
);


SELECT country.country_id, country.country, COUNT(*) AS num_cities -- THIS ANSWER RETURNS JUST THE COUNTRY WITH THE MOST CITIES
FROM country 
JOIN city 
ON country.country_id = city.country_id 
GROUP BY country.country_id 
HAVING COUNT(*) = (
		SELECT MAX(num_cities)
		FROM (
			SELECT country_id, COUNT(city_id) AS num_cities
			FROM city
			GROUP BY country_id 
			ORDER BY COUNT(*) DESC
));

SELECT country.country_id, country.country, COUNT(*) AS num_cities -- THIS ANSWER RETURNS THE TOP 3 COUNTRIES WITH THE MOST CITIES
FROM country 
JOIN city 
ON country.country_id = city.country_id 
GROUP BY country.country_id
ORDER BY num_cities DESC
LIMIT 3;

--country_id|country                              |num_cities|
------------+-------------------------------------+----------+
--        44|India                                |        60|
--        23|China                                |        53|
--       103|United States                        |        35|


-- Question 9


SELECT actor.actor_id, actor.first_name, actor.last_name, COUNT(*)
FROM actor 
JOIN film_actor 
ON actor.actor_id = film_actor.actor_id 
GROUP BY actor.actor_id 
HAVING COUNT(*) BETWEEN 20 AND 25;

--actor_id|first_name |last_name  |count|
----------+-----------+-----------+-----+
--     114|Morgan     |Mcdormand  |   25|
--     153|Minnie     |Kilmer     |   20|
--      32|Tim        |Hackman    |   23|
--     132|Adam       |Hopper     |   22|
--      46|Parker     |Goldberg   |   24|
--     163|Christopher|West       |   21|
--...

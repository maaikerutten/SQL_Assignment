use sakila;

-- 1a. Display the first and last names of all actors from the table actor.
select 
	first_name as firstname
	, last_name as lastname
from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
select concat(first_name , ' ', last_name) as 'Actor Name'
	from actor;

 -- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
 -- What is one query would you use to obtain this information?
 select actor_id, first_name, last_name
 from actor
 where first_name='Joe';
 
 -- 2b. Find all actors whose last name contain the letters GEN:
 select first_name, last_name
 from actor 
 where last_name like '%GEN%';
 
-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
select last_name, first_name
from actor
where last_name like '%LI%' 
order by last_name;

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
alter table actor 
add column description BLOB ;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
alter table actor
drop column description ;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name) as 'occurrences'
from actor 
group by last_name ;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
select last_name, count(last_name) as 'occurrences'
from actor 
group by last_name 
having count(last_name) >1;

-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
update actor
set first_name ='Harpo'
where first_name='Groucho' AND last_name='Williams';

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
update actor
set first_name ='Groucho'
where first_name='Harpo' AND last_name='Williams';

-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8 ;

-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON
staff.address_id=address.address_id;

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT staff.staff_id, staff.first_name, staff.last_name, SUM(payment.amount)
FROM staff
INNER JOIN payment ON
staff.staff_id=payment.staff_id
where date_format(payment_date, '%m %Y')='08 2005'
group by staff.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT film.film_id, film.title, COUNT(film_actor.actor_id)
FROM film
INNER JOIN film_actor ON
film.film_id=film_actor.film_id
group by film.film_id;

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select film.film_id, film.title, COUNT(inventory_id)
from inventory
inner join film on
film.film_id=inventory.film_id
where film.title= 'Hunchback Impossible'
group by film.film_id ;

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
select customer.customer_id, customer.first_name, customer.last_name, SUM(payment.amount)
from customer
inner join payment on
customer.customer_id=payment.customer_id
group by customer.last_name ;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
select film.title
from film
where (film.title like 'Q%' OR film.title like 'K%') 
AND film.language_id =(select language.language_id from language where name='English') ;

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
select actor.first_name, actor.last_name
from actor
where actor_id in (select actor_id from film_actor where film_id = (select film_id from film where title = 'Alone Trip')) ;

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select customer.first_name, customer.last_name, customer.email
from customer
inner join address on
address.address_id=customer.address_id
inner join city on
city.city_id=address.city_id
inner join country on
country.country_id=city.country_id
where country.country= 'Canada' ;

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
select film.title
from film
inner join film_category on
film.film_id=film_category.film_id
inner join category on
category.category_id=film_category.category_id
where category.name= 'Family' ;

-- 7e. Display the most frequently rented movies in descending order.
select film.film_id, film.title, count(rental.rental_id)
from film 
inner join inventory on
film.film_id=inventory.film_id
inner join rental on
inventory.inventory_id=rental.inventory_id
group by film.title 
order by count(rental.rental_id) desc ;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select store, total_sales from sales_by_store ;

-- 7g. Write a query to display for each store its store ID, city, and country.
select store.store_id, city.city, country.country
from store
inner join address on
store.address_id=address.address_id
inner join city on
address.city_id=city.city_id
inner join country on
city.country_id=country.country_id ;

-- 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select category.name, sum(payment.amount)
from category
inner join film_category on
category.category_id=film_category.category_id 
inner join inventory on
film_category.film_id=inventory.film_id
inner join rental on
inventory.inventory_id=rental.inventory_id
inner join payment on
rental.rental_id=payment.rental_id
group by category.name
order by sum(payment.amount) desc
Limit 5 ;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue.  Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view Top_five_Genres as 
select category.name, sum(payment.amount)
from category
inner join film_category on
category.category_id=film_category.category_id 
inner join inventory on
film_category.film_id=inventory.film_id
inner join rental on
inventory.inventory_id=rental.inventory_id
inner join payment on
rental.rental_id=payment.rental_id
group by category.name
order by sum(payment.amount) desc
Limit 5 ;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM sakila.top_five_genres;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
drop view sakila.top_five_genres;

-- END


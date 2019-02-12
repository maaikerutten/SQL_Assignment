use sakila;

-- 1a. Display the first and last names of all actors from the table actor.
select 
	first_name as firstname
	, last_name as lastname
from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
select concat(first_name , ' ', last_name) as 'Actor Name'
	from actor;

 -- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
-- 1. What is the average cost to rent a film in the Sakila stores?

select AVG(rental_rate) as average_rental_rate
from film;

-- 2. What is the average rental cost of films by rating? On average, what is the cheapest rating of films to rent? Most expensive?
select rating
     , AVG(rental_rate) as average_rental_rate
from film
group by rating;

-- 3. How much would it cost to replace all the films in the database?
select SUM(replacement_cost) as total_replacement_cost
from film;

-- 4. How much would it cost to replace all the films in each ratings category?
select rating
     , SUM(replacement_cost) as replacement_cost
from film
group by rating;

-- 5. How long is the longest movie in the database? The shortest?
select MAX(length)
, min(length)
from film;

-- 6. For customers with id numbers 1 through 4, display the total amount they have paid.
select customer_id
     , SUM(amount)
from payment
group by customer_id
having customer_id < 5

;


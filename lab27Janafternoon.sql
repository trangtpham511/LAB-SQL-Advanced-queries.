/*List each pair of actors that have worked together.
For each film, list actor that has acted in more films.*/
-- 1
use sakila;
drop view if exists co_actor;
create view co_actor as
select f.title, a.actor_id , concat(a.first_name,' ', a.last_name) as actor_name from film_actor fa
join film f on f.film_id = fa.film_id
join actor a on fa.actor_id = a.actor_id;
select ca1.actor_name as actor1, ca2.actor_name as actor2 from co_actor ca1
join co_actor ca2
on ca1.actor_name > ca2.actor_name
and ca1.title = ca2.title;
-- 2 

use sakila;
select concat(first_name,' ', last_name) as actor , sub1.film_id from actor a join(
select * from ( select
	actor_id, 
    count(film_id), 
    film_id,
    rank() over(partition by film_id order by count(film_id) desc) as ranking
from 
	film_actor 
group by 
	actor_id) sub
where ranking = 1) sub1 on a.actor_id = sub1.actor_id;
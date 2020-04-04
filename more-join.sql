/*1. List the films where the yr is 1962 [Show id, title] */
SELECT id, title
 FROM movie
 WHERE yr = 1962;

/*2. When was Citizen Kane released? */
SELECT yr
 FROM movie
 WHERE title = 'Citizen Kane';

/*3.  */
SELECT id, title, yr
 FROM movie
 WHERE title LIKE 'Star Trek%'
 ORDER BY yr;

/*4. What id number does the actor 'Glenn Close' have? */
SELECT id FROM actor
WHERE name = 'Glenn Close';

/*5. What is the id of the film 'Casablanca' */
SELECT id FROM movie
WHERE title = 'Casablanca';

/*6. Obtain the cast list for 'Casablanca'.
what is a cast list?
Use movieid=11768, (or whatever value you got from the previous question). */
SELECT name FROM actor JOIN casting ON id=actorid
WHERE movieid = '11768';

/*7. Obtain the cast list for the film 'Alien'. */
SELECT name FROM actor JOIN casting ON actor.id=actorid
JOIN movie ON movie.id=movieid
WHERE title = 'Alien';

/*8. List the films in which 'Harrison Ford' has appeared. */
SELECT title FROM movie JOIN casting ON movie.id=movieid
JOIN actor ON actor.id=actorid
WHERE actor.name = 'Harrison Ford';

/*9. List the films where 'Harrison Ford' has appeared - but not in the starring role. 
[Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role] */
SELECT title FROM movie JOIN casting ON movie.id=movieid
JOIN actor ON actor.id=actorid
WHERE casting.ord <> 1
AND actor.name = 'Harrison Ford';

/*10. List the films together with the leading star for all 1962 films. */
SELECT title, actor.name FROM movie JOIN casting ON movie.id=movieid
JOIN actor ON actor.id=actorid
WHERE casting.ord = 1
AND movie.yr = 1962;

/*11. Which were the busiest years for 'Rock Hudson', show the year and the number of 
movies he made each year for any year in which he made more than 2 movies. */
SELECT yr, COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
        JOIN actor   ON actorid=actor.id
WHERE actor.name='Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2;

/*12. List the film title and the leading actor for all of the films 'Julie Andrews' played in. */
SELECT title, actor.name FROM movie
   JOIN casting ON (movie.id=movieid AND ord=1)
   JOIN actor ON (actor.id=actorid)
   WHERE movie.id IN (
     SELECT movieid FROM casting 
       WHERE actorid IN (SELECT id FROM actor
          WHERE name = 'Julie Andrews'));

/*13. Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles. */
SELECT name
FROM actor
  JOIN casting ON (id = actorid AND (SELECT COUNT(ord) FROM casting WHERE actorid = actor.id AND ord=1)>=15)
GROUP BY name;

/*14. List the films released in the year 1978 ordered by the number of actors in the cast, then by title. */
SELECT title, COUNT(actorid) FROM movie
JOIN casting ON (movie.id=movieid)
WHERE movie.yr = 1978
GROUP BY title
ORDER BY COUNT(actorid) DESC, title;

/*15. List all the people who have worked with 'Art Garfunkel'. */
SELECT name FROM actor
  JOIN casting ON (actor.id=actorid)
  JOIN movie ON (movie.id=movieid)
  WHERE movieid IN (
    SELECT movie.id FROM movie
     JOIN casting ON (movie.id=movieid)
     JOIN actor ON (actor.id=actorid)
     WHERE name = 'Art Garfunkel')
AND name <> 'Art Garfunkel';

\connect lhrDB

-- Find movies by actor

CREATE or REPLACE FUNCTION find_movies_by_actor( actor_name text, max_limit integer ) RETURNS setof text AS $$
BEGIN

  RETURN QUERY EXECUTE 'SELECT m.title
  FROM actors a, movies_actors ma, movies m
  WHERE a.name = $1  
  AND m.id = ma.movie_id
  AND a.id = ma.actor_id
  ORDER BY m.genre DESC
  LIMIT $2'
  USING actor_name, max_limit;

END;
$$ LANGUAGE plpgsql;

-- Find similar movies based on genre
CREATE OR REPLACE FUNCTION find_movies_like( movie_title text, distance integer, max_limit integer )
RETURNS SETOF text AS $$
DECLARE
  distance_param integer;
BEGIN
  distance_param := distance;
  IF distance < 0 THEN distance_param := 5;
  END IF;

  RETURN QUERY EXECUTE
  'SELECT m.title
   FROM movies m, (SELECT genre, title FROM movies WHERE title = $1) s
   WHERE cube_enlarge(s.genre, $2, 18) @> m.genre AND s.title <> m.title
   ORDER BY cube_distance(m.genre, s.genre)
   LIMIT $3'
  USING movie_title, distance_param, max_limit;

END;
$$ LANGUAGE plpgsql;

-- Find top 5 similar movies
CREATE OR REPLACE FUNCTION find_top5( movie_or_actor text)
RETURNS SETOF text AS $$
DECLARE
  mc text;
BEGIN

  SELECT * INTO mc FROM MOVIES WHERE title = movie_or_actor;

  IF NOT FOUND THEN
    RETURN QUERY SELECT find_movies_by_actor(movie_or_actor, 10);
  ELSE
    RETURN QUERY SELECT find_movies_like(movie_or_actor, 10, 5);
  END IF;

END;
$$ LANGUAGE plpgsql;


-- Find actors that star in a movie based on movie title

CREATE OR REPLACE FUNCTION find_actors_starring_movie( movie_title text )
RETURNS table(movie text, actor text) AS $$
BEGIN

  RETURN QUERY EXECUTE 
  'SELECT m.title, a.name
  FROM movies m, movies_actors ma, actors a
  WHERE m.id = ma.movie_id
  AND a.id = ma.actor_id
  AND m.title = $1'
  USING movie_title;

END;
$$ LANGUAGE plpgsql;

-- Find movies user has seen

CREATE OR REPLACE FUNCTION find_watched_movies (user_id integer )
RETURNS SETOF text AS $$
BEGIN
  RETURN QUERY EXECUTE
  'SELECT m.title
  FROM movies m, (SELECT movie_id FROM watched_movies WHERE user_id = $1) wm
  WHERE m.id = wm.movie_id'
  USING user_id;

END;
$$ LANGUAGE plpgsql;

-- Find user based on watched movie

CREATE OR REPLACE FUNCTION find_similar_user (movie_id integer, user_id integer )
RETURNS table(id integer) AS $$
BEGIN
  RETURN QUERY EXECUTE
  'SELECT u.id
  FROM users u, (SELECT user_id FROM watched_movies WHERE movie_id = $1) wm
  WHERE u.id = wm.user_id
  AND u.id != $2'
  USING movie_id, user_id;
END;
$$ LANGUAGE plpgsql;

-- Find most rated movies

CREATE OR REPLACE FUNCTION find_highest_rated_movies()
RETURNS SETOF text AS $$
BEGIN
  RETURN QUERY EXECUTE
  'SELECT m
  FROM movies m, (SELECT movie_id FROM ratings WHERE rating = 5) wm
  WHERE m.id = wm.movie_id';

END;
$$ LANGUAGE plpgsql;

SELECT find_movies_like('Star Wars', 5, 10);
SELECT find_actors_starring_movie('Star Wars');
SELECT find_movies_by_actor('Mark Hamill', 10);
SELECT find_top5('Star Wars');
SELECT find_top5('Mark Hamill');
SELECT find_watched_movies(1);

SELECT find_similar_user(542, 15) LIMIT 1;
SELECT find_highest_rated_movies();
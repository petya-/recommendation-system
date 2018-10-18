

CREATE OR REPLACE FUNCTION getPersonalizedRecommendations( user_id text)
RETURNS SETOF text AS $$
DECLARE
  max_count CONSTANT integer := 5;
  mc text;
BEGIN

  SELECT * INTO mc FROM MOVIES WHERE title = movie_or_actor;

  IF NOT FOUND THEN
    RETURN QUERY SELECT find_movies_with(movie_or_actor) LIMIT max_count;
  ELSE
    RETURN QUERY SELECT find_movies_like(movie_or_actor, 5) LIMIT max_count;
  END IF;

END;
$$ LANGUAGE plpgsql;
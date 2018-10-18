\connect lhrDB

CREATE OR REPLACE FUNCTION searchMovie (titlename text) RETURNS TABLE (result text) AS $$
    BEGIN
        RETURN QUERY(SELECT title FROM movies WHERE title % titlename);
    END;
    $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION searchActor (titlename text) RETURNS TABLE (result text) AS $$
    BEGIN
        RETURN QUERY(SELECT name FROM actors WHERE name % titlename);
    END;
    $$ LANGUAGE plpgsql;

SELECT id 
  FROM users
 WHERE email = 'johndoe@mail.com' 
   AND password = crypt('johnssecretpassword', password);

SELECT id 
  FROM users
 WHERE email = 'johndoe@mail.com' 
   AND password = crypt('docker', password);

SELECT searchMovie('Do hard');

SELECT searchActor('Clit Eastwood');

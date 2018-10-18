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

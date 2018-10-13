-- Database: lhrDB

CREATE DATABASE "lhrDB"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

-- Create schema: public

CREATE SCHEMA public
    AUTHORIZATION postgres;

GRANT ALL ON SCHEMA public TO postgres;

GRANT ALL ON SCHEMA public TO PUBLIC;

-- Add needed extensions

create extension cube;
create extension fuzzystrmatch;
create extension pg_trgm;

-- Create tables

CREATE TABLE users ( 
    id SERIAL PRIMARY KEY,
    email text,
    password text,
    firstName text,
    lastName text,
    enabled boolean,
    created_at timestamp,
    updated_at timestamp
);
CREATE TABLE access_tokens ( 
    id SERIAL PRIMARY KEY,
    ttl integer,
    userId integer REFERENCES users NOT NULL, 
    created_at timestamp,
    updated_at timestamp
);
CREATE TABLE genres ( 
    id SERIAL PRIMARY KEY,
    name text UNIQUE,
    position integer,
    created_at timestamp,
    updated_at timestamp

);
CREATE TABLE movies (
    id SERIAL PRIMARY KEY,
    title text, 
    genre cube,
    release_date date,
    avg_rating float,
    created_at timestamp,
    updated_at timestamp
);
CREATE TABLE actors (
    id SERIAL PRIMARY KEY,
    name text,
    created_at timestamp,
    updated_at timestamp
);
CREATE TABLE movies_actors (
    movie_id integer REFERENCES movies NOT NULL, 
    actor_id integer REFERENCES actors NOT NULL, 
    UNIQUE (movie_id, actor_id),
    created_at timestamp,
    updated_at timestamp
);
CREATE TABLE user_movies_lists ( 
    id SERIAL PRIMARY KEY,
    name text,
    movie_id integer REFERENCES movies NOT NULL, 
    user_id integer REFERENCES users NOT NULL, 
    created_at timestamp,
    updated_at timestamp
);
CREATE TABLE ratings (
    id SERIAL PRIMARY KEY,
    rating integer,
    movie_id integer REFERENCES movies NOT NULL, 
    user_id integer REFERENCES users NOT NULL, 
    created_at timestamp,
    updated_at timestamp
);

-- Create indexes

CREATE INDEX movies_actors_movie_id ON movies_actors (movie_id); 
CREATE INDEX movies_actors_actor_id ON movies_actors (actor_id); 
CREATE INDEX movies_genres_cube ON movies USING gist (genre);
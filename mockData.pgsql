-- Connect to the database
\connect lhrDB

-- Add extension for encryption 

create extension pgcrypto;

-- Populate user table

INSERT INTO users (email, password) VALUES (
  'johndoe@mail.com',
  crypt('johnssecretpassword', gen_salt('bf'))
);

SELECT id 
  FROM users
 WHERE email = 'johndoe@mail.com' 
   AND password = crypt('johnssecretpassword', password);

SELECT id 
  FROM users
 WHERE email = 'johndoe@mail.com' 
   AND password = crypt('docker', password);
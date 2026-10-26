-- Query to insert an admin user
INSERT INTO user_account (id, account_type, username, pass, email)
VALUES (1, 'admix', 'enrique.sotelo', md5('3leF4n7E'),'admin@example.com');

-- Query to insert a client user
INSERT INTO user_account (account_type, pass, email)
VALUES ('clientx', md5('password'), 'cliente@example.com');

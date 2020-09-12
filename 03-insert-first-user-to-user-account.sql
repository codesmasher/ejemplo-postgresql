-- insert system account
-- after insert this, no other account could have an empty string as username
INSERT INTO user_account (id, account_type, username, pass, email)
VALUES (0, 'system', '', md5('@dMiN-2607'), 'sotelo.enrique@gmail.com');

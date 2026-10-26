-- primary key
ALTER TABLE user_account
  ADD CONSTRAINT user_key PRIMARY KEY(id);

-- foreing key
ALTER TABLE user_account
  ADD CONSTRAINT parent_user_fkey FOREIGN KEY (parent)
    REFERENCES user_account (id) MATCH SIMPLE
    ON UPDATE CASCADE ON DELETE RESTRICT; 

-- unique keys
ALTER TABLE user_account
  ADD CONSTRAINT username_unique UNIQUE (username);

ALTER TABLE user_account
  ADD CONSTRAINT email_uniqie UNIQUE (email);

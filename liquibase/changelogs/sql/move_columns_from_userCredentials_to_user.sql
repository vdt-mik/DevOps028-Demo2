--create columns in user table
ALTER TABLE "user"
  ADD COLUMN login VARCHAR(45) UNIQUE;

ALTER TABLE "user"
  ADD COLUMN password VARCHAR(45);

ALTER TABLE "user"
  ADD COLUMN user_role VARCHAR(45);

-- fill colums with data
UPDATE "user" u
SET
  login     = c.login,
  password  = c.password,
  user_role = c.user_role
FROM user_credentials c
WHERE u.user_credentials_id = c.id;

-- add constraints
ALTER TABLE "user"
  ALTER COLUMN login SET NOT NULL;
ALTER TABLE "user"
  ALTER COLUMN password SET NOT NULL;
ALTER TABLE "user"
  ALTER COLUMN user_role SET NOT NULL;

-- drop foreign key in user table watching on credentials table and drop table
ALTER TABLE "user"
  DROP CONSTRAINT fk_user_user_credentials1;
ALTER TABLE "user"
  DROP COLUMN user_credentials_id;
DROP TABLE user_credentials;
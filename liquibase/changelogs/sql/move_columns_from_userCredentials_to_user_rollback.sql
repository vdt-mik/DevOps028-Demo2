--create table user_credentials with one more column which is reference on user owner
CREATE TABLE user_credentials (
  id        BIGSERIAL             NOT NULL PRIMARY KEY,
  login     CHARACTER VARYING(45) NOT NULL UNIQUE,
  password  CHARACTER VARYING(45) NOT NULL,
  user_role CHARACTER VARYING(45) NOT NULL,
  user_id   BIGINT                NOT NULL
);

--create column user_credentials_id
ALTER TABLE "user"
  ADD COLUMN user_credentials_id BIGSERIAL;

--fill table with data, update foreign key in user table
INSERT INTO user_credentials (login, password, user_role, user_id)
  SELECT
    u.login,
    u.password,
    u.user_role,
    u.id
  FROM "user" u;

UPDATE "user" u
SET
  user_credentials_id = c.id
FROM user_credentials c
WHERE u.id = c.user_id;

--add foreign key constraint
ALTER TABLE "user"
  ADD CONSTRAINT fk_user_user_credentials1
FOREIGN KEY (user_credentials_id)
REFERENCES user_credentials;

--say that user user_credentials_id column must not be null
ALTER TABLE "user"
  ALTER COLUMN user_credentials_id SET NOT NULL;

--remove additional column user_id in user_credential table we needed for migration
ALTER TABLE user_credentials DROP COLUMN user_id;

ALTER TABLE "user" DROP COLUMN login;
ALTER TABLE "user" DROP COLUMN password;
ALTER TABLE "user" DROP COLUMN user_role;
ALTER TABLE user_credentials
  DROP CONSTRAINT fk_user_credentials_user_role12;
ALTER TABLE user_credentials
  DROP COLUMN user_role_id;
DROP TABLE user_role;
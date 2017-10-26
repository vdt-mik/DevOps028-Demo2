CREATE TABLE user_role (
  id   BIGINT                NOT NULL,
  name CHARACTER VARYING(45) NOT NULL
);

ALTER TABLE "user_credentials"
  ADD COLUMN user_role_id BIGINT NOT NULL;

ALTER TABLE ONLY user_role
  ADD CONSTRAINT "primary key9" PRIMARY KEY (id);

ALTER TABLE ONLY user_credentials
  ADD CONSTRAINT fk_User_credentials_User_role12 FOREIGN KEY (user_role_id) REFERENCES user_role (id);

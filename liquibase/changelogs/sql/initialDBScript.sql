SET client_encoding = 'UTF8';

CREATE TABLE address (
  id bigserial NOT NULL PRIMARY KEY,
  Contacts_id bigint NOT NULL,
  address character varying(45) NOT NULL
);

CREATE TABLE common_item (
  Department_id bigint NOT NULL,
  Item_id bigint NOT NULL PRIMARY KEY
);

CREATE TABLE common_item_department_owners (
  Common_item_Item_id bigint NOT NULL,
  Department_id bigint NOT NULL
);

CREATE TABLE contacts (
  id bigserial NOT NULL PRIMARY KEY
);

CREATE TABLE department (
  id bigserial NOT NULL PRIMARY KEY,
  Contacts_id bigint NOT NULL,
  name character varying(45) NOT NULL
);

CREATE TABLE email (
  id bigserial NOT NULL PRIMARY KEY,
  Contacts_id bigint NOT NULL,
  email character varying(45) NOT NULL
);

CREATE TABLE item (
  id bigserial NOT NULL PRIMARY KEY,
  isWorking boolean NOT NULL,
  manufacturer character varying(45) NOT NULL,
  model character varying(45) NOT NULL,
  start_price numeric(10,2) NOT NULL,
  current_price numeric(10,2) NOT NULL,
  Parent_item_id bigint,
  nominal_resource numeric(15,2) NOT NULL,
  description character varying(45) NOT NULL
);

CREATE TABLE item_event_type (
  id bigserial NOT NULL PRIMARY KEY,
  name character varying(45) NOT NULL
);

CREATE TABLE item_log (
  id bigserial NOT NULL PRIMARY KEY,
  Item_id bigint NOT NULL,
  event_date timestamp without time zone NOT NULL,
  description character varying(45) NOT NULL,
  Item_event_type_id bigint NOT NULL
);

CREATE TABLE phone (
  id bigserial NOT NULL PRIMARY KEY,
  Contacts_id bigint NOT NULL,
  phone character varying(45) NOT NULL
);

CREATE TABLE private_item (
  User_id bigint NOT NULL,
  Item_id bigint NOT NULL PRIMARY KEY,
  Usage_start_date timestamp without time zone
);

CREATE TABLE private_item_user_owners (
  Private_item_Item_id bigint NOT NULL,
  User_id bigint NOT NULL
);

CREATE TABLE "user" (
  id bigserial NOT NULL PRIMARY KEY,
  User_credentials_id bigint NOT NULL,
  Contacts_id bigint NOT NULL,
  Department_id bigint NOT NULL,
  isActive boolean NOT NULL,
  firstname character varying(45) NOT NULL,
  lastname character varying(45) NOT NULL
);

CREATE TABLE user_common_item_event (
  id bigserial NOT NULL PRIMARY KEY,
  User_id bigint NOT NULL,
  Common_item_Item_id bigint NOT NULL,
  usage_start_date timestamp without time zone NOT NULL,
  usage_end_date timestamp without time zone NOT NULL,
  usage_duration numeric(3,2)
);

CREATE TABLE user_credentials (
  id bigserial NOT NULL PRIMARY KEY,
  login character varying(45) NOT NULL,
  password character varying(45) NOT NULL,
  User_role_id bigint NOT NULL
);

CREATE TABLE user_role (
  id bigserial NOT NULL PRIMARY KEY,
  name character varying(45) NOT NULL
);

ALTER TABLE ONLY address
  ADD CONSTRAINT fk_Address_Contacts1 FOREIGN KEY (Contacts_id) REFERENCES contacts(id);

ALTER TABLE ONLY common_item
  ADD CONSTRAINT fk_Common_item_Department1 FOREIGN KEY (Department_id) REFERENCES department(id);

ALTER TABLE ONLY common_item
  ADD CONSTRAINT fk_Common_item_Item3 FOREIGN KEY (Item_id) REFERENCES item(id);

ALTER TABLE ONLY common_item_department_owners
  ADD CONSTRAINT fk_Common_item_department_owners_Common_item1 FOREIGN KEY (Common_item_Item_id) REFERENCES common_item(Item_id);

ALTER TABLE ONLY common_item_department_owners
  ADD CONSTRAINT fk_Common_item_department_owners_Department1 FOREIGN KEY (Department_id) REFERENCES department(id);

ALTER TABLE ONLY department
  ADD CONSTRAINT fk_Department_Contacts1 FOREIGN KEY (Contacts_id) REFERENCES contacts(id);

ALTER TABLE ONLY email
  ADD CONSTRAINT fk_Email_Contacts1 FOREIGN KEY (Contacts_id) REFERENCES contacts(id);

ALTER TABLE ONLY item
  ADD CONSTRAINT fk_Item_Item1 FOREIGN KEY (Parent_item_id) REFERENCES item(id);

ALTER TABLE ONLY item_log
  ADD CONSTRAINT fk_Item_log_Item1 FOREIGN KEY (Item_id) REFERENCES item(id);

ALTER TABLE ONLY item_log
  ADD CONSTRAINT fk_Item_log_Item_event_type1 FOREIGN KEY (Item_event_type_id) REFERENCES item_event_type(id);

ALTER TABLE ONLY phone
  ADD CONSTRAINT fk_Phone_Contacts1 FOREIGN KEY (Contacts_id) REFERENCES contacts(id);

ALTER TABLE ONLY private_item
  ADD CONSTRAINT fk_Private_item_Item1 FOREIGN KEY (Item_id) REFERENCES item(id);

ALTER TABLE ONLY private_item
  ADD CONSTRAINT fk_Private_item_Item2 FOREIGN KEY (User_id) REFERENCES "user" (id);

ALTER TABLE ONLY private_item_user_owners
  ADD CONSTRAINT fk_Private_item_user_owners_Private_item1 FOREIGN KEY (Private_item_Item_id) REFERENCES private_item(Item_id);

ALTER TABLE ONLY private_item_user_owners
  ADD CONSTRAINT fk_Private_item_user_owners_Private_item2 FOREIGN KEY (User_id) REFERENCES "user" (id);

ALTER TABLE ONLY "user"
  ADD CONSTRAINT fk_User_Contacts1 FOREIGN KEY (Contacts_id) REFERENCES contacts(id);

ALTER TABLE ONLY "user"
  ADD CONSTRAINT fk_User_Department2 FOREIGN KEY (Department_id) REFERENCES department(id);

ALTER TABLE ONLY "user"
  ADD CONSTRAINT fk_User_User_credentials1 FOREIGN KEY (User_credentials_id) REFERENCES user_credentials(id);

ALTER TABLE ONLY user_common_item_event
  ADD CONSTRAINT fk_User_common_item_event_Common_item1 FOREIGN KEY (Common_item_Item_id) REFERENCES common_item(Item_id);

ALTER TABLE ONLY user_common_item_event
  ADD CONSTRAINT fk_User_common_item_event_Common_item2 FOREIGN KEY (User_id) REFERENCES "user" (id);

ALTER TABLE ONLY user_credentials
  ADD CONSTRAINT fk_User_credentials_User_role12 FOREIGN KEY (User_role_id) REFERENCES user_role(id);
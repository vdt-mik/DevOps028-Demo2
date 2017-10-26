-- Contacts
INSERT INTO contacts default values;
INSERT INTO contacts default values;
INSERT INTO contacts default values;
INSERT INTO contacts default values;

-- Addresses
INSERT INTO address(contacts_id, address) VALUES (1, 'Address_id1');
INSERT INTO address(contacts_id, address) VALUES (2, 'Address_id2');
INSERT INTO address(contacts_id, address) VALUES (3, 'Address_id3');
INSERT INTO address(contacts_id, address) VALUES (4, 'Address_id4');

-- Emails
INSERT INTO email(contacts_id, email) VALUES (1, 'email_id1');
INSERT INTO email(contacts_id, email) VALUES (2, 'email_id2');
INSERT INTO email(contacts_id, email) VALUES (3, 'email_id3');
INSERT INTO email(contacts_id, email) VALUES (4, 'email_id4');

-- Phones
INSERT INTO phone(contacts_id, phone) VALUES (1, 'phone_id1');
INSERT INTO phone(contacts_id, phone) VALUES (2, 'phone_id2');
INSERT INTO phone(contacts_id, phone) VALUES (3, 'phone_id3');
INSERT INTO phone(contacts_id, phone) VALUES (4, 'phone_id4');

-- Departments
INSERT INTO department(contacts_id, name) VALUES (1, 'Department 1');
INSERT INTO department(contacts_id, name) VALUES (2, 'Department 2');
INSERT INTO department(contacts_id, name) VALUES (3, 'Department 3');
INSERT INTO department(contacts_id, name) VALUES (4, 'Department 4');

-- Users
INSERT INTO "user"(
  contacts_id, department_id, isactive, firstname, lastname, login, password, user_role)
VALUES (
  1, 1, TRUE, 'User', 'Admin', 'login1', 'pass', 'ADMIN');
INSERT INTO "user"(
  contacts_id, department_id, isactive, firstname, lastname, login, password, user_role)
VALUES (
  2, 2, TRUE, 'User', 'Manager', 'login2', 'pass', 'MANAGER');
INSERT INTO "user"(
  contacts_id, department_id, isactive, firstname, lastname, login, password, user_role)
VALUES (
  3, 3, TRUE, 'User', 'User', 'login3', 'pass', 'USER');
INSERT INTO "user"(
  contacts_id, department_id, isactive, firstname, lastname, login, password, user_role)
VALUES (
  4, 4, FALSE, 'Inactive', 'User', 'login4', 'pass', 'USER');

-- Items
INSERT INTO item(
  isworking, manufacturer, model, start_price, current_price, nominal_resource, description, manufacture_date, aging_factor)
VALUES (TRUE, 'Manufacturer', 'Model', 100, 90, 2, 'Parent item', '2017-06-18 01:39:42.090000', 3);
INSERT INTO item(
  isworking, manufacturer, model, start_price, current_price, nominal_resource, description, manufacture_date, aging_factor)
VALUES (FALSE, 'Manufacturer', 'Model', 100, 90, 2, 'Parent item', '2017-06-18 01:39:42.090000', 3);
INSERT INTO item(
  isworking, manufacturer, model, start_price, current_price, parent_item_id, nominal_resource, description, manufacture_date, aging_factor)
VALUES (TRUE, 'Manufacturer', 'Model', 100, 90, 1, 2, 'Private item', '2017-06-18 01:39:42.090000', 3);
INSERT INTO item(
  isworking, manufacturer, model, start_price, current_price, parent_item_id, nominal_resource, description, manufacture_date, aging_factor)
VALUES (FALSE, 'Manufacturer', 'Model', 100, 90, 2, 2, 'Common item', '2017-06-18 01:39:42.090000', 3);
INSERT INTO item(
  isworking, manufacturer, model, start_price, current_price, nominal_resource, description, manufacture_date, aging_factor)
VALUES (TRUE, 'Manufacturer', 'Model', 100, 90, 2, 'Private item 2', '2017-06-18 01:39:42.090000', 3);
INSERT INTO item(
  isworking, manufacturer, model, start_price, current_price, nominal_resource, description, manufacture_date, aging_factor)
VALUES (TRUE, 'Manufacturer', 'Model', 100, 90, 2, 'Common item 2', '2017-06-18 01:39:42.090000', 3);

-- Specify Private and Common items in their tables
INSERT INTO private_item(user_id, item_id, usage_start_date) VALUES (1, 3, '2017-06-19 01:39:42.090000');
INSERT INTO common_item(department_id, item_id) VALUES (2, 4);
INSERT INTO private_item(user_id, item_id, usage_start_date) VALUES (3, 5, '2017-06-19 01:39:42.090000');
INSERT INTO common_item(department_id, item_id) VALUES (4, 6);
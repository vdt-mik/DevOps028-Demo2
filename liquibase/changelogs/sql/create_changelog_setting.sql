CREATE TABLE setting (
  id bigserial NOT NULL PRIMARY KEY,
  is_active boolean NOT NULL,
  microservice_host character varying(45) NOT NULL,
  kafka_host character(45) NOT NULL
);
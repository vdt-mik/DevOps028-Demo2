CREATE TABLE item_event_type (
  id   BIGINT                NOT NULL,
  name CHARACTER VARYING(45) NOT NULL
);

ALTER TABLE item_log
  ADD COLUMN item_event_type_id BIGINT NOT NULL;

ALTER TABLE ONLY item_event_type
  ADD CONSTRAINT "primary key6" PRIMARY KEY (id);

ALTER TABLE ONLY item_log
  ADD CONSTRAINT fk_Item_log_Item_event_type1 FOREIGN KEY (Item_event_type_id) REFERENCES
  item_event_type (id);
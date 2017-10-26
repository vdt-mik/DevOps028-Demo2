ALTER TABLE item_log
  DROP CONSTRAINT fk_item_log_item_event_type1;
ALTER TABLE item_log
  DROP COLUMN item_event_type_id;
DROP TABLE item_event_type;
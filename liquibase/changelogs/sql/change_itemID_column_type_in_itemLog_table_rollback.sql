ALTER TABLE item_log
  ALTER COLUMN item_id TYPE BIGINT;
ALTER TABLE item_log
  ADD CONSTRAINT fk_item_log_item
  FOREIGN KEY (item_id)
  REFERENCES item(id);

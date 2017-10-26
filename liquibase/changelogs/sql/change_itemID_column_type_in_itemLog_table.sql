ALTER TABLE item_log
  DROP CONSTRAINT fk_item_log_item1;
ALTER TABLE item_log
  ALTER COLUMN item_id TYPE VARCHAR(20);
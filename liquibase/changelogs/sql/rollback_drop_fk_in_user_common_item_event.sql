ALTER TABLE ONLY user_common_item_event
  ADD CONSTRAINT fk_User_common_item_event_Common_item1
  FOREIGN KEY (Common_item_Item_id)
  REFERENCES common_item(Item_id);
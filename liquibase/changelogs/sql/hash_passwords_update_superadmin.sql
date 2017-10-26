UPDATE "user"
SET login   = 'superadmin',
  firstname = 'superadmin',
  password  = '$2a$10$A/JOBnAAh6lC5mr3hVo7a.s2R28AN118nYuF16t.iy47s3jG.dvZi'
WHERE login = 'login1';

UPDATE "user"
SET password = '$2a$10$6kY5TeqvBCaLfNeN9SpDMOPX./xWBj5Qrc0TenBAgdobTDSsn3MuK'
WHERE password = 'pass';
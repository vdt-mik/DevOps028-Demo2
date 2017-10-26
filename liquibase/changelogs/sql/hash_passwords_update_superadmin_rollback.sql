UPDATE "user"
SET login   = 'login1',
  firstname = 'User',
  password  = 'pass'
WHERE login = 'superadmin';

UPDATE "user"
SET password = 'pass'
WHERE password = '$2a$10$6kY5TeqvBCaLfNeN9SpDMOPX./xWBj5Qrc0TenBAgdobTDSsn3MuK';

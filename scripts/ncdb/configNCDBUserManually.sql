create user <MEDREC_DB_USER_NAME> identified by <MEDREC_DB_USER_PASSWORD>;
GRANT CONNECT TO <MEDREC_DB_USER_NAME>; 
grant create session to <MEDREC_DB_USER_NAME>;
grant create table,create view to <MEDREC_DB_USER_NAME>; 
grant create procedure to <MEDREC_DB_USER_NAME>;
grant create synonym, create trigger to <MEDREC_DB_USER_NAME>;
grant unlimited tablespace to <MEDREC_DB_USER_NAME>;
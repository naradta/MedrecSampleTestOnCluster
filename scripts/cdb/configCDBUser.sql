ALTER SESSION SET CONTAINER = &1; -- Applicable only for CDB
create user &2 identified by &3;
GRANT CONNECT TO &2; 
grant create session to &2;
grant create table,create view to &2; 
grant create procedure to &2;
grant create synonym, create trigger to &2;
grant unlimited tablespace to &2;


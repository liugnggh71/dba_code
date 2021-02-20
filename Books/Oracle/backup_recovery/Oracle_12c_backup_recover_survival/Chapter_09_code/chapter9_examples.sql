--- Author: Francisco Munoz Alvarez
--- Date  : 20/07/2013
--- Script: chapter9_examples.sql
--- Description: All examples done on chapter 9

--- Datafile Copy

SQL> EXECUTE DBMS_TTS.TRANSPORT_SET_CHECK('test_1', TRUE);
SQL> EXECUTE DBMS_TTS.TRANSPORT_SET_CHECK('test_1,test_2', TRUE);
SQL> SELECT * FROM TRANSPORT_SET_VIOLATIONS;

--- Roles for Data Pump

SQL> GRANT DATAPUMP_EXP_FULL_DATABASE, DATAPUMP_IMP_FULL_DATABASE TO fcomunoz;

--- Creating Directory Objects

SQL> CREATE OR REPLACE DIRECTORY datapump AS ‘/u01/db_backups’;
SQL> GRANT READ, WRITE ON DIRECTORY datapump to fcomunoz;
SQL> SELECT * FROM DBA_DIRECTORIES WHERE DIRECTORY_NAME = 'DATAPUMP';

--- Schema Export and Import

SQL> CREATE USER test IDENTIFIED BY test DEFAULT TABLESPACE users QUOTA UNLIMITED ON users;

SQL> GRANT CREATE SESSION, RESOURCE TO test;

SQL> CREATE TABLE TEST.EMPLOYEE  
( EMP_ID   NUMBER(10) NOT NULL,
  EMP_NAME VARCHAR2(30),
  EMP_SSN  VARCHAR2(9),
  EMP_DOB  DATE
)
/

SQL> INSERT INTO test.employee VALUES (101,'Francisco Munoz',123456789,TO_DATE('30-JUN-73',’DD-MON-YY’));

SQL> INSERT INTO test.employee VALUES (102,'Gonzalo Munoz',234567890,TO_DATE('02-OCT-96',’DD-MON-YY’));

SQL> INSERT INTO test.employee VALUES (103,'Evelyn Aghemio',659812831,TO_DATE('02-OCT-79',’DD-MON-YY’));

SQL> COMMIT;

$ expdp fcomunoz/alvarez@pdborcl directory=datapump dumpfile=test.dmp logfile=test.log  schemas=test reuse_dumpfiles=y

$ ls -lrt /u01/db_backups

SQL> DROP USER test CASCADE;

$ impdp fcomunoz/alvarez@pdborcl directory=datapump dumpfile=test.dmp logfile=imp_test.log

$ sqlplus test/test@pdborcl

SQL> SELECT * FROM test.employee

--- Exporting and Importing Tables

$ expdp fcomunoz/alvarez@pdborcl directory=datapump dumpfile=employee.dmp logfile=employee.log  tables=test.employee

SQL> DROP TABLE test.employee PURGE;

$ impdp fcomunoz/alvarez@pdborcl directory=datapump dumpfile=employee.dmp logfile=imp_employee.log

SQL> SELECT * FROM test.employee;

--- Exporting and Importing a database/pluggable database

$ expdp fcomunoz/alvarez@pdborcl directory=datapump dumpfile=full_pdborcl.dmp logfile=full_pdborcl.log  full=y 

$ sqlplus / as sysdba

SQL> alter pluggable database pdborcl close;

SQL> drop pluggable database pdborcl including datafiles;

SQL> CREATE PLUGGABLE DATABASE pdborcl ADMIN USER pdb_admin IDENTIFIED BY oracle
  2    STORAGE (MAXSIZE 2G MAX_SHARED_TEMP_SIZE 100M)
  3    DEFAULT TABLESPACE Users
  4      DATAFILE '/u01/app/oracle/oradata/orcl/pdborcl/datafile1.dbff' SIZE 250M AUTOEXTEND ON
  5    PATH_PREFIX = '/u01/app/oracle/oradata/orcl/pdborcl/'
  6    FILE_NAME_CONVERT = ('/u01/app/oracle/oradata/orcl/pdbseed/', '/u01/app/oracle/oradata/orcl/pdborcl/');

SQL> ALTER PLUGGABLE DATABASE pdborcl OPEN;

SQL> ALTER SESSION SET CONTAINER=pdborcl;

SQL> CREATE USER fcomunoz IDENTIFIED BY alvarez DEFAULT TABLESPACE users QUOTA UNLIMITED ON users;

SQL> GRANT CREATE SESSION, RESOURCE, DATAPUMP_EXP_FULL_DATABASE, DATAPUMP_IMP_FULL_DATABASE TO fcomunoz;

SQL> CREATE OR REPLACE DIRECTORY datapump AS ‘/u01/db_backups’;

SQL> GRANT READ, WRITE ON DIRECTORY datapump to fcomunoz;

$ impdp fcomunoz/alvarez@pdborcl directory=datapump dumpfile= full_pdborcl.dmp logfile=imp_full_pdborcl.log  

--- Using Export to estimate space

$ expdp fcomunoz/alvarez@pdborcl directory=datapump schemas=test estimate_only=y logfile=est_test.log

--- Parallel Full Database Export and interactive mode

$ expdp fcomunoz/alvarez@pdborcl directory=datapump dumpfile=full_%U.dmp parallel=4 logfile=full.log full=y

$ impdp fcomunoz/alvarez@pdborcl directory=datapump dumpfile=full_%U.dmp parallel=4 logfile=imp_full.log

$ expdp fcomunoz/alvarez@pdborcl dumpfile=full2_%U.dmp filesize=5g parallel=4 logfile=imp_full2.log job_name=expfull full=y directory=datapump

--- Importing Metadata only

$ expdp fcomunoz/alvarez@pdborcl directory=datapump schemas=test dumpfile=shema_test.dmp logfile=schema_test.log

$impdp fcomunoz/alvarez@pdborcl2 directory=datapump dumpfile=shema_test.dmp logfile=imp_schema_test.log content=metadata_only table_exists_action=replace

--- Exporting Views as table

$ sqlplus fcomunoz/alvarez@pdborcl

SQL>  CREATE VIEW test.employee_view AS 
 2    SELECT *
 3    FROM employee;

SQL> SELECT * FROM test.employee_view;

SQL> exit

$ expdp fcomunoz/alvarez@pdborcl directory=datapump dumpfile= employee_view.dmp logfile=employee_view.log views_as_tables=test.employee_view

$ impdp fcomunoz/alvarez@pdborcl directory=datapump dumpfile=employee_view.dmp sqlfile=employee_view.sql

$ cat employee_view.sql

--- Importing data using a network link

$ sqlplus fcomunoz/alvarez@pdborcl2

SQL> CREATE DATABASE LINK pdborcl_lnk CONNECT TO fcomunoz IDENTIFIED by alvarez USING 'pdborcl';

SQL> SELECT * FROM employee@pdborcl_lnk;

SQL> SELECT * FROM test.employee;

$ impdp fcomunoz/alvarez@pdborcl2 schemas=test directory=datapump network_link=pdborcl_lnk logfile=pdborcl_lnk.log

$ sqlplus fcomunoz/alvarez@pdborcl2

SQL> SELECT * FROM test.employee;
















































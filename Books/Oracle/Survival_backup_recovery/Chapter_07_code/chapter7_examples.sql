--- Author: Francisco Munoz Alvarez
--- Date  : 20/07/2013
--- Script: chapter7_examples.sql
--- Description: All examples done on chapter 7

SQL> SELECT type, records_total, records_used,con_id 
 2   FROM   V$controlfile_record_section;

SQL> oradebug setmypid
> oradebug dump controlf 5
SQL> oradebug tracefile_name
      /u01/app/oracle/diag/rdbms/acdb/acdb/trace/acdb_ora_7502.trc
SQL> exit

--- Creating RMAn Catalog

$ RMAN target sysbackup CATALOG=rcat_owner/rcat@rcatdb
 sqlplus sys/oracle@apdb as sysdba
SQL> CREATE TABLESPACE rcat_tbs 
 2   DATAFILE
 3  '/u01/app/oracle/oradata/acdb/apdb/rcattbs.dbf' size 400m;

SQL> create user rcat_adm identified by rcat
 2   default tablespace rcat_tbs 
 3   quota unlimited on rcat_tbs temporary tablespace temp;

SQL> grant connect, resource, recovery_catalog_owner to rcat_adm;

SQL> CREATE USER rcat_adm IDENTIFIED BY rcat 
 2   DEFAULT TABLESPACE rcat_tbs 
 3   QUOTA UNLIMITED ON rcat_tbs TEMPORARY TABLESPACE temp;

SQL> GRANT connect, resource, recovery_catalog_owner TO rcat_adm;

$ rman target / catalog=rcat_adm/rcat@apdb
RMAN> CREATE CATALOG;
RMAN> exit
$ rman target / catalog=rcat_adm/rcat@apdb
RMAN> REPORT SCHEMA;
RMAN> REGISTER DATABASE;
RMAN> REPORT SCHEMA;

--- Resynchronization of Catalog with Control File

RMAN> RESYNC CATALOG;

--- Consolidation of Catalogs

$ rman target
RMAN> CONNECT CATALOG rcat_adm/rcat
RMAN> IMPORT CATALOG rcv11/rcat@orcl1123;
RMAN> exit
SQL> CONNECT rcv11/rcat
SQL> SELECT * FROM rcver;
$ rman target / catalog=rcv11/rcat@orcl1123
RMAN> UPGRADE CATALOG;
RMAN> UPGRADE CATALOG;
SQL> SELECT * FROM rcver;
$ rman target / catalog=rcat_adm/rcat
RMAN> IMPORT CATALOG rcv11/rcat@orcl1123;
$ rman target / catalog=rcv11/rcat
RMAN> LIST INCARNATION;
RMAN> REPORT SCHEMA;
RMAN> LIST INCARNATION;

--- Creating Virtual Catalog

$ sqlplus / as sysdba

SQL> CREATE USER vpsuser IDENTIFIED BY vpcpwd DEFAULT TABLESPACE users QUOTA UNLIMITED ON users;

SQL> GRANT recovery_catalog_owner TO vpsuser;

$ rman target / catalog=rcat_adm/rcat

RMAN> GRANT catalog FOR DATABASE orcl1123 TO vpsuser
RMAN> GRANT REGISTER DATABASE TO vpsuser;
RMAN> exit

$ rman target / catalog=vpsuser/vpcpwd
RMAN> CREATE VIRTUAL CATALOG;
RMAN> LIST INCARNATION;
RMAN> LIST db_unique_name ALL;

RMAN> REVOKE CATALOG FOR DATABASE orcl1123 FROM vpcuser;
$  rman target / catalog=vpcuser/vpcpwd
RMAN> DROP CATALOG;
RMAN> DROP CATALOG;

--- Creating and Managing Stored Scripts

RMAN> CREATE SCRIPT test_scr{
2> BACKUP TABLESPACE system;
3> }

RMAN> LIST SCRIPT NAMES;
RMAN> PRINT SCRIPT test_scr;
RMAN> run{execute script test_scr;}
RMAN> REPLACE SCRIPT test_scr 
2> {backup tablespace sysaux;}

RMAN> PRINT SCRIPT test_scr;
RMAN> DELETE SCRIPT test_scr;
RMAN> LIST SCRIPTS NAME;

$ rman TARGET / CATALOG rcat@rcatdb SCRIPT '/u01/app/oracle/fbkp.cmd';

--- Catalog non-catalog backups

RMAN> CATALOG datafilecopy '/u01/app/oracle/system01.dbf';

--- Unregister Database

RMAN> UNREGISTER DATABASE;
$ rman target / catalog=rcat_adm/rcat
RMAN> DROP CATALOG;
RMAN> DROP CATALOG;

--- Reporting in RMAN

RMAN> LIST BACKUP SUMMARY;
RMAN> LIST BACKUP BY FILE;
RMAN> LIST BACKUP;









 



































 /




















--- Author: Francisco Munoz Alvarez
--- Date  : 20/07/2013
--- Script: chapter3_examples.sql
--- Description: All examples done on chapter 3

RMAN> BACKUP DATABASE; (To backup the CBD + all PDBs) 
RMAN> BACKUP PLUGGABLE DATABASE pdb1,pdb2; (To backup all specified PDBs)
RMAN> BACKUP TABLESPACE pdb1:example; (To backup a specific tablespace in a PDB)
RMAN> RESTORE DATABASE; (To restore an entire CDB, including all PDBs)
RMAN> RESTORE DATABASE root; (To restore only thr root container)
RMAN> RESTORE PLUGGABLE DATABASE pdb1; (To restore an specific PDB)
RMAN> RESTORE TABLESPACE pdb1:example; (To restore a tablespace in a PDB) 
RMAN> RECOVER DATABASE; (Root plus all PDBs)
RMAN> RUN {
		SET UNTIL SCN 1428;
		RESTORE DATABASE;
		RECOVER DATABASE;
		ALTER DATABASE OPEN RESETLOGS; } 
RMAN> RUN {
		RESTORE PLUGGABLE DATABASE pdb1 TO RESTORE POINT one;
		RECOVER PLUGGABLE DATABASE pdb1 TO RESTORE POINT one;
		ALTER PLUGGABLE DATABASE pdb1 OPEN RESETLOGS;}
;

sqlplus / as sysdba

SQL> SET PAGES 999
SQL> SET LINES 99
SQL> COL USERNAME 	FORMAT A21
SQL> COL ACCOUNT_STATUS FORMAT A20
SQL> COL LAST_LOGIN 	FORMAT A41 
SQL> SELECT username, account_status, last_login FROM dba_users;

USERNAME     ACCOUNT_STATUS       LAST_LOGIN
------------ -------------------- -----------------------SYSBACKUP    EXPIRED & LOCKED

SQL>

SQL> ALTER USER sysbackup IDENTIFIED BY "demo" ACCOUNT UNLOCK;

User altered.

SQL> GRANT sysbackup TO sysbackup;

Grant succeeded.

SQL> SELECT username, account_status
FROM dba_users
WHERE account_status NOT LIKE '%LOCKED';

USERNAME              ACCOUNT_STATUS
--------------------- --------------------
SYS                   OPEN
SYSTEM                OPEN
SYSBACKUP             OPEN

SQL>

SQL> COL grantee FORMAT A20
SQL> SELECT * 
FROM dba_sys_privs      
WHERE grantee = 'SYSBACKUP';

GRANTEE       PRIVILEGE                           ADM COM
------------- ----------------------------------- --- ---
SYSBACKUP     ALTER SYSTEM                        NO  YES
SYSBACKUP     AUDIT ANY                           NO  YES
SYSBACKUP     SELECT ANY TRANSACTION              NO  YES
SYSBACKUP     SELECT ANY DICTIONARY               NO  YES
SYSBACKUP     RESUMABLE                           NO  YES
SYSBACKUP     CREATE ANY DIRECTORY                NO  YES
SYSBACKUP     UNLIMITED TABLESPACE                NO  YES
SYSBACKUP     ALTER TABLESPACE                    NO  YES
SYSBACKUP     ALTER SESSION                       NO  YES
SYSBACKUP     ALTER DATABASE                      NO  YES
SYSBACKUP     CREATE ANY TABLE                    NO  YES
SYSBACKUP     DROP TABLESPACE                     NO  YES
SYSBACKUP     CREATE ANY CLUSTER                  NO  YES

13 rows selected.

SQL> COL granted_role FORMAT A30
SQL> SELECT *     
FROM dba_role_privs
WHERE grantee = 'SYSBACKUP';

GRANTEE        GRANTED_ROLE                   ADM DEF COM
-------------- ------------------------------ --- --- ---
SYSBACKUP      SELECT_CATALOG_ROLE            NO  YES YES

SQL>

RMAN> SELECT TO_CHAR(sysdate,'dd/mm/yy - hh24:mi:ss')
FROM dual;

TO_CHAR(SYSDATE,'DD
-------------------
17/09/12 - 02:58:40

RMAN>

RMAN> DESC v$datafile 

 Name                        Null?    Type
 --------------------------- -------- -------------------
 FILE#                                NUMBER                      
 CREATION_CHANGE#                     NUMBER                      
 CREATION_TIME                        DATE                        
 TS#                                  NUMBER                      
 RFILE#                               NUMBER                      
 STATUS                               VARCHAR2(7)                 
 ENABLED                              VARCHAR2(10)                
 CHECKPOINT_CHANGE#                   NUMBER                      
 CHECKPOINT_TIME                      DATE                        
 UNRECOVERABLE_CHANGE#                NUMBER                      
 UNRECOVERABLE_TIME                   DATE                        
 LAST_CHANGE#                         NUMBER                      
 LAST_TIME                            DATE                        
 OFFLINE_CHANGE#                      NUMBER                      
 ONLINE_CHANGE#                       NUMBER                      
 ONLINE_TIME                          DATE                        
 BYTES                                NUMBER                      
 BLOCKS                               NUMBER                      
 CREATE_BYTES                         NUMBER                      
 BLOCK_SIZE                           NUMBER                      
 NAME                                 VARCHAR2(513)               
 PLUGGED_IN                           NUMBER                      
 BLOCK1_OFFSET                        NUMBER                      
 AUX_NAME                             VARCHAR2(513)               
 FIRST_NONLOGGED_SCN                  NUMBER                      
 FIRST_NONLOGGED_TIME                 DATE                        
 FOREIGN_DBID                         NUMBER                      
 FOREIGN_CREATION_CHANGE#             NUMBER                      
 FOREIGN_CREATION_TIME                DATE                        
 PLUGGED_READONLY                     VARCHAR2(3)                 
 PLUGIN_CHANGE#                       NUMBER                      
 PLUGIN_RESETLOGS_CHANGE#             NUMBER                      
 PLUGIN_RESETLOGS_TIME                DATE                        
 CON_ID                               NUMBER                      

RMAN>
RMAN> ALTER TABLESPACE users
ADD DATAFILE '/u01/app/oracle/oradata/cdb1/pdb1/user02.dbf' size 50M;

Statement processed

RMAN>

RMAN> DUPLICATE TARGET DATABASE TO <CDB1>;
RMAN> DUPLICATE TARGET DATABASE TO <CDB1> 
      PLUGGABLE DATABASE <PDB1>, <PDB2>, <PDB3>;

RMAN> RECOVER DATABASE UNTIL TIME '10/12/2012 10:30:00' SNAPSHOT TIME '10/12/2012 10:00:00';

RMAN> RECOVER DATABASE UNTIL CANCEL SNAPSHOT TIME '10/12/2012 10:00:00';

SQL> SHOW PARAMETER compatible

NAME                   TYPE        VALUE
---------------------- ----------- ----------------------
compatible             string      12.0.0.0.0

SQL> SELECT open_mode FROM v$database;

OPEN_MODE
--------------------
READ WRITE

SQL>

RMAN> RECOVER TABLE SCOTT.test
     UNTIL SEQUENCE 5481 THREAD 2
     AUXILARY DESTINATION '/tmp/recover'
     REMAP TABLE SCOTT.test:my_test;

$ impdp test/test TABLES=test.test1 DIRECTORY=datapump DUMPFILE=test_test1.dmp  TRANSFORM=DISABLE_ARCHIVE_LOGGING:Y

$ expdp test/test DIRECTORY=datapump DUMPFILE=testvwasatable.dmp VIEWS_AS_TABLES=employees_v 

$ impdp test/test DIRECTORY=datapump DUMPFILE=test.dmp TRANSFORM=TABLE_COMPRESSION_CLAUSE:'COMPRESS FOR OLTP' 

$ impdp test/test DIRECTORY=datapump DUMPFILE=test.dmp TRANSFORM=LOB_STORAGE:SECUREFILE

SQL > CREATE AUDIT POLICY datapump 
ACTIONS COMPONENT=DATAPUMP EXPORT;

SQL> AUDIT POLICY datapump;
SQL> ALTER AUDIT POLICY datapump
ADD ACTION COMPONENT=DATAPUMP IMPORT;

SQL> DROP AUDIT POLICY datapump;




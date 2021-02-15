--- Author: Francisco Munoz Alvarez
--- Date  : 20/07/2013
--- Script: chapter6_examples.sql
--- Description: All examples done on chapter 6

SQL> SELECT * FROM V$rman_configuration;

RMAN> SHOW ALL;
RMAN> SHOW RETENTION POLICY;
RMAN> REPORT NEED BACKUP;
RMAN> BACKUP DATABASE;
RMAN> REPORT NEED BACKUP;
RMAN> BACKUP DATABASE PLUS ARCHIVELOG;
RMAN> REPORT NEED BACKUP;
RMAN> BACKUP DATABASE;
RMAN> REPORT OBSOLETE;
RMAN> CONFIGURE RETENTION POLICY TO REDUNDANCY 3;
RMAN> SHOW RETENTION POLICY;
RMAN> REPORT OBSOLETE;

--- Recovery Window Retention Policy

RMAN> CONFIGURE RETENTION POLICY CLEAR;
RMAN> CONFIGURE RETENTION POLICY TO NONE;

--- Backup Optimization
 
RMAN> SHOW BACKUP OPTIMIZATION;
RMAN> BACKUP ARCHIVELOG ALL;
RMAN> CONFIGURE BACKUP OPTIMIZATION ON;
RMAN> SHOW BACKUP OPTIMIZATION;
RMAN> BACKUP ARCHIVELOG ALL;
RMAN> BACKUP DATABASE FORCE;

--- Device types

RMAN> SHOW DEVICE TYPE;
RMAN> BACKUP DEVICE DISK DATABASE;
RMAN> BACKUP  DATABASE format �/u01/backup/%U�;
RMAN> CONFIGURE DEVICE TYPE DISK CLEAR;


--- Configuring Backup of Control File and SPFILE

RMAN> SHOW CONTROLFILE AUTOBACKUP;
RMAN> BACKUP TABLESPACE testtbs;
RMAN> BACKUP TABLESPACE system;
RMAN> CONFIGURE CONTROLFILE AUTOBACKUP ON;
RMAN> BACKUP TABLESPACE testtbs;
RMAN> CONFIGURE CONTROLFILE AUTOBACKUP OFF;

--- Configuring Channels

RMAN> CONFIGURE DEVICE TYPE DISK PARALLELISM 10;

--- Creating Duplex Backups

RMAN> CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE DISK TO 2;
RMAN> backup tablespace testtbs �format '/u01/app/oracle/%U';
RMAN> LIST BACKUP OF TABLESPACE testtbs;
RMAN> BACKUP TABLESPACE testtbs;

--- Configuring Encrypted Backups

RMAN> CONFIGURE ENCRYPTION ALGORITHM TO �AES256�;

--- Creating and using Keystore

$ sqlplus / as sysdba
SQL> CREATE USER c##sec_admin IDENTIFIED BY sec CONTAINER=all;
SQL> GRANT dba, syskm TO c##sec_admin;
$ cat sqlnet.ora 
ENCRYPTION_WALLET_LOCATION=
� (SOURCE=
����� (METHOD=FILE)
���������� (METHOD_DATA=
�������������� (DIRECTORY=/u01/app/oracle/wallet)))

$ sqlplus c##sec_admin/sec as syskm

SQL> ADMINISTER KEY MANAGEMENT CREATE KEYSTORE  '/u01/app/oracle/wallet' IDENTIFIED BY wallpwd;

SQL> ADMINISTER KEY MANAGEMENT CREATE AUTO_LOGIN KEYSTORE FROM KEYSTORE '/u01/app/oracle/wallet' IDENTIFIED BY wallpwd;

SQL> SELECT WRL_TYPE, STATUS, WALLET_TYPE,CON_ID
FROM   V$encryption_wallet;

SQL> ADMINISTER KEY MANAGEMENT SET KEYSTONE OPEN IDENTIFIED BY wallpwd;

SQL> ADMINISTER KEY MANAGEMENT SET KEY IDENTIFIED BY wallpwd WITH BACKUP;
SQL> SELECT WRL_TYPE, STATUS,WALLET_TYPE,CON_ID 
FROM   V$encryption_wallet;

RMAN> SHOW ENCRYPTION ALGORITHM;
RMAN> SHOW ENCRYPTION FOR DATABASE;
RMAN> CONFIGURE ENCRYPTION FOR DATABASE ON;
RMAN> BACKUP TABLESPACE users;

--- Password Encryption

RMAN> SET ENCRYPTION ON IDENTIFIED BY bkppwd ONLY;
RMAN> BACKUP TABLESPACE users;
RMAN> ALTER DATABASE DATAFILE 6 OFFLINE;
RMAN> RESTORE DATAFILE 6;
RMAN> SET DECRYPTION IDENTIFIED BY bkppwd;
RMAN> RESTORE DATAFILE 6;
RMAN> RECOVER DATAFILE 6;
RMAN> ALTER DATABASE DATAFILE 6 ONLINE;

--- Configuring Compression for Backups

RMAN> CONFIGURE COMPRESSION ALGORITHM �LOW�;
RMAN> CONFIGURE COMPRESSION ALGORITH �basic�;
RMAN> CONFIGURE COMPRESSION ALGORITHS �High�;

--- Snapshot Control File

RMAN> SHOW SNAPSHOT CONTROLFILE NAME;

--- Configuring Alert Log Deletion Policy

RMAN> CONFIGURE ARCHIVELOG DELETION POLICY TO BACKED UP 2 TIMES TO disk;
RMAN> SHOW ARCHIVELOG DELETION POLICY;
RMAN> CONFIGURE ARCHIVELOG DELETION POLICY CLEAR;
RMAN> SHOW ARCHIVELOG DELETION POLICY;

--- Connecting to RMAN using OS authentication

RMAN> connect target "/ as sysdba"

--- Connecting to RMAN using password File authentication

$ rman target '"sys@apdb as sysbackup"'



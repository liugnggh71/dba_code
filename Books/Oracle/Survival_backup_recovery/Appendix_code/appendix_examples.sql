--- Author: Francisco Munoz Alvarez
--- Date  : 20/07/2013
--- Script: appendix_examples.sql
--- Description: All examples done on appendix A

--- Setup of environment

$ mkdir /data/pdborcl
$ mkdir /data/pdborcl/backups
$ mkdir /data/pdborcl/backups/controlfile
$ mkdir /data/pdborcl/backups/archivelogs
$ mkdir /data/orcl/fast_recovery_area
$ mkdir /data/orcl/redologs
$ chown -R oracle:oinstall /data/pdborcl
$ chown -R oracle:oinstall /data/orcl
$ sqlplus / as sysdba
SQL> ALTER SESSION SET CONTAINER=pdborcl;
SQL> CREATE TABLESPACE test DATAFILE '/data/pdborcl /test_01_tbs.dbf' SIZE 100m;
SQL> CREATE USER test IDENTIFIED BY test DEFAULT TABLESPACE test QUOTA UNLIMITED ON test;
SQL> GRANT connect, resource TO test;
SQL> CREATE TABLE TEST.EMPLOYEE  
( EMP_ID   NUMBER(10) NOT NULL,
  EMP_NAME VARCHAR2(30),
  EMP_SSN  VARCHAR2(9),
  EMP_DOB  DATE
);
 
SQL> INSERT INTO test.employee VALUES (101,'Francisco Munoz',123456789,'30-JUN-73');

SQL> INSERT INTO test.employee VALUES (102,'Gonzalo Munoz',234567890,'02-OCT-96');

SQL> INSERT INTO test.employee VALUES (103,'Evelyn Aghemio',659812831,'02-OCT-79');

SQL> COMMIT;

--- Configure Database

SQL> CONNECT sys AS sysdba 
SQL> SHOW PARAMETER spfile;
SQL> CREATE spfile FROM pfile; 
SQL> STARTUP FORCE; 
SQL> ALTER SYSTEM SET db_recovery_file_dest_size=2G;
SQL> ALTER SYSTEM SET db_recovery_file_dest ='/data/orcl/fast_recovery_area’;
SQL> ALTER SYSTEM SET  log_archive_dest_1 ='LOCATION=/data/pdborcl/backups/archivelogs;
SQL> ALTER SYSTEM SET log_archive_dest_10 ='LOCATION=USE_DB_RECOVERY_FILE_DEST';
SQL> ALTER SYSTEM SET log_archive_format="orcl_%s_%t_%r.arc" SCOPE=spfile;
SQL> ALTER SYSTEM SET db_flashback_retention_target=720 SCOPE=spfile;
SQL> SHUTDOWN IMMEDIATE
SQL> STARTUP MOUNT
SQL> ALTER DATABASE ARCHIVELOG;
SQL> ALTER DATABASE FLASHBACK ON;
SQL> ALTER DATABASE OPEN;
SQL> SET LINESIZE 200
SQL> SET PAGESIZE 200
SQL> COLUMN member FORMAT a50
SQL> COLUMN bytes FORMAT 999,999,999
SQL> SELECT group#, sequence#, bytes, members FROM v$log;
SQL> SELECT group#, member FROM v$logfile;
SQL> ALTER DATABASE ADD LOGFILE GROUP 4 '/data/orcl/redologs
/redo_04a.rdo' SIZE 50m REUSE;
SQL> ALTER DATABASE ADD LOGFILE MEMBER'/data/orcl/redologs
/redo_04b.rdo' TO GROUP 4;

--- Configure RMAN

SQL> CREATE USER backup_admin IDENTIFIED BY bckpwd DEFAULT TABLESPACE users;

SQL> GRANT sysbackup TO backup_admin;

$ rman target=backup_admin/bckpwd@pdborcl
RMAN> CONFIGURE DEVICE TYPE DISK BACKUP TYPE TO COMPRESSED BACKUSET;
RMAN> CONFIGURE CHANNEL 1 DEVICE TYPE DISK FORMAL '/data/pdborcl/backups /bck_orcl_%U';
RMAN> CONFIGURE CHANNEL 1 DEVICE TYPE DISK MAXPIECESIZE 200m MAXOPENFILES 8 RATE 150m;
RMAN> CONFIGURE BACKUP OPTIMIZATION ON;
RMAN> CONFIGURE CONTROLFILE AUTOBACKUP ON;
RMAN> CONFIGURE CONROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '/data/pdborcl/backups/controlfile/ctl_orcl_%F';
RMAN> CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 1 DAYS;
RMAN> CONFIGURE ARCHIVELOG DELETION POLICY TO BACKED UP 1 TIMES TO DISK;

--- Backup Database

RMAN> BACKUP DATABASE PLUS ARCHIVELOG;

--- Check for Obsolete

RMAN> REPORT OBSOLETE;
RMAN> DELETE OBSOLETE;

--- Creating RMAN user

SQL> CREATE TABLESPACE catalog_tbs DATAFILE '/data/pdborcl /catalog_01_tbs.dbf' SIZE 100m;
SQL> CREATE USER catalog_bck IDENTIFIED BY rmancatalog DEFAULT TABLESPACE catalog_tbs QUOTA UNLIMITED ON catalog_tbs;
SQL> GRANT connect, resource, recovery_catalog_owner TO catalog_bck;

--- Creating Catalog

$ rman target / catalog=catalog_bck/rmancatalog@pdborcl

RMAN> CREATE CATALOG tablespace catalog_tbs;

$ rman target=backup_admin/bckpwd catalog=catalog_bck/rmancatalog@pdborcl
RMAN> REGISTER DATABASE;
RMAN> REPORT SCHEMA;

--- Create a virtual Private Catalog

SQL> CREATE USER fmunoz IDENTIFIED BY alvarez DEFAULT TABLESPACE catalog_tbs;
SQL> GRANT recovery_catalog_owner TO fmunoz;
$ rman catalog=catalog_bck/rmancatalog@pdborcl

RMAN> GRANT CATALOG FOR DATABASE pdborcl TO fmunoz;
RMAN> GRANT REGISTER DATABASE TO fmunoz;

rman catalog=fmunoz/alvarez@pdborcl

RMAN> CREATE VIRTUAL CATALOG;

--- Enabling Block TRacking

SQL> ALTER DATABASE ENABLE BLOCK CHANGE TRACKING;
SQL> SELECT status FROM v$block_change_tracking;

--- Monitoring a Backup

RMAN> BACKUP DATABASE PLUS ARCHIVELOG;

SQL> SELECT sid, serial#, context, sofar, totalwork, round(sofar/totalwork*100,2) "%_COMPLETE"
 FROM   v$session_longops
 WHERE  opname like 'RMAN%'
 AND    opname not like '%aggregate%'
 AND    totalwork !=0
 AND    sofar <> totalwork
/

--- Incremental Backups

RMAN> BACKUP INCREMENTALLEVEL=0 DATABASE PLUS ARCHIVELOG DELETE INPUT;
RMAN> BACKUP INCREMENTALLEVEL=1 DATABASE PLUS ARCHIVELOG DELETE INPUT;
RMAN> BACKUP INCREMENTALLEVEL=0 CUMULATIVE DATABASE PLUS ARCHIVELOG DELETE INPUT;

--- Multisection Backups

RMAN> BACKUP SECTION SIZE 10M TABLESPACE users;

--- FRA -Checking times of redo switches
  
SQL> ALTER SESSION SET nls_date_format='dd/mm/yyyy hh24:mi:ss';

SQL> SELECT sequence#, first_time log_started,
lead(first_time, 1,null) over (order by first_time) log_ended
FROM (SELECT DISTINCT sequence#, first_time
      FROM   dba_hist_log
      WHERE  archived='YES'
      AND    sequence#!=0
      ORDER BY first_time)
ORDER BY sequence#;

--- Check for alerts

SQL> SELECT reason FROM dba_outstanding_alerts;

--- Check FRA usage

SQL> SELECT * FROM v$recovery_file_dest;
SQL> ALTER SYSTEM SWITCH LOGFILE;
SQL> SELECT * FROM v$recovery_file_dest;
SQL> SELECT * FROM v$flash_recovery_area_usage;

--- See Archivelog Generated
 
SQL> SET PAGESIZE 200
SQL> SET LINESIZE 200
SQL> COLUMN name FORMAT a50
SQL> COLUMN completion_time FORMAT a25
SQL> ALTER SESSION SET nls_date_format= 'DD-MON-YYYY:HH24:MI:SS';
SQL> SELECT name, sequence#, status, completion_time
 FROM   CATALOG_BCK.rc_archived_log;

--- See Control file backups

SQL> SET PAGESIZE 200
SQL> SET LINESIZE 200
SQL> SELECT file#, creation_time, resetlogs_time
blocks, block_size, controlfile_type
FROM   v$backup_datafile where file#=0;

SQL> COLUMN completion_time FORMAT a25
SQL> COLUMN autobackup_date FORMAT a25
SQL> ALTER SESSION SET nls_date_format= 'DD-MON-YYYY:HH24:MI:SS';
SQL> SELECT db_name, status, completion_time, controlfile_type,
autobackup_date 
FROM   CATALOG_BCK.rc_backup_controlfile;

SQL> SELECT creation_time, block_size, status,completion_time,autobackup_date, autobackup_sequence
FROM   CATALOG_BCK.rc_backup_controlfile;


--- See list of corruption

SQL> SELECT db_name, piece#, file#, block#, blocks, corruption_type
FROM   CATALOG_BCK.rc_backup_corruption where db_name='ORCL';

--- See Block Corruption

SQL> SELECT file#, block#, corruption_type
FROM   v$database_block_corruption;

--- See all RMAN Configuration sets

SQL> COLUMN value FORMAT a60
SQL> SELECT db_key,name, value
FROM   CATALOG_BCK.rc_rman_configuration;

--- Monitore Backup outputs (RMAN)

SQL> SELECT output FROM v$rman_output ORDER BY stamp;


--- Offline Backups with RMAN

$ rman target / catalog=catalog_bck/rmancatalog@pdborcl
RMAN> SHUTDOWN IMMEDIATE
RMAN> STARTUP MOUNT
RMAN> BACKUP AS COMPRESSED BACKUPSET DATABASE;
RMAN> ALTER DATABASE OPEN;

--- Using Backups limit

RMAN> BACKUP DURATION 00:05 DATABASE;
RMAN> BACKUP DURATION 00:05 MINIMIZE TIME DATABASE;
RMAN> BACKUP DURATION 00:05 MINIMIZE LOAD DATABASE;

--- Modify Retention Policy

RMAN> BACKUP DATABASE KEEP FOREVER;
RMAN> BACKUP DATABASE FORMAT '/DB/u02/backups/other/bck1/orcl_%U' KEEP untiltime='sysdate+180' TAG keep_backup;

--- Archive Deletion Policy

RMAN> CONFIGURE ARCHIVELOG DELETION POLICY TO BACKED UP 2 TIMES TO DEVICE TYPE DISK;

--- using RMAN to scan the db for physical and logical errors

RMAN> BACKUP VALIDATE CHECK LOGICAL DATABASE;

--- Configuring Tablespace for Exclusion

RMAN> CONFIGURE EXCLUDE FOR TABLESPACE example;
RMAN> BACKUP DATABASE;
# backs up the whole database, including example
RMAN> BACKUP DATABASE NOEXCLUDE;
RMAN> BACKUP TABLESPACE example;  # backs up only  example
RMAN> CONFIGURE EXCLUDE FOR TABLESPACE example CLEAR;

--- Skiping offline, inaccesible or read only datafiles

RMAN> BACKUP DATABASE SKIP READONLY;
RMAN> BACKUP DATABASE SKIP OFFLINE;
RMAN> BACKUP DATABASE SKIP INACCESSIBLE;
RMAN> BACKUP DATABASE SKIP READONLY SKIP OFFLINE SKIP INACCESSIBLE;

--- Forcing Backup of read only datafiles

RMAN> BACKUP DATABASE FORCE;

--- Backup of newly added datafiles

RMAN> BACKUP DATABASE NOT BACKED UP;

--- Backup files not backed up in a specific period

RMAN> BACKUP DATABASE NOT BACKED UP SINCE time='sysdate-2';
RMAN> BACKUP ARCIVELOG ALL NOT BACKED UP 1 TIMES;
RMAN> BACKUP AS COMPRESSED BACKUPSET DATABASE PLUS ARCHIVELOG NOT BACKED UP 1 TIMES DELETE INPUT;

--- General Backup Examples

RMAN> BACKUP TABLESPACE USERS INCLUDE CURRENT CONTROLFILE PLUS ARCHIVELOG;
RMAN> BACKUP DATAFILE 2;
RMAN> BACKUP ARCHIVELOG ALL;
RMAN> BACKUP ARCHIVELOG FROM TIME 'sysdate-1';
RMAN> BACKUP ARCHIVELOG FROM SEQUENCE xxx;
RMAN> BACKUP ARCHIVELOG ALL DELETE INPUT;
RMAN> BACKUP ARCHIVELOG FROM SEQUENCE xxx DELETE INPUT;
RMAN> BACKUP ARCHIVELOG NOT BACKED UP 3 TIMES;
RMAN> BACKUP ARCHIVELOG UNTIL TIME 'sysdate - 2' DELETE ALL INPUT;

--- Backup Copies

RMAN> BACKUP AS COPY DATABASE;
RMAN> BACKUP AS COPY TABLESPACE USERS;
RMAN> BACKUP AS COPY DATAFILE 1;
RMAN> BACKUP AS COPY ARCHIVELOG ALL;

--- Information about full completed backups

SQL> ALTER SESSION SET nls_date_format= 'DD-MON-YYYY:HH24:MI:SS';
SQL> SELECT /*+ RULE */ session_key, session_recid,
start_time, end_time, output_bytes, elapsed_seconds, optimized
FROM   v$rman_backup_job_details
WHERE  start_time >= sysdate-180
AND    status='COMPLETED'
AND    input_type='DB FULL';

--- Summary of the active session history

SQL> SELECT sid, serial#, program 
FROM   v$session 
WHERE  lower(program) like '%rman%';

SQL> SET LINES 132 
SQL> COLUMN session_id FORMAT 999 HEADING ”SESS|ID”
SQL> COLUMN session_serial# FORMAT 9999 HEADING ”SESS|SER|#”
SQL> COLUMN event FORMAT a40
SQL> COLUMN total_waits FORMAT 9,999,999,999 HEADING ”TOTAL|TIME|WAITED|MICRO”

SQL> SELECT session_id, session_serial#, Event, sum(time_waited) total_waits
FROM   v$active_session_history
WHERE  session_id||session_serial# in (403, 476, 4831)
AND    sample_time > sysdate -1
AND    program like '%rman%'
AND    session_state='WAITING' And time_waited > 0
GROUP BY session_id, session_serial#, Event
ORDER BY session_id, session_serial#, total_waits desc;

--- How long a backup will takes?

RMAN> BACKUP DATABASE PLUS ARCHIVELOG;

$ sqlplus / as sysdba

SQL> ALTER SESSION SET CONTAINER=pdborcl;

SQL> SELECT sid, serial#, program 
FROM   v$session 
WHERE  lower(program) like '%rman%';

SQL> SELECT sid, serial#, opname, time_remaining
FROM   v$session_longops
WHERE  sid||serial# in (<XXX>, <XXX>, <XXX>)
AND    time_remaining > 0;


--- V$BACKUP_ASYNC_IO

SQL> SELECT sid, serial#, program 
FROM   v$session 
WHERE  lower(program) like '%rman%';

SQL> COLUMN filename FORMAT a60
SQL> SELECT sid, serial, effective_bytes_per_second, filename 
FROM   V$BACKUP_ASYNC_IO
WHERE  sid||serial in (<XXX>, <XXX>, <XXX>);

SQL> SELECT LONG_WAITS/IO_COUNT, FILENAME
FROM   V$BACKUP_ASYNC_IO 
WHERE LONG_WAITS/IO_COUNT > 0 
AND   sid||serial in (<XXX>, <XXX>, <XXX>)
ORDER BY LONG_WAITS/IO_COUNT DESC; 

--- Tablespace Point in time Recovery

SQL> EXECUTE DBMS_TTS.TRANSPORT_SET_CHECK(‘test’, TRUE);
SQL> SELECT * FROM transport_set_violations

SQL> SELECT OWNER, NAME, TABLESPACE_NAME,
TO_CHAR(CREATION_TIME, 'YYYY-MM-DD:HH24:MI:SS')
FROM  TS_PITR_OBJECTS_TO_BE_DROPPED
WHERE TABLESPACE_NAME IN ('TEST') AND CREATION_TIME >
TO_DATE('07-OCT-08:22:35:30','YY-MON-DD:HH24:MI:SS')
ORDER BY TABLESPACE_NAME, CREATION_TIME;

RMAN>RECOVER TABLESPACE pdborcl:test UNTIL SCN <XXXX> AUXILIARY DESTINATION ‘/tmp’;

--- Reporting from Catalog

SQL> SELECT a.db_key, a.dbid, a.name db_name,
b.backup_type, b.incremental_level,
b.completion_time, max(b.completion_time) 
over (partition by a.name, a.dbid) max_completion_time
FROM   catalog_bck.rc_database a, catalog_bck.rc_backup_set b
WHERE  b.status = 'A'
AND    b.backup_type = 'D'
AND    b.db_key = a.db_key;

--- Duplex Backup

RMAN> CONFIGURE DATAFILE BACKUPCOPIES FOR DEVICE TYPE DISK TO 2;
RMAN> CONFIGURE ARCHIVELOG BACKUp COPIES FOR DEVICE TYPE DISK TO 2;
RMAN> BACKUP DATAFILE 1 FORMAT '/DB/u02/backups/bck_orcl_%U','/Data/backup/bck_orcl_%U' PLUS ARCHIVELOG;

--- Check if db is recoverable

RMAN> RESTORE DATABASE PREVIEW;


--- Recovery Advisor

SQL> CREATE TABLESPACE test3_tbs DATAFILE '/data/pdborcl /test3_01.dbf' SIZE 100m;
SQL> CREATE USER test3 IDENTIFIED BY test3 DEFAULT TABLESPACE test3_tbs QUOTA UNLIMITED ON test3_tbs;
SQL> GRANT CONNECT, RESOURCE to test3;
SQL> CREATE TABLE test3.EMPLOYEE  
( EMP_ID   NUMBER(10) NOT NULL,
  EMP_NAME VARCHAR2(30),
  EMP_SSN  VARCHAR2(9),
  EMP_DOB  DATE
);
 
SQL> INSERT INTO test.employee VALUES (101,'Francisco Munoz',123456789,'30-JUN-73');

SQL> INSERT INTO test.employee VALUES (102,'Gonzalo Munoz',234567890,'02-OCT-96');

SQL> INSERT INTO test.employee VALUES (103,'Evelyn Aghemio',659812831,'02-OCT-79');

SQL> COMMIT;

$ Cd /data/pdborcl
$ echo > test3_01_dbf.dbf
$ ls -lrt

RMAN> VALIDATE DATABASE;
RMAN> LIST FAILURE;
RMAN> ADVISE FAILURE;
RMAN> REPAIR FAILURE PREVIEW;
RMAN> REPAIR FAILURE;

--- Preparing Data Pump

$ sqlplus / as sysdba
SQL> ALTER SESSION SET CONTAINER=pdborcl;
SQL> CREATE USER fcomunoz IDENTIFIED BY alvarez DEFAULT TABLESPACE users QUOTA UNLIMITED ON users;
SQL> GRANT CREATE SESSION, RESOURCE, DATAPUMP_EXP_FULL_DATABASE, DATAPUMP_IMP_FULL_DATABASE TO fcomunoz;
SQL> CREATE DIRECTORY datapump AS '/data/pdborcl/backups;
SQL> GRANT READ, WRITE ON DIRECTORY datapump to fcomunoz;

--- Data Masking

SQL> CREATE TABLE fcomunoz.EMPLOYEE  
( EMP_ID   NUMBER(10) NOT NULL,
  EMP_NAME VARCHAR2(30),
  EMP_SSN  VARCHAR2(9),
  EMP_DOB  DATE
)
/

SQL> INSERT INTO fcomunoz.employee VALUES (101,'Francisco Munoz',123456789,'30-JUN-73');

SQL> INSERT INTO fcomunoz.employee VALUES (102,'Gonzalo Munoz',234567890,'02-OCT-96');

SQL> INSERT INTO fcomunoz.employee VALUES (103,'Evelyn Aghemio',659812831,'02-OCT-79');

SQL> COMMIT;

SQL> CREATE OR REPLACE PACKAGE fcomunoz.pkg_masking 
 as 
 FUNCTION mask_ssn (p_in VARCHAR2) RETURN VARCHAR2;
END;
/

SQL> CREATE OR REPLACE PACKAGE BODY fcomunoz.pkg_masking 
 AS 
 FUNCTION mask_ssn (p_in varchar2) 
 RETURN VARCHAR2
 IS 
 BEGIN 
   RETURN LPAD (
   ROUND(DBMS_RANDOM.VALUE (001000000,999999999)),9,0);
 END;
END;
/

SQL> SELECT * FOM fcomunoz.employees;

$expdp fcomunoz/alvarez@pdborcl tables=fcomunoz.employee dumpfile=mask_ssn.dmp directory=datapump remap_data=fcomunoz.employee.emp_ssn:pkg_masking.mask_ssn

$ impdp fcomunoz/alvarez@pdborcl table_exists_action=truncate directory=datapump dumpfile=mask_ssn.dmp

SQL> SELECT * FROM fcomunoz.employees;

--- Metadata Repository

$ expdp fcomunoz/alvarez@pdborcl content=metadata_only full=y directory=datapump dumpfile=metadata_06192013.dmp

$ impdp fcomunoz/alvarez@pdborcl directory=datapump dumpfile= metadata_06192013.dmp sqlfile=metadata_06192013.sql

$ expdp fcomunoz/alvarez@pdborcl content=metadata_only tables=fcomunoz.employee directory=datapump dumpfile= refresh_of_table_employee_06192013.dmp

$ impdp fcomunoz/alvarez@pdborcl table_exists_action=replace directory=datapump dumpfile= refresh_of_table_name_06192013.dmp

--- Cloning a User

$ expdp fcomunoz/alvarez@pdborcl schemas=fcomunoz content=metadata_only directory=datapump dumpfile= fcomunoz_06192013.dmp

SQL> CREATE USER fcomunoz2 IDENTIFIED BY alvarez DEFAULT TABLESPACE users QUOTA UNLIMITED ON users;
SQL> GRANT connect,resource TO fcomunoz2;

$ impdp fcomunoz/alvarez@pdborcl remap_schema=fcomunoz:fcomunoz2 directory=datapump dumpfile= fcomunoz_06192013.dmp

--- Smaller Copy of Production

$ expdp fcomunoz/alvarez@pdborcl content=metadata_only tables=fcomunoz.employee directory=datapump dumpfile=example_206192013.dmp

$ impdp fcomunoz/alvarez@pdborcl content=metadata_only directory=datapump dumpfile=example_206192013.dmp sqlfile=employee_06192013.sql

$ cat /data/pdborcl/backups/employee_06192013.sql

$ impdp fcomunoz/alvarez@pdborcl transform=pctspace:70 content=metadata_only directory=datapump dumpfile= example_206192013.dmp sqlfile=transform_06192013.sql

$ cat /data/pdborcl/backups/transform_06192013.sql

$ expdp fcomunoz/alvarez@pdborcl sample=70 full=y directory=datapump dumpfile=expdp_70_06192013.dmp

$ impdp fcomunoz/alvarez@pdborcl2 transform=pctspace:70 directory=datapump dumpfile=expdp_70_06192013.dmp

--- Create databse in different structure

$ expdp fcomunoz/alvarez@pdborcl full=y directory=datapump dumpfile=expdp_full_06192013.dmp

$ impdp fcomunoz/alvarez@pdborcl directory=datapump dumpfile= expdp_full_06192013.dmp remap_datafile=’/u01/app/oracle/oradata/pdborcl/datafile_01.dbf’:’/u01/app/oracle/oradata/pdborcl2/datafile_01.dbf’

--- Flashback Time Based (Data Pump)

SQL> conn / as sysdba

SQL> SELECT dbms_flashback.get_system_change_number
FROM dual;

SQL> SELECT SCN_TO_TIMESTAMP(dbms_flashback.get_system_change_number)
 FROM dual;

SQL> exit

$ expdp fcomunoz/alvarez@pdborcl directory=datapump tables=fcomunoz.employee dumpfile=employee_flashback_06192013.dmp
flashback_time="to_timestamp('19-06-2013 14:30:00', 'dd-mm-yyyy hh24:mi:ss')"

--- ASM Backup and Restore

RMAN> BACKUP TABLESPACE users;
ASMCMD> mkdir +DATA1/abc
ASMCMD> mkalias TBSJFV.354.323232323   +DATA1/abc/users.f
ASMCMD> md_backup –g  data1
SQL> ALTER DISKGROUP data1 DISMOUNT FORCE;
SQL> DROP DISKGROUP data1 FORCE INCLUDING CONTENTS;
ASMCMD> md_restore –b ambr_backup_intermediate_file –t full –g data
RMAN> RESTORE TABLESPACE users;

--- Recovery from loss of tablespace SYSTEM

$ rman target / 
RMAN> STARTUP MOUNT; 
RMAN> RESTORE DATABASE;
RMAN> RECOVER DATABASE; 
RMAN> ALTER DATABASE OPEN; 

--- Recovering the loss of a datafile using image from FRA

SQL> ALTER DATABASE DATAFILE 7 OFFLINE;
$ rman target /
RMAN> SWITCH DATAFILE 7 TO COPY;
RMAN> RECOVER DATAFILE 7;
RMAN> ALTER DATABASE DATAFILE 7 ONLINE;
$ rman target /
RMAN> BACKUP AS COPY DATAFILE 7 FORMAT '/Data/data/test3_tbs_01.dbf';
RMAN> SWITCH DATAFILE 7 TO COPY;
RMAN> RECOVER DATAFILE 7;
RMAN> ALTER DATABASE DATAFILE 7 ONLINE;


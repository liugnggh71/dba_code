--- Author: Francisco Munoz Alvarez
--- Date  : 20/07/2013
--- Script: chapter5_examples.sql
--- Description: All examples done on chapter 5

$ rman
RMAN> CONNECT TARGET /;
$ RMAN target / LOG=/some/location/rmanoutput.log
$ .oraenv
$ sqlplus / as sysdba
SQL> archive log list

--- If not in ARCHIVELOG mode
SQL> SHUTDOWN IMMEDIATE
SQL> STARTUP MOUNT
SQL> ALTER DATABASE ARCHIVELOG;
SQL> ALTER DATABASE OPEN;
SQL> archive log list

--- Container Database and PDBs Backup

RMAN> BACKUP DATABASE PLUS ARCHIVELOG;

--- Pluggable Database Backups

RMAN> BACKUP PLUGGABLE DATABASE apdb;
RMAN> BACKUP PLUGGABLE DATABASE apdb, hr;
$ rman target sys/oracle@apdb
RMAN> BACKUP DATABASE;

--- Partial Backups connected on root

$ rman target /
RMAN> BACKUP TABLESPACE rcat_tbs;
RMAN> SELECT tablespace_name, con_id FROM cdb_tablespaces;
RMAN> BACKUP TABLESPACE apdb:rcat_tbs;

--- Partial Backup when connected to a PDB

$ rman target sys/oracle@apdb
RMAN> BACKUP TABLESPACE rcat_tbs;

---- Performing Backup of Root

RMAN> BACKUP DATABASE root;

--- Backup Using Image Copy

RMAN> BACKUP AS COPY DATABASE;
RMAN> BACKUP AS COPY PLUGGABLE DATABASE apdb;

--- Multisection Image Copy

RMAN> BACKUP AS COPY SECTION SIZE 100M DATABASE;
RMAN> BACKUP AS COPY SECTION SIZE 200M PLUGGABLE DATABASE apdb;

--- Performing Compressed Backups

RMAN> BACKUP AS COMPRESSED BACKUPSET DATABASE;

--- Performing Differential Incremental Backups

RMAN> BACKUP INCREMENTAL LEVEL 0 DATABASE;
SQL> CREATE TABLE test_tab TABLESPACE users 
 2   AS SELECT * FROM dba_objects;
SQL> INSERT INTO test_tab SELECT * FROM test_tab;
SQL> COMMIT;
SQL> UPDATE test_tab SET object_id=100;
SQL> COMMIT;
RMAN> BACKUP INCREMENTAL LEVEL 1 DATABASE;
RMAN> BACKUP INCREMENTAL LEVEL 0 PLUGGABLE DATABASE apdb;

--- Cumulative Incremental Backup

RMAN> BACKUP INCREMENTAL LEVEL 0 CUMULATIVE PLUGGABLE DATABASE apdb;

--- Block Change Tracking

SQL> SELECT filename, status, bytes 
 2   FROM   V$block_change_tracking;

SQL> ALTER DATABASE ENABLE BLOCK CHANGE TACKING USING FILE 'blkchng';
SQL> SELECT filename, status, bytes 
 2   FROM   V$block_change_tracking;

SQL> SELECT file#, avg(datafile_blocks),
 2          avg(blocks_read),
 3          avg(blocks_read/datafile_blocks)
 4          * 100 AS PCT_READ_FOR_BACKUP,
 5         avg(blocks)
 6   FROM   v$backup_datafile
 7   WHERE  used_change_tracking = 'YES'
 8   AND    incremental_level > 0
 9   GROUP  BY file# ;

--- Multisection Incremental Backups

RMAN> BACKUP INCREMENTAL LEVEL 1 SECTION SIZE 100m DATABASE;

--- Incremental Updating Backups and Taking Image Copies a setp ahead with RMAN
RMAN> RUN
{
  RECOVER COPY OF tablespace test_imgcpy
    WITH TAG 'testimgcpy_incr';
  BACKUP
    INCREMENTAL LEVEL 1
    FOR RECOVER OF COPY WITH TAG 'testimgcpy_incr'
    tablespace test_imgcpy;
}
2> 3> 4> 5> 6> 7> 8> 9>

RMAN> LIST COPY OF TABLESPACE test_imgcpy;

--- Backup of Control File and SPFILE

RMAN> BACKUP TABLESPACE system;
RMAN> BACKUP TABLESPACE apdb:system;

--- Enabling the AUTOBACKUP option for Control File and SPFILE

RMAN> CONFIGURE CONTROLFILE AUTOBACKUP ON;
RMAN> BACKUP CURRENT CONTROLFILE;
RMAN> BACKUP AS COPY CURRENT CONTROLFILE;
RMAN> BACKUP TABLESPACE users INCLUDING CURRENT CONTROLFILE;

--- Backups of the Backups

RMAN> BACKUP BACKUPSET ALL;

--- Restarting the RMAN backup

RMAN> BACKUP NOT BACKED UP SINCE TIME ‘sysdate – 5/1440’ DATABASE;

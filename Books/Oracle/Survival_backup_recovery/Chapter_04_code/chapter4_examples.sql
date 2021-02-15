--- Author: Francisco Munoz Alvarez
--- Date  : 20/07/2013
--- Script: chapter4_examples.sql
--- Description: All examples done on chapter 4

To select the datafiles information you can use the following SQL*Plus command:

SQL> SELECT name  
FROM   v$datafile; 
Or if you prefer to see the tablespaces and all associated data files, you can use the following SQL*Plus command: 

SQL> SELECT   a.name tablespace, b.name datafile
FROM 	  v$tablespace a, v$datafile b 
WHERE    a.ts# = b.ts# 
ORDER BY a.name;

To check where your archive logs are being generated, you should use the following command:

SQL> SELECT 	destination
FROM 	v$archive_dest; 

Use the following command to see the name and location of your current control files.

SQL> SELECT 	name 
FROM	v$controlfile;

---Cold Backup

If your database is OPEN, than SHUTDOWN your database completely in a consistent mode (use SHUTDOWN [NORMAL/IMMEDIATE/TRANSACTIONAL] only), this will ensure that all database files headers are consistent to the same SCN.


2.	Backup all database data files, control files, and the PFILE or SPFILE (copying them to a stage area at operating system level).
$ cp $ORACLE_BASE/oradata/cdb1/*.dbf /stage/backup
$ cp $ORACLE_BASE/oradata/cdb1/control01.ctl /stage/backup
$ cp $ORACLE_HOME/dbs/spfilecdb1.ora /stage/backup

3.	Restart the database.

4.	Archive all unachieved redo logs so any redo required to recover the tablespace is archived and executes a backup of all archive log files.
SQL> ALTER SYSTEM ARCHIVE LOG CURRENT;
$ cp $ORACLE_BASE/fast_recovery_area/*.arc /stage/backup

---Offline Backup

SQL> EXECUTE DBMS_TTS.TRANSPORT_SET_CHECK('example', TRUE);

SQL> SELECT * FROM transport_set_violations;

SQL> EXECUTE DBMS_TTS.TRANSPORT_SET_CHECK('example,example2', TRUE);

1.	Identify all the data files associated with a tablespace by querying the DBA_DATA_FILES view;
SQL> SELECT tablespace_name, file_name
  2  FROM   sys.dba_data_files
  3  WHERE  tablespace_name = 'EXAMPLE';

2.	Take the tablespace offline using the NORMAL priority if possible (This guarantees that no recovery will be necessary when bringing the tablespace online later);
SQL> ALTER TABLESPACE example OFFLINE NORMAL;

3.	Backup all data files related to the now offline tablespace via OS;
$ cp $ORACLE_BASE/oradata/cdb1/pdb1/example_01.dbf /stage/backup

4.	Bring the tablespace online;
SQL> ALTER TABLESPACE example ONLINE;

5.	Archive all unachieved redo logs so any redo required to recover the tablespace is archived and executes a backup of all archive log files.  
SQL> ALTER SYSTEM ARCHIVE LOG CURRENT;
$ cp $ORACLE_BASE/fast_recovery_area/*.arc /stage/backup

--- Hot Backup of a whole Database

1.	Place your entire database in backup mode;
SQL> ALTER DATABASE BEGIN BACKUP;

2.	Backup all data files and the PFILE or SPFILE. This backup is a simple physical copy of files at OS level.
$ cp $ORACLE_BASE/oradata/cdb1/*.dbf /stage/backup
$ cp $ORACLE_HOME/dbs/spfilecdb1.ora /stage/backup

3.	Take the database out of the backup mode;
SQL> ALTER DATABASE END BACKUP;

4.	Archive all unachieved redo logs so any redo required to recover the database are archived;
SQL> ALTER SYSTEM ARCHIVE LOG CURRENT;

5.	Make a backup of all archived redo log files (OS level).
$ cp $ORACLE_BASE/fast_recovery_area/*.arc /stage/backup

6.	Create a copy of your control file using the statement “ALTER DATABASE”.
SQL> ALTER DATABASE BACKUP CONTROLFILE TO'/stage/backup/control.ctf';

--- Hot Backup of Tablespace

1.	Identify all data files associated with the tablespace by querying the DBA_DATA_FILES view;
SQL> SELECT tablespace_name, file_name
FROM   sys.dba_data_files
WHERE  tablespace_name = 'EXAMPLE';

2.	Place the tablespace in backup mode;
SQL> ALTER TABLESPACE example BEGIN BACKUP;

3.	Backup all data files associated with the tablespace that you placed in backup mode. This backup is a physical copy of the data files at OS level;
$ cp $ORACLE_BASE/oradata/cdb1/pdb1/example_01.dbf /stage/backup

4.	Place the tablespace back in normal mode;
SQL> ALTER TABLESPACE example END BACKUP;

5.	If you need to back up another tablespace, go back to the step 1, if not proceed to step 5;

6.	Archive all unachieved redo logs so any redo required to recover the database are archived;
SQL> ALTER SYSTEM ARCHIVE LOG CURRENT;

7.	Make a backup of all archived redo log files (OS level).
$ cp $ORACLE_BASE/fast_recovery_area/*.arc /stage/backup

--- Root Only or Individual Pluggable Database

1.	Open SQL*Plus;
$ sqlplus /nolog

2.	Connect to root or a specific pluggable database using a user with the SYSDBA or SYSBACKUP system privilege. In this example we will connect to a specific pluggable database called “pdb1”;
SQL> CONNECT system
SQL> ALTER SESSION SET CONTAINER =  pdb1;
Or
SQL> CONNECT userdba@pdb1

3.	Identify the data files that are part of the PDB you want to do the backup by querying the DBA_DATA_FILES view;
SQL> SELECT file_name
FROM   sys.dba_data_files;   

4.	Place the PDB in backup mode;
SQL> ALTER PLUGGABLE DATABASE pdb1 BEGIN BACKUP;

5.	Backup all data files associated with the PDB that you placed in backup mode. This backup is a physical copy of the data files at OS level;
$ cp $ORACLE_BASE/oradata/cdb1/pdb1/* /stage/backup

6.	Place the PDB back in normal mode;
SQL> ALTER PLUGGABLE DATABASE pdb1 END BACKUP;

7.	Archive all unachieved redo logs so any redo required to recover the PDB are archived;
SQL> ALTER SYSTEM ARCHIVE LOG CURRENT;

8.	Make a backup of all archived redo log files (OS level).
$ cp $ORACLE_BASE/fast_recovery_area/*.arc /stage/backup

--- Control file binary backup

SQL> ALTER DATABASE BACKUP CONTROLFILE TO [filename_including_location] ';

--- Control file text file backup

To generate a trace file with the RESETLOGS and NORESETLOGS statements in the trace subdirectory (you can also easily identify the name and location of the generated file by reading  the database alert log),  use:
	SQL> ALTER DATABASE BACKUP CONTROLFILE TO TRACE; 

To generate a trace file in the trace subdirectory with the RESETLOGS option only use:
	SQL> ALTER DATABASE BACKUP CONTROLFILE TO TRACE RESETLOGS;

To generate a trace file in the trace subdirectory with the NORESETLOGS option only use:
	SQL> ALTER DATABASE BACKUP CONTROLFILE TO TRACE NORESETLOGS;

To generate a trace file in a specific location with the RESETLOGS and NORESETLOGS statements use:
	SQL> ALTER DATABASE BACKUP CONTROLFILE TO TRACE AS '/stage/backup/ctlf.sql';

To generate a trace file in a specific location with the RESETLOGS and NORESETLOGS statements overwriting an existing file, use:
	SQL> ALTER DATABASE BACKUP CONTROLFILE TO TRACE AS '/stage/backup/ctlf.sql' REUSE;

To generate a trace file with the RESETLOGS option only use:
	SQL> ALTER DATABASE BACKUP CONTROLFILE TO TRACE TRACE AS '/stage/backup/ctlf.sql' RESETLOGS;
To generate a trace file with the NORESETLOGS option only use:
	SQL> ALTER DATABASE BACKUP CONTROLFILE TO TRACE TRACE AS '/stage/backup/ctlf.sql' NORESETLOGS;


--- Flashback Database

SQL> SELECT flashback_on FROM v$database; 

To enable Flashback Database, please follow these easy steps at SQL*Plus:

1.	Ensure that your database is running on ARCHIVELOG mode;

2.	Configure the Fast Recovery Area, by setting values for DB_RECOVERY_FILE_DEST and DB_RECOVERLY_FIE_DEST_SIZE initialization parameters;
a.	DB_RECOVERY_FILE_DEST specifies the location of the Fast Recovery Area, 
Example: 
SQL>ALTER SYSTEM SET DB_RECOVERY_FILE_DEST=’/u01/fra’;
b.	DB_RECOVERY_FILE_DEST_SIZE specifies the Fast Recovery Area size (bytes), 
Example: 
SQL>ALTER SYSTEM SET DB_RECOVERY_FILE_DEST_SIZE= 20G;

3.	If using 11gR2 onwards (including 12c), just execute the following statement:
SQL> ALTER DATABASE FLASHBACK ON;

4.	If using an Oracle Database version lower than 11gR2 you will need to run the statement above with your database in MOUNT mode, than after activate FLASHBACK you should open your database.

SQL> SELECT current_scn, TO_CHAR(sysdate,’dd/mm/yyyy hh24:mi:ss’) CURRENT_DATE FROM   v$database;

SQL> SELECT oldest_flashback_scn, oldest_flashback_time
FROM v$flashback_database_log;

SQL> ALTER SESSION SET nls_date_format='dd/mm/yyyy hh24:mi:ss';

SQL> SELECT oldest_flashback_scn, oldest_flashback_time
FROM   v$flashback_database_log;

SQL> SHUTDOWN IMMEDIATE

SQL>STARTUP MOUNT

SQL> FLASHBACK DATABASE TO SCN 1806297;

SQL>ALTER DATABASE OPEN READ ONLY;

SQL> SELECT current_scn
FROM   v$database;

SQL> SHUTDOWN IMMEDIATE

SQL> STARTUP MOUNT

SQL> ALTER DATABASE OPEN RESETLOGS;

SQL> COLUMN name FORMAT a20

SQL> SELECT * FROM v$recovery_file_dest;

SQL> SELECT * FROM v$flash_recovery_area_usage;



 
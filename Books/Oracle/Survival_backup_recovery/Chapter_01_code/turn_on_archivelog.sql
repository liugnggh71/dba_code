--- Author: Francisco Munoz Alvarez
--- Date  : 20/07/2013
--- Script: turn_on_archivelog.sql
--- Description: Place a database in ARCHIVELOG mode


1.	Setup the size of your FRA to be used by your database. You can do this by using the command:
SQL> ALTER SYSTEM SET DB_RECOVERY_FILE_DEST_SIZE=<M/G> SCOPE=both;
2.	Specify the location of the FRA using  the command:
SQL> ALTER SYSTEM SET DB_RECOVERY_FILE_DEST= '/u01/app/oracle/fast_recovery_area' scope=both;
3.	Define your archive log destination area using the command: 
SQL> ALTER SYSTEM SET log_archive_dest_1= 'LOCATION=/DB/u02/backups/archivelog' scope=both;
4.	Define your secondary archive log area to use the FRA with the command:
SQL> ALTER SYSTEM SET log_archive_dest_10= 'LOCATION=USE_DB_RECOVERY_FILE_DEST';
5.	Shutdown your database using the command:
SQL> SHUTDOWN IMMEDIATE
6.	Start your database in mount mode using the command: 
SQL> STARTUP MOUNT
7.	Switch your database to use the ARCHIVELOG mode using the command:
SQL> ALTER DATABASE ARCHIVELOG;
8.	Then finally open your database using the command:
SQL> ALTER DATABASE OPEN;





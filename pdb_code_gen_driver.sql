
alter session set container=&1;
show pdbs
set echo off
set heading off
set feedback off
set sqlprompt ""
set linesize 32767
set pagesize 50000
set termout off
set trimspool on

spool &2
@&3
spool off
exit

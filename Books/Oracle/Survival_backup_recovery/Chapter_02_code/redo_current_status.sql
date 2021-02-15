--- Author: Francisco Munoz Alvarez
--- Date  : 20/07/2013
--- Script: redo_current_status.sql
--- Description: Shows some very important information regarding
--- redo log files. The script reports on threads, number of
--- membes per group, whether a group was archived or not, size,
--- and SCN#

column first_change# format 999,999,999  heading Change#
column group#        format 9,999        heading Grp#
column thread#       format 999          heading Th#
column sequence#     format 999,999      heading Seq#
column members       format 999          heading Mem
column archived      format a4           heading Arc?
column first_time    format a25          heading First|Time
break on thread#
set pages 100 lines 132 feedback off 
ttitle CENTER 'Current Redo Log Status'
spool log_stat.txt
SELECT thread#, group#, sequence#,
bytes, members,archived,status,first_change#,
to_char(first_time,'dd-mon-yyyy hh24:mi') first_time
FROM sys.v_$log
ORDER BY thread#, group#;
spool off
clear breaks 
clear columns
ttitle off



--- Author: Francisco Munoz Alvarez
--- Date  : 20/07/2013
--- Script: redo_since_startup.sql
--- Description: show statistics regarding redo since the
--- instance was started

col name format a50 heading 'Statistic|Name'
col value heading 'Statistic|Value'
ttitle CENTER 'Redo Log Statistics'
spool redo_statistics.txt
SELECT name, value
FROM v$sysstat
WHERE name like '%redo%'
order by name
/
spool off
pause Press enter to continue
ttitle off

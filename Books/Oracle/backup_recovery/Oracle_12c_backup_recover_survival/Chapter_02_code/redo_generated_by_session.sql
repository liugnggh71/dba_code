--- Author: Francisco Munoz Alvarez
--- Date  : 20/07/2013
--- Script: redo_generated_by_session.sql 
--- Description: Shows how much redo is being generated by each
---              active session in the database

SELECT v$session.sid, username, value redo_size
FROM v$sesstat, v$statname, v$session
WHERE v$sesstat.STATISTIC# = v$statname.STATISTIC#
AND v$session.sid = v$sesstat.sid
AND name = 'redo size'
AND value > 0
AND username is not null
ORDER BY value
/


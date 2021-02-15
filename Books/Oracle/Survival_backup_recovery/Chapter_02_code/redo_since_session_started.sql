--- Author: Francisco Munoz Alvarez
--- Date  : 20/07/2013
--- Script: redo_since_session_started.sql
--- Description: shows how much redo was generated since your 
--- session started. The amount it shown in bytes

SELECT value redo_size
FROM v$mystat, v$statname
WHERE v$mystat.STATISTIC# = v$statname.STATISTIC#
and name = 'redo size'
/


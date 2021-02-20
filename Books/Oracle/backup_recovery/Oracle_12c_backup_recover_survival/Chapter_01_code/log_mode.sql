--- Author: Francisco Munoz Alvarez
--- Date  : 20/07/2013
--- Script: log_mode.sql
--- Description: shows the database mode. If ARCHIVELOG or NOARCHIVELOG

SELECT log_mode FROM v$database;


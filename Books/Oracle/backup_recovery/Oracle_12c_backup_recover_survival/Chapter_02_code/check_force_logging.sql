--- Author: Francisco Munoz Alvarez
--- Date  : 20/07/2013
--- Script: check_force_logging.sql
--- Description: shows if the database is running on force logging or not

SELECT force_logging FROM v$database;



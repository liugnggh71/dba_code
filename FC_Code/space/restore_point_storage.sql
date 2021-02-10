set linesize 132
column name format a32
column GUARANTEE_FLASHBACK_DATABASE format A5
select r.time, r.NAME, r.GUARANTEE_FLASHBACK_DATABASE, round(r.STORAGE_SIZE/1024/1024/1024) storage_gb from v$restore_point r;
-- drop restore point xxx;

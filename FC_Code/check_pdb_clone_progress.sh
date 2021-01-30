sqlplus / as sysdba << 'EOF'
set linesize 200 pagesize 100
column message format a70
SELECT ELAPSED_SECONDS, time_remaining, message
  FROM gv$session_longops
 WHERE     time_remaining > 0
       AND SYSDATE - start_time < 1 / 4
       order by time_remaining;
show pdbs
EOF


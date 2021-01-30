sqlplus / as sysdba << EOF
EXEC DBMS_WORKLOAD_REPOSITORY.create_snapshot;
show pdbs
show parameter name
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
SELECT begin_interval_time, end_interval_time
  FROM (  SELECT *
            FROM dba_hist_snapshot
        ORDER BY begin_interval_time DESC)
 WHERE ROWNUM < 5;
EOF

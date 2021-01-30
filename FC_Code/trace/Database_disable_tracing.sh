if [ $# -lt 1 ]
then
 pdb=cdb\$root
else
 pdb=${1}
fi

sqlplus / as sysdba << EOF
alter session set container=${pdb};
show pdbs
show parameter name
show parameter diag
BEGIN
    DBMS_MONITOR.database_trace_disable;
END;
/

column TRACE_TYPE format A12
set linesize 132
SELECT TRACE_TYPE,
       WAITS,
       BINDS
  FROM DBA_ENABLED_TRACES
 WHERE TRACE_TYPE = 'DATABASE';

EOF

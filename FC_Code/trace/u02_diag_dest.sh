sqlplus / as sysdba << EOF
show pdbs
show parameter name
alter system set diagnostic_dest='/u02/app/oracle' scope=both;
show parameter diagnostic_dest
EOF

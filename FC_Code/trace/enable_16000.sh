sqlplus / as sysdba << EOF
alter system set event='16000 trace name ERRORSTACK level 10' scope=spfile;
show pdbs
show parameter name
 show spparameter event
 show parameter event
EOF


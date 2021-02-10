sqlplus / as sysdba << EOF
alter system set max_dump_file_size='20m' scope=both;
show pdbs
show parameter max_dump_file_size
show spparameter max_dump_file_size
EOF

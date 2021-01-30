subdir=$(dirname ${0})
sqlplus / as sysdba << EOF
@${subdir}/util/pdb_creation_time.sql
EOF

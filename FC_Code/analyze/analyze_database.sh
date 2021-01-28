nohup sqlplus / as sysdba << EOF &
@analyze_database.sql
/

EOF

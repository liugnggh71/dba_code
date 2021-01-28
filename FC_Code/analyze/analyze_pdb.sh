if [ $# -lt 1 ]
 then
 echo " "
 echo "USAGE: analyze_pdb.sh PDB_NAME"
 echo " "
 exit 1
fi


nohup sqlplus / as sysdba << EOF &
alter session set container = ${1};
@@analyze_database.sql
/

EOF

if [ $# -lt 1 ]
then
 echo " "
 echo "USAGE: sta2_TDE.sh CDB_PDB_import.txt"
 echo "./sta2_TDE.sh D2_2_pdb_whole_env_import.txt"
ls -l *whole*.txt
 echo " "
 exit 1
fi

. $1

. $SOURCE_FILE

sqlplus / as sysdba << EOF
show pdbs
SELECT name,wrl_parameter, status, wallet_type FROM v\$encryption_wallet, v\$database;

alter session set container=${PDB_NAME};
show pdbs
SELECT name,wrl_parameter, status, wallet_type FROM v\$encryption_wallet, v\$pdbs;

alter session set container=${PDB_NAME_2};
show pdbs
SELECT name,wrl_parameter, status, wallet_type FROM v\$encryption_wallet, v\$pdbs;
EOF

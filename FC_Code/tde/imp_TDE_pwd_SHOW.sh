
# function definition for imp_TDE_pwd
#~~~~~~~~~~~~~~~~~~FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF~~~~~~~~~~~~~~~~~#
function imp_TDE_pwd {

cat << EOD
srvctl stop database -d ${DB_UNIQUE_NAME}

sqlplus / as sysdba << EOF
Startup
alter session set container=${PDB_NAME};
Shutdown immediate;
show pdbs
connect / as sysdba
administer key management set keystore CLOSE;
administer key management set keystore open identified by "${WALLET_PWD}";
alter session set container=${PDB_NAME};
alter database open;
administer key management set keystore open identified by "${WALLET_PWD}";
ADMINISTER KEY MANAGEMENT IMPORT ENCRYPTION KEYS WITH SECRET "${WALLET_SECRET}" FROM '${TDE_EXP_FILE_NAME}' IDENTIFIED BY "${WALLET_PWD}" with backup;
ADMINISTER KEY MANAGEMENT USE KEY '${WALLET_KEY}' IDENTIFIED BY "${WALLET_PWD}" WITH BACKUP;
EOF

srvctl stop database -d ${DB_UNIQUE_NAME}
srvctl start database -d ${DB_UNIQUE_NAME}
srvctl status database -d ${DB_UNIQUE_NAME}

sqlplus / as sysdba << EOF
Show pdbs
alter session set container=${PDB_NAME};
create tablespace X1;
drop tablespace X1;
EOF
EOD
}

if [ $# -lt 1 ]
then
 echo " "
 echo "USAGE: imp_TDE_pwd.sh CDB_PDB_import.txt"
ls *import.txt | grep -v whole
 echo " "
 exit 1
fi

. $1

. $SOURCE_FILE

imp_TDE_pwd


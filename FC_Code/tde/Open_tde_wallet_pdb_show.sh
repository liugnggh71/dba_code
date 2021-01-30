if [ $# -lt 1 ]
then
 echo " "
 echo "USAGE: open_tde_wallet_pdb.sh CDB_PDB.txt"
 echo " "
 exit 1
fi

. $1

. $SOURCE_FILE

WALLET_PATH="$(dirname $WALLET_FULL_FILE_NAME)/"

cat << EOF
SELECT name,wrl_parameter, status, wallet_type FROM v\$encryption_wallet, v\$database;
prompt Deleting cwallet.sso
host rm -f ${WALLET_FULL_FILE_NAME}
host ls -l ${WALLET_PATH}
shutdown immediate;
startup;
prompt Close wallet
ADMINISTER KEY MANAGEMENT SET KEYSTORE close;
SELECT name,wrl_parameter, status, wallet_type FROM v\$encryption_wallet, v\$database;
prompt Open CDB Wallet
ADMINISTER KEY MANAGEMENT SET KEYSTORE open IDENTIFIED BY "${WALLET_PWD}";
SELECT name,wrl_parameter, status, wallet_type FROM v\$encryption_wallet, v\$database;
host ls -l ${WALLET_PATH}
prompt Set to PDB ${PDB_NAME}
alter session set container=${PDB_NAME};
prompt Open PDB wallet
ADMINISTER KEY MANAGEMENT SET KEYSTORE open IDENTIFIED BY "${WALLET_PWD}";
SELECT name,wrl_parameter, status, wallet_type FROM v\$encryption_wallet, v\$pdbs;
host ls -l ${WALLET_PATH}
prompt Set PDB wallet password
administer key management set key identified by "${WALLET_PWD}" with backup;
SELECT name,wrl_parameter, status, wallet_type FROM v\$encryption_wallet, v\$pdbs;
host ls -l ${WALLET_PATH}
prompt Set CDB
alter session set container=CDB\$ROOT;
prompt Create AUTO_LOGIN cwallet file
administer key management create AUTO_LOGIN keystore from keystore '${WALLET_PATH}' identified by "${WALLET_PWD}";
host ls -l ${WALLET_PATH}
shutdown immediate;
startup
prompt CDB wallet status
SELECT name,wrl_parameter, status, wallet_type FROM v\$encryption_wallet, v\$database;
prompt PDB wallet status
alter session set container=${PDB_NAME};
SELECT name,wrl_parameter, status, wallet_type FROM v\$encryption_wallet, v\$pdbs;
prompt PDB test tbs creation
create tablespace x1;
drop tablespace x1;
EOF


  else
    echo "NNNNNNNNNNNNNNNNNNNNNN"
    echo "TDE configuration cancelled"
    echo "NNNNNNNNNNNNNNNNNNNNNN"
    #Return Return XXXXXXXXXXXXXXX
    return 200
    #Return Return XXXXXXXXXXXXXXX
  fi


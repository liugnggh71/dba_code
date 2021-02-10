if [ $# -lt 2 ]
 then
 echo " "
 echo "USAGE: Tbs_usage.sh CDB PDB"
 echo " "
 exit 1
fi

CDB=${1}
PDB=${2}

. $HOME/${CDB}.env

sqlplus / as sysdba << EOF
alter session set container=${PDB};
@tbs_usage.sql
EOF


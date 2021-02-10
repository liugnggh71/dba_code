if [ $# -lt 3 ]
 then
 echo " "
 echo "USAGE: Tbs_usage.sh CDB PDB TBS"
 echo " "
 exit 1
fi

CDB=${1}
PDB=${2}
TBS=${3}

. $HOME/${CDB}.env

sqlplus / as sysdba << EOF
alter session set container=${PDB};
ALTER TABLESPACE ${TBS} ADD DATAFILE SIZE 100M AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED;
EOF


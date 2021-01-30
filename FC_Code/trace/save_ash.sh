if [ $# -lt 1 ]
then
 pdb=cdb\$root
else
 pdb=${1}
fi

date_stamp=$(date "+%Y_%m_%d_%H_%M_%S")
mkdir -p /acfs01/acfs/diag/${date_stamp}
sqlplus / as sysdba << EOF
alter session set container=${pdb};
show pdbs
create table dbsnmp.ash_${date_stamp} as select * from gv\$active_session_history;
EOF

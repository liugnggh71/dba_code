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
show parameter name
alter system set diagnostic_dest='/acfs01/acfs/diag/${date_stamp}' scope=both;
show parameter diagnostic_dest
EOF

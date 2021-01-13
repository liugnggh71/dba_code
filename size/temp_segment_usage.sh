#!/bin/sh 
# temp_segment_usage.sh CDB PDB

if [ $# -lt 1 ]
then
  echo " "
  echo "temp_segment_usage.sh CDB PDB"
  echo " "
fi


CDB=${1}
PDB=${2}
# sourcing CDB environment 
. ${HOME}/${CDB}.env


if [ $# -lt 2 ]
then
  PDB=cdb\$root
else
  PDB=${2}
  echo " "
fi


sqlplus / as sysdba << EOF
alter session set container=${PDB};
@temp_segment_usage.sql
EOF


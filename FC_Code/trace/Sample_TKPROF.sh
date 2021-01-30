cat << EOF
scp oracle@edwprd:/u01/app/oracle/diag/rdbms/bdwprod/bdwprod/trace/bdwprod_ora_35651854.trc .
tkprof empidev_ora_45417336.trc empidev_ora_45417336.txt SORT=exeela,fchela,prsela insert=empidev_ora_45417336.ins record=empidev_ora_45417336.rec PRINT=10000 SYS=Y explain=SYSTEM/empiora001@empidbt:1521/empidev
tkprof bdwprod_ora_35651854.trc bdwprod_ora_35651854.txt SORT=exeela,fchela,prsela insert=empidev_ora_45417336.ins record=empidev_ora_45417336.rec PRINT=10000
EOF

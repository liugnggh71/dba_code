BASEDIR=$(dirname $0)

find /u02/app/oracle/diag/rdbms -type d -name cdmp\*  -exec ls -ld {} \;
echo find /u02/app/oracle/diag/rdbms -type d -name cdmp\*  -exec rm -Rf {} \;

cat ${BASEDIR}/cdump_list.sh

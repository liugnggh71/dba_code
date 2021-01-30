export PRE_UPGRADE_RESULT=/acfs01/acfs/preupgrade
export NEW_ORACLE_HOME=/u02/app/oracle/product/12.2.0/dbhome_6
mkdir -p ${PRE_UPGRADE_RESULT}
. ${HOME}/FCDB2.env
${ORACLE_HOME}/jdk/bin/java -jar ${NEW_ORACLE_HOME}/rdbms/admin/preupgrade.jar FILE DIR ${PRE_UPGRADE_RESULT}

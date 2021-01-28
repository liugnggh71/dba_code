echo ~~~~~~~~~~~~~~~!!!!!~~~~~~~~~~~~~~~~~~~~~~
echo /u01/app/grid/diag/tnslsnr/autp-hroradb-utzrk1/listener/trace/listener.log

ssh -i $HOME/firstcare_db_priv.txt opc@10.21.32.105 sudo -u grid tail -n ${1} /u01/app/grid/diag/tnslsnr/autp-hroradb-utzrk1/listener/trace/listener.log

echo /u01/app/grid/diag/tnslsnr/autp-hroradb-utzrk1/listener/trace/listener.log
echo ~~~~~~~~~~~~~~~!!!!!~~~~~~~~~~~~~~~~~~~~~~
echo /u01/app/grid/diag/tnslsnr/autp-hroradb-utzrk2/listener/trace/listener.log

ssh -i $HOME/firstcare_db_priv.txt opc@10.21.32.106 sudo -u grid tail -n ${1} /u01/app/grid/diag/tnslsnr/autp-hroradb-utzrk2/listener/trace/listener.log

echo /u01/app/grid/diag/tnslsnr/autp-hroradb-utzrk2/listener/trace/listener.log
echo ~~~~~~~~~~~~~~~!!!!!~~~~~~~~~~~~~~~~~~~~~~

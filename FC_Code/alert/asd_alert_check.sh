echo ~~~~~~~~~~~~~~~!!!!!~~~~~~~~~~~~~~~~~~~~~~
echo alert_ASD1.log

ssh -i $HOME/firstcare_db_priv.txt opc@10.21.32.105 sudo -u oracle tail -n ${1} /u02/app/oracle/diag/rdbms/asd_iad1kf/ASD1/trace/alert_ASD1.log

echo alert_ASD1.log
echo ~~~~~~~~~~~~~~~!!!!!~~~~~~~~~~~~~~~~~~~~~~
echo alert_+ASM1.log
ssh -i $HOME/firstcare_db_priv.txt opc@10.21.32.105 sudo -u grid tail -n ${1} /u01/app/grid/diag/asm/+asm/+ASM1/trace/alert_+ASM1.log

echo alert_+ASM1.log
echo ~~~~~~~~~~~~~~~!!!!!~~~~~~~~~~~~~~~~~~~~~~
echo alert_ASD2.log
ssh -i $HOME/firstcare_db_priv.txt opc@10.21.32.106 sudo -u oracle tail -n ${1} /u02/app/oracle/diag/rdbms/asd_iad1kf/ASD2/trace/alert_ASD2.log


echo alert_ASD2.log
echo ~~~~~~~~~~~~~~~!!!!!~~~~~~~~~~~~~~~~~~~~~~
echo alert_+ASM2.log
ssh -i $HOME/firstcare_db_priv.txt opc@10.21.32.106 sudo -u grid tail -n ${1} /u01/app/grid/diag/asm/+asm/+ASM2/trace/alert_+ASM2.log
echo alert_+ASM2.log
echo ~~~~~~~~~~~~~~~!!!!!~~~~~~~~~~~~~~~~~~~~~~

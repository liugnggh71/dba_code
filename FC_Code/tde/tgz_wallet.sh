cd /var/opt/oracle/dbaas_acfs/
find . -type f -name ?wallet.??? > wallet.list
date_stamp=$(date "+%Y_%m_%d_%H_%M_%S")
tar czvf wallet_${date_stamp}.tgz -T wallet.list
tar tzvf wallet_${date_stamp}.tgz
pwd
ls -l wallet_${date_stamp}.tgz


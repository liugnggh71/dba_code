if [ $# -lt 1 ]
 then
 echo " "
 echo "USAGE: deploy_code.sh RelativeFilePath"
 echo " "
 exit 1
fi

config_file=${2}
v_strlen=${#config_file}
if [ "$v_strlen" -gt 0 ];then
  final_config=${config_file}
else
  final_config='deploy_host_list.txt'
fi


subdir=$(dirname ${1})

while IFS= read -r line
do
  ## Debugging lines
  echo "$line"
  dns_name=$(echo "$line" | cut -d~ -f 1)
  ip=$(echo "$line" | cut -d~ -f 2)
  echo ${dns_name}
  echo ${ip}
  ssh -i $HOME/cloud_agent_private_key.txt opc@${ip} sudo -u  root mkdir -p /tmp/${subdir} < /dev/null
  sleep 1
  ssh -i $HOME/cloud_agent_private_key.txt opc@${ip} sudo -u  root chmod 777 /tmp/${subdir} < /dev/null
  sleep 1
  scp -p -i $HOME/cloud_agent_private_key.txt ${1} opc@${ip}:/tmp/${1} < /dev/null
  sleep 1
  ssh -i $HOME/cloud_agent_private_key.txt opc@${ip} sudo -u root chown grid.oinstall /tmp/${1} < /dev/null
  sleep 1
  ssh -i $HOME/cloud_agent_private_key.txt opc@${ip} sudo -u grid mkdir -p /home/grid/dba_code/${subdir} < /dev/null
  sleep 1
  ssh -i $HOME/cloud_agent_private_key.txt opc@${ip} sudo -u root mv /tmp/${1} /home/grid/dba_code/${1} < /dev/null
  sleep 1
done < <(grep -v "^#" config/${final_config} | grep "~")


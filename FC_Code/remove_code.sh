if [ $# -lt 1 ]
 then
 echo " "
 echo "USAGE: remove_code.sh RelativeFilePath"
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
  ssh -i $HOME/cloud_agent_private_key.txt opc@${ip} sudo -u root rm /home/oracle/dba_code/${1} < /dev/null
done < <(grep -v "^#" config/${final_config} | grep "~")


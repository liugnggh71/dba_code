date_stamp=$(date "+%Y_%m_%d_%H_%M_%S")
host=$(hostname)
black_out_name=$(echo $host $date_stamp)
ssh -i $HOME/cloud_agent_private_key.txt opc@127.0.0.1 "/u01/app/oracle/agent/agent_13.3.0.0.0/bin/emctl start blackout '${black_out_name}' -nodelevel -d ${1}:00"


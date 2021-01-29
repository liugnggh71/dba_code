subdir=$(dirname ${1})
mkdir -p $subdir
scp -p opc@10.21.137.2:/home/oracle/dba_code/${1} $subdir

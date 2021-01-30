# function definition for DOWN_PRD_exp_TDE
# Shutdown production database and export production database TDE
#~~~~~~~~~~~~~~~~~~FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF~~~~~~~~~~~~~~~~~#
function DOWN_PRD_exp_TDE {

srvctl stop database -d CLSTD_uniq
srvctl status database -d CLSTD_uniq
srvctl start database -d CLSTD_uniq
srvctl status database -d CLSTD_uniq

date_stamp=$(date "+%Y_+%m_%d_%H_%M_%S")

. $HOME/CLSTD.env
sqlplus / as sysdba << EOF
set pagesize 100 linesize 1000
spool /home/oracle/dba_code/tde/PWD_STORE/${date_stamp}.log
administer key management set keystore open identified by "bSwocJs-b1_540d01";

select key_id, creation_time, con_id from v\$encryption_keys;


alter session set container=FRSTPROD;
alter database open;
show pdbs
administer key management set keystore open identified by "bSwocJs-b1_540d01";
ADMINISTER KEY MANAGEMENT EXPORT ENCRYPTION KEYS WITH SECRET "bSwocJs-b1_540d01" TO '/home/oracle/dba_code/tde/PWD_STORE/tde_pdb_FRSTPROD_${date_stamp}.exp' IDENTIFIED BY "bSwocJs-b1_540d01";


alter session set container=HEDBP;
alter database open;
show pdbs
administer key management set keystore open identified by "bSwocJs-b1_540d01";
ADMINISTER KEY MANAGEMENT EXPORT ENCRYPTION KEYS WITH SECRET "bSwocJs-b1_540d01" TO '/home/oracle/dba_code/tde/PWD_STORE/tde_pdb_HEDBP_${date_stamp}.exp' IDENTIFIED BY "bSwocJs-b1_540d01";
EOF

}

. $HOME/CLSTD.env
sqlplus / as sysdba << 'EOF'
show pdbs
select host_name, instance_name from v$instance;
EOF

echo "#CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC"
echo  Shutting down PRD for TDE export
echo "#CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC"
echo "------ Confirm ------YyEeSs or n : YyEeSs or n : YyEeSs or n"
echo "Shutting down CLSTD for TDE export: ---- Confirm with YyEeSs(default n):"
confirm=n
read input
confirm=${input:-$confirm}
if [ ${confirm} = "YyEeSs" ]
 then
    echo #AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    echo "Really shutting down FIRSTCARE PRD type RETURN to continue or Ctrl+C to exit:"
    read PPPP
 
    echo #AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    echo "Really shutting down FIRSTCARE PRD Second confirm type RETURN to continue or Ctrl+C to exit:"
    read PPPP

    echo #AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    echo "Really shutting down FIRSTCARE PRD Third confirm type RETURN to continue or Ctrl+C to exit:"
    read PPPP

    DOWN_PRD_exp_TDE
else
  echo "#NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN"
  echo "PRD TDE export cancelled"
  echo "#NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN"
fi



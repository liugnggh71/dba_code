#FC_PDB_TDE_Exp.sh
#open_tde_wallet_pdb.sh
#Open_tde_wallet_pdb_show.sh
#ssh_opc_root_tgz_wallet.sh
#tgz_wallet.sh
#tsand_import_tde_key.sh

cd /home/oracle/dba_code/tde

# Configuration check all angles

alias D='/home/oracle/dba_code/tde/dir_TDE.sh'
alias Z='/home/oracle/dba_code/tde/ssh_opc_root_tgz_wallet.sh'
alias s='/home/oracle/dba_code/tde/TDE_status.sh'
alias S2='/home/oracle/dba_code/tde/sta2_TDE.sh'
alias M='/home/oracle/dba_code/tde/imp_TDE_pwd_SHOW.sh' #show manual import action
alias O='/home/oracle/dba_code/tde/Open_tde_wallet_pdb_show.sh' #show Open wallet codes
alias i='/home/oracle/dba_code/tde/imp_TDE_pwd.sh' #TDE PWD import just one DB
alias I='/home/oracle/dba_code/tde/imp2_TDE_pwd.sh' #TDE PWD import whole ENV
alias C2='cd /home/oracle/dba_code/dg ; ./show_config_database.sh | less'
cat /home/oracle/dba_code/tde/alias.sh

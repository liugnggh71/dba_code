cd /home/oracle/dba_code/trace

# Check current status of database trace take 1 option parameter
# S 
# TMP
# S FRSTPROD
# snap
# DE FRSTPROD
# DD FRSTPROD
# snap
# U2
# sash FRSTPROD



alias S='cd /home/oracle/dba_code/trace ; ./trace_status.sh'
alias DE='cd /home/oracle/dba_code/trace ; ./database_enable_tracing.sh'
alias DD='cd /home/oracle/dba_code/trace ; ./Database_disable_tracing.sh'

# Set diag destination to new location
alias TMP='cd /home/oracle/dba_code/trace ; ./temp_diag_dest.sh'
alias U2='cd /home/oracle/dba_code/trace ; ./u02_diag_dest.sh'

# AWR and ash

alias snap='cd /home/oracle/dba_code/trace; ./snap_shot_awr.sh'
alias sash='cd /home/oracle/dba_code/trace; ./save_ash.sh'

# Define and Undefine alias

alias H='cd /home/oracle/dba_code/trace ;. ./alias.sh'
alias U='cd /home/oracle/dba_code/trace ;. ./unalias.sh'

cat alias.sh

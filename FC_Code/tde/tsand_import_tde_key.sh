srvctl stop database -d SAND_iad18t
. $HOME/SAND.env
sqlplus / as sysdba << EOF
Startup
alter session set container=CSAND01;
Shutdown immediate;
alter session set container=HSAND01;
Shutdown immediate;
show pdbs
connect / as sysdba
administer key management set keystore CLOSE;
administer key management set keystore open identified by "bSwocJs-b1_540d01";
alter session set container=CSAND01;
alter database open;
administer key management set keystore open identified by "bSwocJs-b1_540d01";
ADMINISTER KEY MANAGEMENT IMPORT ENCRYPTION KEYS WITH SECRET "bSwocJs-b1_540d01" FROM '/home/oracle/dba_code/tde/tde_pdb_frstprod.exp' IDENTIFIED BY "bSwocJs-b1_540d01" with backup;
ADMINISTER KEY MANAGEMENT USE KEY 'ASApzfAxIU9ovz0WHcjyDNUAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' IDENTIFIED BY "bSwocJs-b1_540d01" WITH BACKUP;
alter session set container=HSAND01;
alter database open;
administer key management set keystore open identified by "bSwocJs-b1_540d01";
ADMINISTER KEY MANAGEMENT IMPORT ENCRYPTION KEYS WITH SECRET "bSwocJs-b1_540d01" FROM '/home/oracle/dba_code/tde/tde_pdb_hedbp.exp' IDENTIFIED BY "bSwocJs-b1_540d01" with backup;
ADMINISTER KEY MANAGEMENT USE KEY 'ARKlI/qTAU8Av96DF/j59bsAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' IDENTIFIED BY "bSwocJs-b1_540d01" WITH BACKUP;
EOF

srvctl stop database -d SAND_iad18t
srvctl start database -d SAND_iad18t
srvctl status database -d SAND_iad18t

sqlplus / as sysdba << EOF
Show pdbs
EOF



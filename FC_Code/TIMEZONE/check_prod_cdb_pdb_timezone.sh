. /home/oracle/PRD.env
sqlplus / as sysdba << EOF
select dbtimezone from dual;
show pdbs
alter session set container=FRSTPROD;
show pdbs
select dbtimezone from dual;
alter session set container=HEDBP;
show pdbs
select dbtimezone from dual;
EOF


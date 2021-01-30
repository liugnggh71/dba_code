. /home/oracle/ASD.env
sqlplus / as sysdba << EOF
ALTER DATABASE SET TIME_ZONE='America/Chicago';
show pdbs
alter session set container=HRASD01;
show pdbs
ALTER DATABASE SET TIME_ZONE='America/Chicago';
alter session set container=CMASD01;
show pdbs
ALTER DATABASE SET TIME_ZONE='America/Chicago';
EOF

. /home/oracle/CFG.env
sqlplus / as sysdba << EOF
ALTER DATABASE SET TIME_ZONE='America/Chicago';
show pdbs
alter session set container=CMCFG01;
show pdbs
ALTER DATABASE SET TIME_ZONE='America/Chicago';
alter session set container=HRCFG01;
show pdbs
ALTER DATABASE SET TIME_ZONE='America/Chicago';
EOF

. /home/oracle/D1.env
sqlplus / as sysdba << EOF
ALTER DATABASE SET TIME_ZONE='America/Chicago';
show pdbs
alter session set container=CMDEV01;
show pdbs
ALTER DATABASE SET TIME_ZONE='America/Chicago';
alter session set container=HRDEV01;
show pdbs
ALTER DATABASE SET TIME_ZONE='America/Chicago';
EOF

. /home/oracle/D2.env
sqlplus / as sysdba << EOF
ALTER DATABASE SET TIME_ZONE='America/Chicago';
show pdbs
alter session set container=CMDEV02;
show pdbs
ALTER DATABASE SET TIME_ZONE='America/Chicago';
alter session set container=HRDEV02;
show pdbs
ALTER DATABASE SET TIME_ZONE='America/Chicago';
EOF

. /home/oracle/D3.env
sqlplus / as sysdba << EOF
ALTER DATABASE SET TIME_ZONE='America/Chicago';
show pdbs
alter session set container=CMDEV03;
show pdbs
ALTER DATABASE SET TIME_ZONE='America/Chicago';
alter session set container=HRDEV03;
show pdbs
ALTER DATABASE SET TIME_ZONE='America/Chicago';
EOF

. /home/oracle/FCDB2.env
sqlplus / as sysdba << EOF
ALTER DATABASE SET TIME_ZONE='America/Chicago';
show pdbs
alter session set container=CMFCDB2;
show pdbs
ALTER DATABASE SET TIME_ZONE='America/Chicago';
alter session set container=HRFCDB2;
show pdbs
ALTER DATABASE SET TIME_ZONE='America/Chicago';
EOF

. /home/oracle/INT.env
sqlplus / as sysdba << EOF
ALTER DATABASE SET TIME_ZONE='America/Chicago';
show pdbs
alter session set container=CMINT01;
show pdbs
ALTER DATABASE SET TIME_ZONE='America/Chicago';
alter session set container=HRINT01;
show pdbs
ALTER DATABASE SET TIME_ZONE='America/Chicago';
EOF

. /home/oracle/QA.env
sqlplus / as sysdba << EOF
ALTER DATABASE SET TIME_ZONE='America/Chicago';
show pdbs
alter session set container=CMQA1;
show pdbs
ALTER DATABASE SET TIME_ZONE='America/Chicago';
alter session set container=HRQA1;
show pdbs
ALTER DATABASE SET TIME_ZONE='America/Chicago';
EOF

. /home/oracle/SAND.env
sqlplus / as sysdba << EOF
ALTER DATABASE SET TIME_ZONE='America/Chicago';
show pdbs
alter session set container=HRSAND01;
show pdbs
ALTER DATABASE SET TIME_ZONE='America/Chicago';
alter session set container=CMSAND01;
show pdbs
ALTER DATABASE SET TIME_ZONE='America/Chicago';
EOF


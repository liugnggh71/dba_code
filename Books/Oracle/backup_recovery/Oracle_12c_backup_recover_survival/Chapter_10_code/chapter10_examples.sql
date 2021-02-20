--- Author: Francisco Munoz Alvarez
--- Date  : 20/07/2013
--- Script: chapter10_examples.sql
--- Description: All examples done on chapter 10

--- Data Masking

SQL> SELECT * FROM test.employee;

$ sqlplus fcomunoz/alvarez@pdborcl

SQL> CREATE OR REPLACE PACKAGE pkg_masking
 AS
   FUNCTION mask_ssn (p_in varchar2) RETURN varchar2;
 END;
 /

SQL> CREATE OR REPLACE PACKAGE BODY pkg_masking
AS
FUNCTION mask_ssn (p_in varchar2)
RETURN varchar2
IS
BEGIN
  IF p_in IS NOT NULL then
     RETURN lpad (
            round(dbms_random.value (001000000,999999999)),9,0);
  END IF; 
END;
END;
/


SQL> DESC test.employee

$expdp fcomunoz/alvarez@pdborcl tables=test.employee dumpfile=mask_ssn.dmp directory=datapump remap_data=test.employee.emp_ssn:pkg_masking.mask_ssn

$ impdp fcomunoz/alvarez@pdborcl table_exists_action=truncate directory=datapump dumpfile=mask_ssn.dmp

$ sqlplus fcomunoz/alvarez@pdborcl

SQL> SELECT * FROM test.employee;

--- Metadata Repository and Version Control

$ expdp fcomunoz/alvarez@pdborcl content=metadata_only full=y directory=datapump dumpfile=metadata_06192013.dmp

$ impdp fcomunoz/alvarez@pdborcl directory=datapump dumpfile= metadata_06192013.dmp sqlfile=metadata_06192013.sql

$ expdp fcomunoz/alvarez@pdborcl content=metadata_only tables=test.employee directory=datapump dumpfile= refresh_of_table_employee_06192013.dmp

$ impdp fcomunoz/alvarez@pdborcl table_exists_action=replace directory=datapump dumpfile= refresh_of_table_name_06192013.dmp


--- Cloning a User

$ expdp fcomunoz/alvarez@pdborcl schemas=test content=metadata_only directory=datapump dumpfile= test_06192013.dmp

$ impdp fcomunoz/alvarez@pdborcl remap_schema=test:test2 directory=datapump dumpfile= test_06192013.dmp

--- Creating Smaller copies of Production

$ expdp fcomunoz/alvarez@pdborcl content=metadata_only full=y directory=datapump dumpfile=metadata_06192013.dmp

$ impdp fcomunoz/Alvarez@pdborcl3 transform=pctspace:70 directory=datapump dumpfile=metadata_06192013.dmp

$ expdp fcomunoz/alvarez@pdborcl content=metadata_only tables=test.employee directory=datapump dumpfile=example_206192013.dmp

$ impdp fcomunoz/alvarez@pdborcl content=metadata_only directory=datapump dumpfile=example_206192013.dmp sqlfile=employee_06192013.sql

$ impdp fcomunoz/alvarez@pdborcl transform=pctspace:70 content=metadata_only directory=datapump dumpfile= example_206192013.dmp sqlfile=transform_06192013.sql

$ expdp fcomunoz/alvarez@pdborcl sample=70 full=y directory=datapump dumpfile=expdp_70_06192013.dmp

$ impdp fcomunoz/alvarez@pdborcl3 transform=pctspace:70 directory=datapump dumpfile=expdp_70_06192013.dmp

--- Creating database in a different structure

$ impdp fcomunoz/alvarez@pdborcl directory=datapump dumpfile=diff_structure_06192013.dmp remap_datafile=’/u01/app/oracle/oradata/pdborcl/datafile_01.dbf’:’ /u01/app/oracle/oradata/pdborcl2/datafile_01.dbf’

--- Moving objects to another tablespace

$ impdp fcomunoz/alvarez@pdborcl directory=datapump dumpfile=mv_tablespace_06192013.dmp remap_tablespace=test:test2

--- Moving objects from one schema to another

$ expdp fcomunoz/alvarez@pdborcl tables=test.employee directory=datapump dumpfile=employee_06192013.dmp

$ impdp fcomunoz/alvarez@pdborcl directory=datapump dumpfile= employee_06192013.dmp remap_schema=test:test2

--- Migrating data for upgrade

$ expdp fcomunoz/alvarez dumpfile=full_11_06192013.dmp logfile=full_11_06192013.log full=y 

$ impdp fcomunoz/alvarez@pdborcl dumpfile=full_11_06192013.dmp logfile=imp_full_11_06192013.log

--- Downgrading an Oracle database

$ expdp fcomunoz/alvarez@pdborcl directory=datapump dumpfile=version_full_06192013.dmp full=y version=11.2.0.3

--- Transporting a Tablespace

SQL>  EXECUTE DBMS_TTS.TRANSPORT_SET_CHECK(‘example’, TRUE);

SQL> SELECT * FROM transport_set_violations;

SQL> ALTER TABLESPACE example READ ONLY;

$ expdp fcomunoz/alvarez dumpfile=transp_example_06192013.dmp directory=datapump transport_tablespaces=example logfile= transp_example_06192013.log

SQL> ALTER TABLESPACE example READ WRITE;

SQL> CREATE USER testx IDENTIFIED BY alvarez;

SQL> GRANT CREATE SESSION, RESOURCE TO testx;

$ impdp fcomunoz/alvarez@pdborcl dumpfile=transp_example_06192013.dmp directory=datapump transport_datafiles=’/u01/app/oracle/oradata/pdborcl/ts_example_01.dbf’

SQL> ALTER TABLESPACE example READ WRITE;

--- Data Pump Flashback

$ expdp directory=datapump dumpfile=employee_flashback_06192013.dmp
flashback_time="to_timestamp('19-06-2013 14:30:00', 'dd-mm-yyyy hh24:mi:ss')"

























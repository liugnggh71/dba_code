--- Author: Francisco Munoz Alvarez
--- Date  : 20/07/2013
--- Script: chapter2_examples.sql
--- Description: All scripts and examples on chapter 2

CREATE TABLE table_nolog_test (a number) NOLOGGING;

SELECT table_name, logging 
FROM user_tables 
WHERE table_name='TABLE_NOLOG_TEST';

CREATE TABLESPACE example 
DATAFILE   '/u01/app/oracle/oradata/cdb1/pdb1/EXAMPLE01.DBF' SIZE 200M EXTENT MANAGEMENT LOCAL
SEGMENT SPACE MANAGEMENT AUTO;

CREATE USER test IDENTIFIED BY test12c 
DEFAULT TABLESPACE example
TEMPORARY TABLESPACE temp;

ALTER USER test QUOTA UNLIMITED ON example;

GRANT RESOURCE TO test ;

GRANT CONNECT TO test ;

GRANT SELECT ANY DICTIONARY TO test ;

CONNECT test/test12c

CREATE TABLE test1 AS SELECT * 
FROM dba_objects 
WHERE rownum=0;

set autotrace on statistics

INSERT INTO test1 SELECT * FROM dba_objects;

INSERT /*+ APPEND */ INTO test1 SELECT * 
FROM dba_objects;

ALTER TABLE test1 
MOVE PARTITION parti_001 TABLESPACE new_ts_001 NOLOGGING;

CREATE TABLE table_nolog_test2 NOLOGGING AS SELECT *    
FROM dba_objects;

CREATE TABLE table_nolog_test3 
AS SELECT * 
FROM dba_objects NOLOGGING;

SELECT table_name, logging 
FROM user_tables;

CREATE TABLE iot_test
(object_name,object_type,owner, 
CONSTRAINT iot_test_pk PRIMARY KEY(object_name,object_type,owner))ORGANIZATION INDEX
NOLOGGING
AS
SELECT DISTINCT object_name, object_type,owner
FROM dba_objects
WHERE rownum = 0
/  

CREATE TABLE test5 NOLOGGING
AS
SELECT object_name, object_type,owner
FROM dba_objects
WHERE rownum = 0
/  

set autotrace on statistics
INSERT /*+ APPEND */ INTO test5 
SELECT DISTINCT object_name, object_type, owner
FROM dba_objects; 

INSERT /*+ APPEND */ INTO iot_test 
SELECT DISTINCT object_name, object_type, owner
FROM dba_objects; 

SELECT table_name, logging 
FROM user_tables;

SELECT index_name, logging 
FROM user_indexes;

connect /

CREATE TABLE test5 NOLOGGING
AS
SELECT DISTINCT object_name, object_type,owner
FROM dba_objects
/  

SELECT a.name, b.value
FROM v$statname a, v$mystat b
WHERE a.statistic# = b.statistic#
AND a.name = 'redo size';

connect /

CREATE TABLE iot_test
(object_name,object_type,owner, 
CONSTRAINT iot_test_pk PRIMARY KEY(object_name,object_type,owner))ORGANIZATION INDEX
NOLOGGING
AS
SELECT DISTINCT object_name, object_type,owner
FROM dba_objects
/  

SELECT a.name, b.value
FROM v$statname a, v$mystat b
WHERE a.statistic# = b.statistic#
AND a.name = 'redo size';

CREATE TABLE test4 
AS SELECT owner, object_name, object_type 
FROM dba_objects;

set autotrace on statistics

INSERT INTO test4 
SELECT owner, object_name, object_type
FROM dba_objects;

connect /

DECLARE  
  CURSOR cur_c1 is    
SELECT owner, object_name, object_type FROM dba_objects;  
       rec_c1 cur_c1%ROWTYPE;
BEGIN  
OPEN cur_c1;  
     FOR rec_c1 in cur_c1
     LOOP
  INSERT INTO test4 VALUES (rec_c1.owner,
         rec_c1.object_name,rec_c1.object_type);             
     END LOOP; 
     COMMIT; 
CLOSE cur_c1;
END;
/

SELECT a.name, b.value
FROM v$statname a, v$mystat b
WHERE a.statistic# = b.statistic#
AND a.name = 'redo size';


set autotrace on statistics
create table test_seq_2 (a number);
create table test_seq_20 (a number);
create table test_seq_1000 (a number);
INSERT INTO test_seq_2 SELECT seq2.nextval FROM dba_objects ;
INSERT INTO test_seq_20 SELECT seq20.nextval FROM dba_objects ;
INSERT INTO test_seq_1000 SELECT seq1000.nextval FROM dba_objects ;

SELECT tablespace_name,logging 
FROM dba_tablespaces;

CREATE TABLE test_auto_intpart 
(id number, txt varchar2(4000), col_date date)
PARTITION BY RANGE (col_date)
INTERVAL(NUMTOYMINTERVAL(1, 'MONTH'))
( PARTITION ap2008 VALUES LESS THAN (TO_DATE('1-1-2009', 'DD-MM-YYYY')),
PARTITION ap2009 VALUES LESS THAN (TO_DATE('1-1-2010', 'DD-MM-YYYY')),
PARTITION ap2010 VALUES LESS THAN (TO_DATE('1-1-2011', 'DD-MM-YYYY')),
PARTITION ap2011 VALUES LESS THAN (TO_DATE('1-1-2012', 'DD-MM-YYYY')));  

SELECT TABLE_NAME, PARTITION_NAME, LOGGING,tablespace_name 
FROM user_tab_partitions;

set autotrace on statistics
INSERT /*+ APPEND */ INTO test_auto_intpart 
SELECT OBJ#*LINE,SOURCE,sysdate-365*mod(rownum,4) 
FROM sys.source$;

INSERT /*+ APPEND */ INTO test_auto_intpart 
SELECT OBJ#*LINE,SOURCE,sysdate+365*mod(rownum,4) 
FROM sys.source$;

COMMIT;
SELECT TABLE_NAME, PARTITION_NAME, LOGGING 
FROM   user_tab_partitions;

INSERT /*+ APPEND */ INTO test1 
SELECT * 
FROM dba_objects;

DROP TABLE t;

CREATE TABLE t ( x char(2000) ) nologging;

connect /

DECLARE
  type array is table of char(2000) index by binary_integer;
  l_data array;
BEGIN
  for i in 1 .. 1000
  loop
     l_data(i) := 'x';
  end loop;
  forall i in 1 .. l_data.count
       INSERT INTO t (x) VALUES (l_data(i));
 END;
 /


SELECT a.name, b.value
FROM v$statname a, v$mystat b
WHERE a.statistic# = b.statistic#
AND a.name = 'redo size';

connect /

DECLARE
   type array is table of char(2000) index by binary_integer;
   l_data array;
BEGIN
  for i in 1 .. 1000
  loop
     l_data(i) := 'x';
  end loop;
  forall i in 1 .. l_data.count
  INSERT /*+ APPENDd_VALUES */ INTO t (x) values (l_data(i));
END;
/

SELECT a.name, b.value
FROM v$statname a, v$mystat b
WHERE a.statistic# = b.statistic#
AND a.name = 'redo size';

SELECT name,value FROM v$sysstat 
WHERE name LIKE '%redo log space requests%';

SELECT s.sid, s.serial#, s.username, s.program,
       i.block_changes
FROM v$session s, v$sess_io i
WHERE s.sid = i.sid
ORDER BY 5 desc, 1, 2, 3, 4;

SELECT s.sid, s.serial#, s.username, s.program, 
       t.used_ublk, t.used_urec
FROM v$session s, v$transaction t
WHERE s.taddr = t.addr
ORDER BY 5 desc, 6 desc, 1, 2, 3, 4;



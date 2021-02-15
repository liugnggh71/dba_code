--- Author: Francisco Munoz Alvarez
--- Date  : 20/07/2013
--- Script: chapter8_examples.sql
--- Description: All examples done on chapter 8


--- Using Checksyntax

$ rman checksyntax
RMAN> BACKUP DURATON 2:00 TABLESPACE users;
RMAN> BACKUP DURATION 2:00 TABLESPACE users;
RMAN> BACKUP
RMAN> BACKUP ARCHIVELOG

--- Debugging RMAN using Debug Clause

RMAN> run{debug on;
2> BACKUP TABLESPACE users;
3> debug off;}

--- IO and RMAN

SQL>  SELECT s.sid, n.name , s.value/1024/1024 session_pga_mb
  2   FROM   v$statname n, v$sesstat s
  3   WHERE  s.sid = (SELECT sess.SID
  4                   FROM   V$PROCESS p, V$SESSION sess
  5                   WHERE  p.ADDR = sess.PADDR
  6                   AND    CLIENT_INFO LIKE '%rman%')
  7   AND    n.name = 'session pga memory'
  8*  AND    s.statistic# = n.statistic#

--- Monitoring RMAN IO Performance

SQL>  SELECT type, status, filename, buffer_size, buffer_count
 2    FROM   v$backup_async_io  WHERE type <> 'AGGREGATE'  
 3    AND    status = 'IN PROGRESS';

--- Monitoring RMAN sessions and operations

SQL> SELET s.sid,p.spid,s.client_info 
 2   FROM  V$process p, V$session s 
 3   WHERE p.addr=s.paddr AND client_info like '%rman%';

SQL> SELECT s.sid,p.spid,s.client_info  
 2   FROM   V$process p, V$session s
 3   WHERE  p.addr=s.paddr AND client_info like '%sess%';

RMAN> run{ 
2> set command id to 'session1';
3> backup tablespace users;}

RMAN> run{ 
2> set command id to 'session2';
3> backup tablespace users;}

SQL>  SELECT session_key S_KEY,session_recid S_RECID,start_time,
  2   end_time, round(output_bytes/1048576) as OUTPUT_MB, 
      elapsed_seconds
  3   FROM   v$rman_backup_job_details
  4   WHERE  start_time >= sysdate-180 and status='COMPLETED'
  5   AND    input_type='DB FULL';

SQL>SELECT type, item, units, sofar, total 
 2  FROM   V$RECOVERY_PROGRESS;

SQL> COLUMN program FORMAT a30
SQL> SELECT sid, serial#, program,status 
 2   FROM   v$session WHERE lower(program) LIKE '%rman%';

SQL> SELECT sid, serial#, program,status 
 2   FROM   v$session WHERE lower(program) LIKE '%rman%';

SQL> SELECT s.sid,p.spid,s.client_info  
 2   FROM   V$process p, V$session s
 3   WHERE  p.addr=s.paddr  and client_info like '%rman%';

SQL> SELECT sid, serial#, opname, time_remaining 
 2   FROM   v$session_longops Where sid||serial# in (39149) 
 3   AND    time_remaining > 0;

SQL> SELECT SID, SERIAL#, CONTEXT, SOFAR, TOTALWORK,
  2  ROUND(SOFAR/TOTALWORK*100,2) "%COMPLETE"
  3  FROM   V$SESSION_LONGOPS WHERE OPNAME LIKE 'RMAN%'
  4  AND    OPNAME NOT LIKE '%aggregate%'
  5  AND    TOTALWORK != 0 AND SOFAR <> TOTALWORK
  6  /

SQL> SELECT sid, event, seconds_in_wait AS sec_wait
  2  FROM   V$session_wait WHERE wait_time= 0 
  3  AND    sid in(SELECT sid FROM V$session
  4                WHERE lower(program) like '%rman%')
  5  /


--- Using Traces with RMAN

$ rman target / log=/tmp/rman.log trace=/tmp/rmantrc.trc debug=IO

$ rman target / catalog <connection> debug trace=/tmp/rmantrc.trc log=/tmp/rmanlog.txt







































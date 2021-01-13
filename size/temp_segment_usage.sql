SELECT sid_n_serial, tablespace, mb_used
  FROM (  SELECT s.inst_id || ':' || s.sid || ',' || s.serial#    sid_n_serial,
                 s.username,
                 s.osuser,
                 p.spid,
                 s.module,
                 p.program,
                 SUM (t.blocks) * tbs.block_size / 1024 / 1024    mb_used,
                 t.tablespace,
                 COUNT (*)                                        nbr_statements
            FROM gv$sort_usage  t,
                 gv$session     s,
                 dba_tablespaces tbs,
                 gv$process     p
           WHERE     p.INST_ID = t.INST_ID
                 AND p.INST_ID = s.INST_ID
                 AND t.session_addr = s.saddr
                 AND s.paddr = p.addr
                 AND t.tablespace = tbs.tablespace_name
        GROUP BY s.inst_id,
                 s.sid,
                 s.serial#,
                 s.username,
                 s.osuser,
                 p.spid,
                 s.module,
                 p.program,
                 tbs.block_size,
                 t.tablespace
        ORDER BY mb_used DESC)
 WHERE ROWNUM < 4;


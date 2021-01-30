if [ $# -lt 1 ]
 then
 echo " "
 echo "USAGE: pdb_test_mail.sh PDB"
 echo " "
 exit 1
fi

CONTAINER=${1}

sqlplus / as sysdba << EOF

alter session set container=${CONTAINER};
@$ORACLE_HOME/rdbms/admin/utlmail.sql
@$ORACLE_HOME/rdbms/admin/prvtmail.plb


BEGIN
    dbms_network_acl_admin.drop_acl('UTL_MAIL.xml');
END;
/

BEGIN
    DBMS_NETWORK_ACL_ADMIN.CREATE_ACL (acl           => 'UTL_MAIL.xml',
                                       description   => 'UTL_MAIL access ',
                                       principal     => 'SYSTEM',
                                       is_grant      => TRUE,
                                       privilege     => 'connect');

    DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE (acl         => 'UTL_MAIL.xml',
                                          principal   => 'SYSTEM',
                                          is_grant    => TRUE,
                                          privilege   => 'resolve');

    DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (acl    => 'UTL_MAIL.xml',
                                       HOST   => '192.168.121.140');
END;
/

COMMIT;

GRANT EXECUTE ON SYS.UTL_MAIL TO SYSTEM;

GRANT SELECT ON V_\$INSTANCE TO SYSTEM;
GRANT SELECT ON V_\$PDBS TO SYSTEM;

alter system set smtp_out_server='192.168.121.140:25' scope=both;

CREATE OR REPLACE PROCEDURE SYSTEM.test_utl_mail_send
AS
   v_host_name       VARCHAR2 (100);
   v_instance_name   VARCHAR2 (100);
   v_pdbs VARCHAR2 (100);
BEGIN
   SELECT host_name, instance_name
     INTO v_host_name, v_instance_name
     FROM v\$instance;

   select name into v_pdbs from v\$pdbs where rownum=1;

   SYS.UTL_MAIL.send (
      sender       => 'oracle@baylorhealth.edu',
      recipients   => 'gang.liu@bswhealth.org',
      cc           => NULL,
      bcc          => NULL,
      subject      => v_pdbs || ' on ' || v_host_name || '_' || v_instance_name || ' test title',
      MESSAGE      =>    'Test message time: '
                      || TO_CHAR (SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
      mime_type    => 'text/plain; charset=us-ascii',
      priority     => 1);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (
         v_host_name || ' Send mail have issues, message is not sent');
END;
/

BEGIN
    SYSTEM.test_utl_mail_send;
END;
/
EOF


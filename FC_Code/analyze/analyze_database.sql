Set echo on

 execute DBMS_STATS.GATHER_SYSTEM_STATS;
 execute dbms_stats.gather_dictionary_stats;
 execute dbms_stats.gather_fixed_objects_stats;
begin
 dbms_stats.gather_database_stats(
    ESTIMATE_PERCENT => 10,
       cascade => TRUE,
       degree => 4,
       method_opt => 'for all columns size AUTO'
 );
End;
/

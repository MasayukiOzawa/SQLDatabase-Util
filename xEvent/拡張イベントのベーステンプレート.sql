IF EXISTS(select 1 from sys.database_event_sessions where name = 'Query_Trace')
BEGIN
    DROP EVENT SESSION [Query_Trace] ON DATABASE
END
  
  
DECLARE @LogName nvarchar(1000) = N'https://<ストレージアカウント名>.blob.core.windows.net/<コンテナー名>/queryinfo.xel'
  
DECLARE @sql nvarchar(max) = '
CREATE EVENT SESSION [Query_Trace] ON DATABASE 
ADD EVENT sqlserver.blocked_process_report,
ADD EVENT sqlserver.execution_warning(SET collect_server_memory_grants=(1)
    ACTION(sqlserver.sql_text)),
ADD EVENT sqlserver.hash_warning(
    ACTION(sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.sql_text)),
ADD EVENT sqlserver.lock_deadlock_chain(SET collect_database_name=(1),collect_resource_description=(1)
    ACTION(sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.sql_text)),
ADD EVENT sqlserver.missing_column_statistics(SET collect_column_list=(1)
    ACTION(sqlserver.sql_text)),
ADD EVENT sqlserver.sort_warning(
    ACTION(sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.sql_text)),
ADD EVENT sqlserver.sql_batch_completed(SET collect_batch_text=(1)
    WHERE ([duration]>=(10000000))),
ADD EVENT sqlserver.xml_deadlock_report(
    ACTION(sqlserver.sql_text))
ADD TARGET package0.event_file(SET filename=''' + @LogName + ''',max_file_size=(100))
WITH (STARTUP_STATE=OFF);
'
EXEC (@sql)
 
 
ALTER EVENT SESSION [Query_Trace] ON DATABASE STATE=START

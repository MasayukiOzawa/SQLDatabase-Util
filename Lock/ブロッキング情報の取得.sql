﻿/*********************************************/
-- ブロッキングが発生しているセッションの取得
/*********************************************/
SELECT
	session_id, 
	wait_duration_ms, 
	wait_type, blocking_session_id 
FROM 
	sys.dm_os_waiting_tasks 
WHERE
	blocking_session_id IS NOT NULL 
ORDER BY 
	session_id
OPTION (RECOMPILE)
GO

/*********************************************/
-- ブロッキングに関連するセッションのロック情報の取得
/*********************************************/
SELECT 
	request_session_id, 
	resource_type,resource_subtype, 
	DB_NAME(resource_database_id) AS dbname,  
	resource_description,
	resource_lock_partition, 
	request_mode,request_type,
	request_status, 
	request_owner_type
FROM 
	sys.dm_tran_locks
WHERE 
	request_session_id IN
	(SELECT session_id FROM sys.dm_os_waiting_tasks WHERE blocking_session_id IS NOT NULL)
	OR
	request_session_id IN
	(SELECT blocking_session_id FROM sys.dm_os_waiting_tasks WHERE blocking_session_id IS NOT NULL)
ORDER BY 
	request_session_id
OPTION (RECOMPILE)
GO

/*********************************************/
-- ブロッキングの発生の原因となっているクエリ情報の取得
/*********************************************/
SELECT 
	er.session_id, start_time, 
	er.status, command,
	DB_NAME(er.database_id) as dbname, 
	blocking_session_id, 
	wait_type,
	last_wait_type, 
	wait_resource, 
	er.lock_timeout, 
	er.deadlock_priority,
	es.login_time,es.host_name,
	es.program_name,
	es.login_name,
	es.status as session_status, 
	es.row_count,
	wait_time, 
	er.total_elapsed_time, 
	REPLACE(REPLACE(REPLACE(SUBSTRING(text, 
	([statement_start_offset] / 2) + 1, 
	((CASE [statement_end_offset]
	WHEN -1 THEN DATALENGTH(text)
	ELSE [statement_end_offset]
	END - [statement_start_offset]) / 2) + 1),CHAR(13), ' '), CHAR(10), ' '), CHAR(9), ' ') AS stmt_text,
	text
FROM 
	sys.dm_exec_requests AS er
	OUTER APPLY
	sys.dm_exec_sql_text(sql_handle)
	LEFT JOIN
	sys.dm_exec_sessions AS es
	ON
	er.session_id = es.session_id
WHERE 
	er.session_id IN 
	(SELECT session_id FROM sys.dm_os_waiting_tasks WHERE blocking_session_id IS NOT NULL)
	OR
	er.session_id IN 
	(SELECT blocking_session_id FROM sys.dm_os_waiting_tasks WHERE blocking_session_id IS NOT NULL)
OPTION (RECOMPILE)

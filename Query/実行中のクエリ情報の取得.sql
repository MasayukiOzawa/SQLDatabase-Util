﻿SET NOCOUNT ON
GO

SELECT
    es.session_id,
    er.request_id,
    er.start_time,
    er.start_time,
    es.last_request_start_time,
    es.last_request_end_time,
    REPLACE(REPLACE(ec_text.text,CHAR(13), ''), CHAR(10), ' ') AS ec_text,
    REPLACE(REPLACE(er_text.text,CHAR(13), ''), CHAR(10), ' ') AS er_text,
    er.command,
    es.status,
    er.wait_type,
    er.last_wait_type,
    er.wait_resource,
    er.database_id,
    DB_NAME(er.database_id) AS database_name,
    er.user_id,
    er.wait_time,
    er.open_resultset_count,
    er.open_resultset_count,
    er.percent_complete,
    er.estimated_completion_time,
    es.total_elapsed_time,
    er.total_elapsed_time AS exec_requests_total_elapsed_time,
    es.cpu_time,
    er.cpu_time AS exec_requests_cpu_time,
	er.dop,
    es.memory_usage,
    es.total_scheduled_time,
    es.reads,
    er.reads AS exec_requests_reads,
    es.writes,
    er.writes AS exec_requests_writes,
    es.logical_reads,
    er.logical_reads AS exec_requests_logical_reads,
    es.row_count,
    er.row_count AS exec_requests_row_count,
	tsu.user_objects_alloc_page_count,
	tsu.user_objects_dealloc_page_count,
	tsu.internal_objects_dealloc_page_count,
	tsu.internal_objects_dealloc_page_count,
	er.start_time,
    er.granted_query_memory,
    er.scheduler_id,
    er.transaction_isolation_level,
    er.executing_managed_code,
    es.lock_timeout,
    er.lock_timeout as exec_requests_lock_timeout,
    es.deadlock_priority,
    er.deadlock_priority AS exec_requests_deadlock_priority,
    es.host_name,
    es.program_name,
    es.login_time,
    es.login_name,
    es.client_version,
    es.client_interface_name,
    er_plan.query_plan AS er_plan,
	er.query_hash,
    er.query_plan_hash
FROM
    sys.dm_exec_requests er WITH (NOLOCK)
    LEFT JOIN
    sys.dm_exec_sessions es WITH (NOLOCK)
    ON
    es.session_id = er.session_id
    LEFT JOIN
    (SELECT * FROM sys.dm_exec_connections WITH (NOLOCK) WHERE most_recent_sql_handle <> 0x0) AS ec
    ON
    es.session_id = ec.session_id
    OUTER APPLY
    sys.dm_exec_sql_text(er.sql_handle) AS er_text
    OUTER APPLY
    sys.dm_exec_sql_text(ec.most_recent_sql_handle) AS ec_text
	OUTER APPLY
	sys.dm_exec_query_plan(er.plan_handle) as er_plan
	LEFT JOIN
	sys.dm_db_task_space_usage AS tsu WITH (NOLOCK)
	ON
	tsu.session_id = er.session_id
	AND
	tsu.request_id = er.request_id
WHERE
    es.session_id <> @@SPID
ORDER BY
	exec_requests_cpu_time DESC,
	cpu_time DESC, 
	session_id ASC
OPTION (RECOMPILE)

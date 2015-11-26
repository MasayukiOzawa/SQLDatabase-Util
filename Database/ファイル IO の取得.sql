-- ユーザーデータベース
SELECT 
	[database_files].[name], 
	[database_files].[type_desc],
	[database_files].[size] * 8.0 AS size,  
	[database_files].[max_size] * 8.0 AS max_size_KB,  
	[database_files].[growth],
	[database_files].[is_percent_growth],
	[fn_virtualfilestats].[NumberReads], 
	[fn_virtualfilestats].[IoStallReadMS], 
	[fn_virtualfilestats].[BytesRead],  
	[fn_virtualfilestats].[NumberWrites],  
	[fn_virtualfilestats].[IoStallWriteMS], 
	[fn_virtualfilestats].[BytesWritten],  
	[fn_virtualfilestats].[BytesOnDisk] 
FROM 
	fn_virtualfilestats(DB_ID(), NULL) 
	LEFT JOIN
	sys.database_files
	ON
	database_files.file_id  = fn_virtualfilestats.FileId
OPTION (RECOMPILE)


-- tempdb
SELECT 
	[fn_virtualfilestats].[DbId], 
	[fn_virtualfilestats].[FileId], 
	[fn_virtualfilestats].[NumberReads], 
	[fn_virtualfilestats].[IoStallReadMS], 
	[fn_virtualfilestats].[BytesRead],  
	[fn_virtualfilestats].[NumberWrites],  
	[fn_virtualfilestats].[IoStallWriteMS], 
	[fn_virtualfilestats].[BytesWritten],  
	[fn_virtualfilestats].[BytesOnDisk] 
FROM 
	fn_virtualfilestats(2, NULL) 
OPTION (RECOMPILE)



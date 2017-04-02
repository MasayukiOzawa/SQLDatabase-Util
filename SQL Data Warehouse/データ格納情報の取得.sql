-- オブジェクトのデータ格納状態の取得
SELECT
	o.name,
	m.physical_name,
	i.name,
	im.physical_name,
	ps.index_id,
	i.type_desc,
	ps.partition_number,
	ps.used_page_count,
	ps.row_count,
	ps.pdw_node_id,
	ps.distribution_id
FROM 
	sys.dm_pdw_nodes_db_partition_stats ps
	INNER JOIN
	sys.pdw_nodes_tables t
	ON
	ps.object_id = t.object_id
	AND
	ps.pdw_node_id = t.pdw_node_id
	AND
	ps.distribution_id = t.distribution_id
	LEFT JOIN
	sys.pdw_table_mappings m
	ON
	m.physical_name = t.name
	LEFT JOIN
	sys.objects o
	ON
	o.object_id = m.object_id
	LEFT JOIN
	sys.pdw_nodes_indexes ni
	ON
	ps.object_id = ni.object_id
	AND
	ps.index_id = ni.index_id
	AND
	ps.pdw_node_id = ni.pdw_node_id
	AND
	ps.distribution_id = ni.distribution_id
	LEFT JOIN
	sys.pdw_index_mappings im
	ON
	im.physical_name = ni.name
	LEFT JOIN sys.indexes i
	ON
	i.object_id = im.object_id
	AND
	i.index_id = im.index_id

ORDER BY
	o.name, ps.index_id, ps.partition_number,ps.distribution_id
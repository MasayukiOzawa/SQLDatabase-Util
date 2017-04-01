-- ディストリビューションの確認
SELECT
	* 
FROM 
	sys.dm_pdw_nodes n
	LEFT JOIN
	sys.pdw_distributions  d
	ON
	d.pdw_node_id = n.pdw_node_id
ORDER BY distribution_id
GO

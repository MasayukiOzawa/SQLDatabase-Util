-- �f�B�X�g���r���[�V�����̊m�F
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

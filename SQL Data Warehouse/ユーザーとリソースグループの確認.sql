-- ���[�U�[�ƃ��\�[�X�O���[�v�̊m�F
-- https://docs.microsoft.com/ja-jp/azure/sql-data-warehouse/sql-data-warehouse-develop-concurrency#a-namequeued-query-detection-and-other-dmvsa�L���[�ɔz�u���ꂽ�N�G���̌��o�Ƃ��̑���-dmv
SELECT     r.name AS role_principal_name
        ,m.name AS member_principal_name
FROM    sys.database_role_members rm
JOIN    sys.database_principals AS r            ON rm.role_principal_id        = r.principal_id
JOIN    sys.database_principals AS m            ON rm.member_principal_id    = m.principal_id
WHERE    r.name IN ('mediumrc','largerc', 'xlargerc');
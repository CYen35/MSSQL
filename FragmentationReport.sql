exec sp_msforeachdb 'USE ?; SELECT DB_NAME(db_id()) DatabaseName, OBJECT_NAME(ind.OBJECT_ID) AS TableName, I.rows as [ROWCOUNT],
ind.name AS IndexName, indexstats.index_type_desc AS IndexType,
indexstats.avg_fragmentation_in_percent, indexstats.avg_fragment_size_in_pages, indexstats.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) indexstats
INNER JOIN sys.indexes ind
ON ind.object_id = indexstats.object_id
INNER JOIN
sys.tables as T
ON T.object_id = ind.OBJECT_ID
INNER JOIN sys.sysindexes as I
ON T.object_id = I.id
AND I.indid < 2
AND ind.index_id = indexstats.index_id
WHERE indexstats.avg_fragmentation_in_percent > 15
ORDER BY indexstats.avg_fragmentation_in_percent DESC'

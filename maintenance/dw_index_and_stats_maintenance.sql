USE Banking_DW;
GO

/* =========================================================
   DW Maintenance: Index fragmentation + Update Stats
   Beginner-friendly, safe defaults
   ========================================================= */

-- 1) See fragmentation (top 50 most fragmented)
SELECT TOP (50)
    OBJECT_NAME(s.object_id) AS TableName,
    i.name AS IndexName,
    s.avg_fragmentation_in_percent AS FragPercent,
    s.page_count AS PageCount
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'SAMPLED') s
JOIN sys.indexes i
    ON s.object_id = i.object_id
   AND s.index_id = i.index_id
WHERE i.name IS NOT NULL
  AND s.page_count >= 1000          -- ignore tiny indexes
ORDER BY s.avg_fragmentation_in_percent DESC;
GO


/* =========================================================
   2) Rebuild/Reorganize indexes automatically
   Rules (common interview-friendly rules):
   - < 5%  : do nothing
   - 5-30% : REORGANIZE
   - > 30% : REBUILD
   ========================================================= */

DECLARE
    @schema sysname,
    @table  sysname,
    @index  sysname,
    @frag   float,
    @sql    nvarchar(max);

DECLARE cur CURSOR FAST_FORWARD FOR
SELECT
    OBJECT_SCHEMA_NAME(s.object_id) AS SchemaName,
    OBJECT_NAME(s.object_id) AS TableName,
    i.name AS IndexName,
    s.avg_fragmentation_in_percent AS FragPercent
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'SAMPLED') s
JOIN sys.indexes i
    ON s.object_id = i.object_id
   AND s.index_id = i.index_id
WHERE i.name IS NOT NULL
  AND s.page_count >= 1000
  AND s.avg_fragmentation_in_percent >= 5.0;

OPEN cur;
FETCH NEXT FROM cur INTO @schema, @table, @index, @frag;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @frag > 30.0
        SET @sql = N'ALTER INDEX ' + QUOTENAME(@index) +
                   N' ON ' + QUOTENAME(@schema) + N'.' + QUOTENAME(@table) +
                   N' REBUILD;';
    ELSE
        SET @sql = N'ALTER INDEX ' + QUOTENAME(@index) +
                   N' ON ' + QUOTENAME(@schema) + N'.' + QUOTENAME(@table) +
                   N' REORGANIZE;';

    PRINT @sql;
    EXEC sp_executesql @sql;

    FETCH NEXT FROM cur INTO @schema, @table, @index, @frag;
END

CLOSE cur;
DEALLOCATE cur;
GO


/* =========================================================
   3) Update statistics (important after large loads)
   ========================================================= */
EXEC sp_updatestats;
GO

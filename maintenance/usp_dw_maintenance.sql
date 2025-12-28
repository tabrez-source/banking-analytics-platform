USE Banking_DW;
GO

CREATE OR ALTER PROCEDURE dbo.usp_DW_Run_Maintenance
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @start datetime2(0) = SYSDATETIME();
    DECLARE @rows int = 0;  -- (not used here, but kept for audit consistency)

    INSERT INTO dbo.DW_Load_Audit (ProcessName, StartTime, Status)
    VALUES ('DW_Maintenance', @start, 'STARTED');

    BEGIN TRY
        /* =========================================================
           1) Rebuild/Reorganize indexes (same rules as your script)
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

            EXEC sp_executesql @sql;

            FETCH NEXT FROM cur INTO @schema, @table, @index, @frag;
        END

        CLOSE cur;
        DEALLOCATE cur;

        /* =========================================================
           2) Update statistics
           ========================================================= */
        EXEC sp_updatestats;

        UPDATE dbo.DW_Load_Audit
        SET EndTime = SYSDATETIME(),
            RowsAffected = @rows,
            Status = 'SUCCESS'
        WHERE ProcessName = 'DW_Maintenance'
          AND StartTime = @start;
    END TRY
    BEGIN CATCH
        UPDATE dbo.DW_Load_Audit
        SET EndTime = SYSDATETIME(),
            Status = 'FAILED',
            ErrorMessage = ERROR_MESSAGE()
        WHERE ProcessName = 'DW_Maintenance'
          AND StartTime = @start;

        THROW;
    END CATCH
END;
GO

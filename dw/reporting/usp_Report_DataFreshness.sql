/* =========================================================
   4) Data Freshness / Last Load Status
   Uses: dbo.DW_Load_Audit
   ========================================================= */
CREATE OR ALTER PROCEDURE dbo.usp_Report_DataFreshness
AS
BEGIN
    SET NOCOUNT ON;

    -- Latest run per process
    WITH x AS
    (
        SELECT
            ProcessName,
            StartTime,
            EndTime,
            RowsAffected,
            Status,
            ErrorMessage,
            ROW_NUMBER() OVER (PARTITION BY ProcessName ORDER BY StartTime DESC) AS rn
        FROM dbo.DW_Load_Audit
    )
    SELECT
        ProcessName,
        StartTime,
        EndTime,
        RowsAffected,
        Status,
        ErrorMessage
    FROM x
    WHERE rn = 1
    ORDER BY ProcessName;
END;
GO
/* =========================================================
   3) Transaction Detail (for drill-through)
   Uses: dbo.vw_FactTransactions_Enriched
   ========================================================= */
CREATE OR ALTER PROCEDURE dbo.usp_Report_TransactionsDetail
    @StartDate date = NULL,
    @EndDate date = NULL,
    @TransactionType varchar(20) = NULL,
    @IsFraud bit = NULL,
    @SourceAccountCode varchar(50) = NULL,
    @DestinationAccountCode varchar(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (5000)
        TransactionSK,
        FullDate,
        [Year],
        [Month],
        WeekdayName,
        TransactionType,
        SourceAccountCode,
        SourceAccountType,
        DestinationAccountCode,
        DestinationAccountType,
        Amount,
        IsFraud,
        IsFlaggedFraud,
        LoadDts
    FROM dbo.vw_FactTransactions_Enriched
    WHERE (@StartDate IS NULL OR FullDate >= @StartDate)
      AND (@EndDate IS NULL OR FullDate <= @EndDate)
      AND (@TransactionType IS NULL OR TransactionType = @TransactionType)
      AND (@IsFraud IS NULL OR IsFraud = @IsFraud)
      AND (@SourceAccountCode IS NULL OR SourceAccountCode = @SourceAccountCode)
      AND (@DestinationAccountCode IS NULL OR DestinationAccountCode = @DestinationAccountCode)
    ORDER BY LoadDts DESC;
END;
GO
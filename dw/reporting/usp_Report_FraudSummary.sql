/* =========================================================
   1) Fraud Summary (Year/Month/Type filters)
   Uses: dbo.vw_FraudSummary_ByMonth
   ========================================================= */
CREATE OR ALTER PROCEDURE dbo.usp_Report_FraudSummary
    @Year int = NULL,
    @Month int = NULL,
    @TransactionType varchar(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [Year],
        [Month],
        TransactionType,
        TotalTransactions,
        FraudTransactions,
        TotalAmount,
        FraudAmount,
        FraudRatePct
    FROM dbo.vw_FraudSummary_ByMonth
    WHERE (@Year IS NULL OR [Year] = @Year)
      AND (@Month IS NULL OR [Month] = @Month)
      AND (@TransactionType IS NULL OR TransactionType = @TransactionType)
    ORDER BY [Year], [Month], TransactionType;
END;
GO



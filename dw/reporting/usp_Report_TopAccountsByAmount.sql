/* =========================================================
   2) Top Source Accounts by Amount
   Uses: dbo.vw_TopAccounts_ByAmount
   ========================================================= */
CREATE OR ALTER PROCEDURE dbo.usp_Report_TopAccountsByAmount
    @TopN int = 20,
    @AccountType varchar(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Guardrails (basic + interview-friendly)
    IF @TopN IS NULL OR @TopN < 1 SET @TopN = 20;
    IF @TopN > 1000 SET @TopN = 1000;

    SELECT TOP (@TopN)
        SourceAccountCode,
        SourceAccountType,
        TotalTransactions,
        TotalAmount,
        FraudTransactions
    FROM dbo.vw_TopAccounts_ByAmount
    WHERE (@AccountType IS NULL OR SourceAccountType = @AccountType)
    ORDER BY TotalAmount DESC;
END;
GO
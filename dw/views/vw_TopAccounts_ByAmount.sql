CREATE OR ALTER VIEW dbo.vw_TopAccounts_ByAmount
AS
SELECT
    sa.AccountCode AS SourceAccountCode,
    sa.AccountType AS SourceAccountType,
    COUNT(*) AS TotalTransactions,
    SUM(f.Amount) AS TotalAmount,
    SUM(CASE WHEN f.IsFraud = 1 THEN 1 ELSE 0 END) AS FraudTransactions
FROM dbo.FactTransactions f
JOIN dbo.DimAccount sa
    ON sa.AccountKey = f.SourceAccountKey
GROUP BY
    sa.AccountCode, sa.AccountType;
GO



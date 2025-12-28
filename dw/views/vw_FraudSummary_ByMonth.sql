CREATE OR ALTER VIEW dbo.vw_FraudSummary_ByMonth
AS
SELECT
    d.[Year],
    d.[Month],
    tt.TypeName AS TransactionType,

    COUNT(*) AS TotalTransactions,
    SUM(CASE WHEN f.IsFraud = 1 THEN 1 ELSE 0 END) AS FraudTransactions,
    SUM(f.Amount) AS TotalAmount,
    SUM(CASE WHEN f.IsFraud = 1 THEN f.Amount ELSE 0 END) AS FraudAmount,

    CAST(
        100.0 * SUM(CASE WHEN f.IsFraud = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0)
        AS decimal(10,2)
    ) AS FraudRatePct
FROM dbo.FactTransactions f
JOIN dbo.DimDate d
    ON d.DateKey = f.DateKey
JOIN dbo.DimTransactionType tt
    ON tt.TransactionTypeKey = f.TransactionTypeKey
GROUP BY
    d.[Year], d.[Month], tt.TypeName;
GO

USE Banking_dw;
GO

-- 1) Enriched view: Fact + Dimensions
CREATE OR ALTER VIEW dbo.vw_FactTransactions_Enriched
AS
SELECT
    f.FactTransactionKey,
    f.TransactionSK,
    d.FullDate,
    d.[Year],
    d.[Month],
    tt.TypeName AS TransactionType,

    sa.AccountKey  AS SourceAccountKey,
    sa.AccountCode AS SourceAccountCode,
    sa.AccountType AS SourceAccountType,

    da.AccountKey  AS DestinationAccountKey,
    da.AccountCode AS DestinationAccountCode,
    da.AccountType AS DestinationAccountType,

    f.Amount,
    f.OldBalanceSource,
    f.NewBalanceSource,
    f.OldBalanceDest,
    f.NewBalanceDest,
    f.IsFraud,
    f.IsFlaggedFraud,
    f.LoadDts
FROM dbo.FactTransactions f
JOIN dbo.DimDate d
    ON f.DateKey = d.DateKey
JOIN dbo.DimTransactionType tt
    ON f.TransactionTypeKey = tt.TransactionTypeKey
JOIN dbo.DimAccount sa
    ON f.SourceAccountKey = sa.AccountKey
JOIN dbo.DimAccount da
    ON f.DestinationAccountKey = da.AccountKey;
GO
-- 3) Monthly amount trend
CREATE OR ALTER VIEW dbo.vw_Amount_ByYearMonth
AS
SELECT
    d.Year,
    d.Month,
    SUM(f.Amount) AS TotalAmount,
    COUNT(*) AS TotalTransactions
FROM dbo.FactTransactions f
JOIN dbo.DimDate d
    ON f.DateKey = d.DateKey
GROUP BY d.Year, d.Month;
GO


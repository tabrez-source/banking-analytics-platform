CREATE OR ALTER VIEW dbo.vw_FactTransactions_Enriched
AS
SELECT
    f.FactTransactionKey,
    f.TransactionSK,
    d.FullDate,
    d.[Year],
    d.[Month],
    d.WeekdayName,
    f.Step,

    tt.TypeName AS TransactionType,

    sa.AccountCode AS SourceAccountCode,
    sa.AccountType AS SourceAccountType,

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
    ON d.DateKey = f.DateKey
JOIN dbo.DimTransactionType tt
    ON tt.TransactionTypeKey = f.TransactionTypeKey
JOIN dbo.DimAccount sa
    ON sa.AccountKey = f.SourceAccountKey
JOIN dbo.DimAccount da
    ON da.AccountKey = f.DestinationAccountKey;
GO

USE Banking_dw;
GO

INSERT INTO dbo.FactTransactions (
    DateKey, SourceAccountKey, DestinationAccountKey, TransactionTypeKey,
    TransactionSK, Step,
    Amount, OldBalanceSource, NewBalanceSource, OldBalanceDest, NewBalanceDest,
    IsFraud, IsFlaggedFraud, LoadDts
)
SELECT
    d.DateKey,
    sa.AccountKey,
    da.AccountKey,
    tt.TransactionTypeKey,

    o.TransactionSK,
    o.Step,

    o.Amount,
    o.OldBalanceSource,
    o.NewBalanceSource,
    o.OldBalanceDest,
    o.NewBalanceDest,
    o.IsFraud,
    o.IsFlaggedFraud,
    o.LoadDts
FROM Banking_OLTP.dbo.Transactions o
JOIN dbo.DimDate d
    ON d.Step = o.Step
JOIN dbo.DimAccount sa
    ON sa.AccountID = o.SourceAccountID
JOIN dbo.DimAccount da
    ON da.AccountID = o.DestinationAccountID
JOIN dbo.DimTransactionType tt
    ON tt.TransactionTypeID = o.TransactionTypeID;
GO

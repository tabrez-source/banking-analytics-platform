USE Banking_OLTP;
GO

-- Log invalid amounts
INSERT INTO dbo.Rejected_Transactions
(step,[type],amount,nameOrig,oldbalanceOrg,newbalanceOrig,nameDest,oldbalanceDest,newbalanceDest,isFraud,isFlaggedFraud,RejectReason)
SELECT
    s.step, s.[type], s.amount, s.nameOrig, s.oldbalanceOrg, s.newbalanceOrig,
    s.nameDest, s.oldbalanceDest, s.newbalanceDest, s.isFraud, s.isFlaggedFraud,
    'Invalid Amount (NULL or <= 0)'
FROM Banking_Staging.dbo.Staging_Transactions s
WHERE TRY_CONVERT(DECIMAL(18,2), s.amount) IS NULL
   OR TRY_CONVERT(DECIMAL(18,2), s.amount) <= 0;

-- Load only valid rows
INSERT INTO dbo.Transactions
(
    Step,
    SourceAccountID,
    DestinationAccountID,
    TransactionTypeID,
    Amount,
    OldBalanceSource,
    NewBalanceSource,
    OldBalanceDest,
    NewBalanceDest,
    IsFraud,
    IsFlaggedFraud
)
SELECT
    TRY_CONVERT(INT, s.step) AS Step,
    a1.AccountID,
    a2.AccountID,
    tt.TransactionTypeID,
    TRY_CONVERT(DECIMAL(18,2), s.amount) AS Amount,
    TRY_CONVERT(DECIMAL(18,2), s.oldbalanceOrg),
    TRY_CONVERT(DECIMAL(18,2), s.newbalanceOrig),
    TRY_CONVERT(DECIMAL(18,2), s.oldbalanceDest),
    TRY_CONVERT(DECIMAL(18,2), s.newbalanceDest),
    CASE WHEN s.isFraud IN ('1','true','TRUE') THEN 1 ELSE 0 END,
    CASE WHEN s.isFlaggedFraud IN ('1','true','TRUE') THEN 1 ELSE 0 END
FROM Banking_Staging.dbo.Staging_Transactions s
JOIN dbo.Accounts a1 ON a1.AccountCode = s.nameOrig
JOIN dbo.Accounts a2 ON a2.AccountCode = s.nameDest
JOIN dbo.TransactionTypes tt ON tt.TypeName = s.[type]
WHERE TRY_CONVERT(DECIMAL(18,2), s.amount) > 0;
GO

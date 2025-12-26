USE Banking_OLTP;
GO

CREATE INDEX IX_Accounts_AccountCode ON dbo.Accounts(AccountCode);
CREATE INDEX IX_Transactions_Step ON dbo.Transactions(Step);
CREATE INDEX IX_Transactions_Type ON dbo.Transactions(TransactionTypeID);
CREATE INDEX IX_Transactions_IsFraud ON dbo.Transactions(IsFraud);
GO

USE Banking_dw;
GO

CREATE INDEX IX_Fact_DateKey ON dbo.FactTransactions(DateKey);
CREATE INDEX IX_Fact_TypeKey ON dbo.FactTransactions(TransactionTypeKey);
CREATE INDEX IX_Fact_SourceKey ON dbo.FactTransactions(SourceAccountKey);
CREATE INDEX IX_Fact_DestKey ON dbo.FactTransactions(DestinationAccountKey);
CREATE INDEX IX_Fact_Fraud ON dbo.FactTransactions(IsFraud, IsFlaggedFraud);
GO

USE Banking_dw;
GO

SELECT COUNT(*) AS DimAccountCount FROM dbo.DimAccount;
SELECT COUNT(*) AS DimTypeCount FROM dbo.DimTransactionType;
SELECT COUNT(*) AS DimDateCount FROM dbo.DimDate;
SELECT COUNT(*) AS FactCount FROM dbo.FactTransactions;
GO

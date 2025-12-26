USE Banking_OLTP;
GO

INSERT INTO dbo.TransactionTypes (TypeName)
SELECT DISTINCT s.[type]
FROM Banking_Staging.dbo.Staging_Transactions s
WHERE s.[type] IS NOT NULL;
GO

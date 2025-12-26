USE Banking_OLTP;
GO

INSERT INTO dbo.Accounts (AccountCode, AccountType)
SELECT DISTINCT
    s.nameOrig,
    CASE
        WHEN s.nameOrig LIKE 'C%' THEN 'Customer'
        WHEN s.nameOrig LIKE 'M%' THEN 'Merchant'
        ELSE 'Unknown'
    END
FROM Banking_Staging.dbo.Staging_Transactions s
WHERE s.nameOrig IS NOT NULL;

INSERT INTO dbo.Accounts (AccountCode, AccountType)
SELECT DISTINCT
    s.nameDest,
    CASE
        WHEN s.nameDest LIKE 'C%' THEN 'Customer'
        WHEN s.nameDest LIKE 'M%' THEN 'Merchant'
        ELSE 'Unknown'
    END
FROM Banking_Staging.dbo.Staging_Transactions s
WHERE s.nameDest IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM dbo.Accounts a WHERE a.AccountCode = s.nameDest);
GO

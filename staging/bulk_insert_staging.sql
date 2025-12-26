USE Banking_Staging;
GO

-- Place the CSV locally (do NOT commit it to GitHub):
-- C:\SQLData\transactions.csv

BULK INSERT dbo.Staging_Transactions
FROM 'C:\SQLData\transactions.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0d0a',
    CODEPAGE = '65001',
    TABLOCK,
    MAXERRORS = 10000,
    ERRORFILE = 'C:\SQLData\errors\staging_load_error'
);
GO

-- Quick validation
SELECT TOP 10 [step],[type],[amount],[nameOrig],[nameDest],[isFraud],[isFlaggedFraud]
FROM dbo.Staging_Transactions;

SELECT COUNT(*) AS LoadedRows
FROM dbo.Staging_Transactions;
GO

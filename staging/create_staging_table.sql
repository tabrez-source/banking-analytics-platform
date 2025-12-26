USE Banking_Staging;
GO

DROP TABLE IF EXISTS dbo.Staging_Transactions;
GO

CREATE TABLE dbo.Staging_Transactions (
    [step]            VARCHAR(50)   NULL,
    [type]            VARCHAR(50)   NULL,
    [amount]          VARCHAR(100)  NULL,
    [nameOrig]        VARCHAR(100)  NULL,
    [oldbalanceOrg]   VARCHAR(100)  NULL,
    [newbalanceOrig]  VARCHAR(100)  NULL,
    [nameDest]        VARCHAR(100)  NULL,
    [oldbalanceDest]  VARCHAR(100)  NULL,
    [newbalanceDest]  VARCHAR(100)  NULL,
    [isFraud]         VARCHAR(100)  NULL,
    [isFlaggedFraud]  VARCHAR(100)  NULL
);
GO
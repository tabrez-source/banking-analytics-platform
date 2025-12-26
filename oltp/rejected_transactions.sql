DROP TABLE IF EXISTS dbo.Rejected_Transactions;
GO
CREATE TABLE dbo.Rejected_Transactions (
    RejectID        BIGINT IDENTITY(1,1) PRIMARY KEY,
    step            VARCHAR(50),
    [type]          VARCHAR(50),
    amount          VARCHAR(100),
    nameOrig        VARCHAR(100),
    oldbalanceOrg   VARCHAR(100),
    newbalanceOrig  VARCHAR(100),
    nameDest        VARCHAR(100),
    oldbalanceDest  VARCHAR(100),
    newbalanceDest  VARCHAR(100),
    isFraud         VARCHAR(100),
    isFlaggedFraud  VARCHAR(100),
    RejectReason    VARCHAR(200),
    RejectDts       DATETIME2 DEFAULT SYSDATETIME()
);
GO

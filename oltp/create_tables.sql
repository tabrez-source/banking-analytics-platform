USE Banking_OLTP;
GO

DROP TABLE IF EXISTS dbo.Transactions;
DROP TABLE IF EXISTS dbo.TransactionTypes;
DROP TABLE IF EXISTS dbo.Accounts;
GO

CREATE TABLE dbo.Accounts (
    AccountID    INT IDENTITY(1,1) PRIMARY KEY,
    AccountCode  VARCHAR(50) NOT NULL UNIQUE,
    AccountType  VARCHAR(20) NOT NULL,
    CreatedAt    DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE dbo.TransactionTypes (
    TransactionTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName          VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE dbo.Transactions (
    TransactionSK        BIGINT IDENTITY(1,1) PRIMARY KEY,
    Step                 INT NOT NULL,
    SourceAccountID      INT NOT NULL,
    DestinationAccountID INT NOT NULL,
    TransactionTypeID    INT NOT NULL,
    Amount               DECIMAL(18,2) NOT NULL,
    OldBalanceSource     DECIMAL(18,2) NULL,
    NewBalanceSource     DECIMAL(18,2) NULL,
    OldBalanceDest       DECIMAL(18,2) NULL,
    NewBalanceDest       DECIMAL(18,2) NULL,
    IsFraud              BIT NOT NULL,
    IsFlaggedFraud       BIT NOT NULL,
    LoadDts              DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Trx_SourceAcc FOREIGN KEY (SourceAccountID) REFERENCES dbo.Accounts(AccountID),
    CONSTRAINT FK_Trx_DestAcc   FOREIGN KEY (DestinationAccountID) REFERENCES dbo.Accounts(AccountID),
    CONSTRAINT FK_Trx_Type      FOREIGN KEY (TransactionTypeID) REFERENCES dbo.TransactionTypes(TransactionTypeID),
    CONSTRAINT CHK_Trx_Amount   CHECK (Amount > 0)
);
GO

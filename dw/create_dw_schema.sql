USE Banking_dw;
GO

-- Drop if rerunning (safe)
IF OBJECT_ID('dbo.FactTransactions','U') IS NOT NULL DROP TABLE dbo.FactTransactions;
IF OBJECT_ID('dbo.DimTransactionType','U') IS NOT NULL DROP TABLE dbo.DimTransactionType;
IF OBJECT_ID('dbo.DimAccount','U') IS NOT NULL DROP TABLE dbo.DimAccount;
IF OBJECT_ID('dbo.DimDate','U') IS NOT NULL DROP TABLE dbo.DimDate;
GO

-- DimDate: based on Step (since dataset has step, not real timestamps)
CREATE TABLE dbo.DimDate (
    DateKey      INT        NOT NULL PRIMARY KEY,   -- YYYYMMDD
    FullDate     DATE       NOT NULL,
    [Year]       INT        NOT NULL,
    [Month]      INT        NOT NULL,
    [Day]        INT        NOT NULL,
    WeekdayName  VARCHAR(20) NOT NULL,
    Step         INT        NOT NULL UNIQUE
);
GO

-- DimAccount: one row per OLTP Account
CREATE TABLE dbo.DimAccount (
    AccountKey   INT IDENTITY(1,1) PRIMARY KEY,
    AccountID    INT NOT NULL UNIQUE,
    AccountCode  VARCHAR(50) NOT NULL,
    AccountType  VARCHAR(20) NOT NULL,
    CreatedAt    DATETIME2(7) NOT NULL
);
GO

-- DimTransactionType: one row per transaction type
CREATE TABLE dbo.DimTransactionType (
    TransactionTypeKey INT IDENTITY(1,1) PRIMARY KEY,
    TransactionTypeID  INT NOT NULL UNIQUE,
    TypeName           VARCHAR(20) NOT NULL
);
GO

-- FactTransactions: measures + foreign keys to dimensions
CREATE TABLE dbo.FactTransactions (
    FactTransactionKey     BIGINT IDENTITY(1,1) PRIMARY KEY,

    DateKey                INT NOT NULL,
    SourceAccountKey       INT NOT NULL,
    DestinationAccountKey  INT NOT NULL,
    TransactionTypeKey     INT NOT NULL,

    TransactionSK          BIGINT NOT NULL,
    Step                   INT NOT NULL,
    Amount                 DECIMAL(18,2) NOT NULL,
    OldBalanceSource       DECIMAL(18,2) NULL,
    NewBalanceSource       DECIMAL(18,2) NULL,
    OldBalanceDest         DECIMAL(18,2) NULL,
    NewBalanceDest         DECIMAL(18,2) NULL,
    IsFraud                BIT NOT NULL,
    IsFlaggedFraud         BIT NOT NULL,
    LoadDts                DATETIME2(7) NOT NULL
);
GO

-- Foreign Keys (basic and clear)
ALTER TABLE dbo.FactTransactions
ADD CONSTRAINT FK_Fact_Date
FOREIGN KEY (DateKey) REFERENCES dbo.DimDate(DateKey);

ALTER TABLE dbo.FactTransactions
ADD CONSTRAINT FK_Fact_SourceAccount
FOREIGN KEY (SourceAccountKey) REFERENCES dbo.DimAccount(AccountKey);

ALTER TABLE dbo.FactTransactions
ADD CONSTRAINT FK_Fact_DestAccount
FOREIGN KEY (DestinationAccountKey) REFERENCES dbo.DimAccount(AccountKey);

ALTER TABLE dbo.FactTransactions
ADD CONSTRAINT FK_Fact_Type
FOREIGN KEY (TransactionTypeKey) REFERENCES dbo.DimTransactionType(TransactionTypeKey);
GO

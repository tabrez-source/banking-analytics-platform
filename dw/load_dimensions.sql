USE Banking_dw;
GO

INSERT INTO dbo.DimTransactionType (TransactionTypeID, TypeName)
SELECT TransactionTypeID, TypeName
FROM Banking_OLTP.dbo.TransactionTypes;
GO

INSERT INTO dbo.DimAccount (AccountID, AccountCode, AccountType, CreatedAt)
SELECT AccountID, AccountCode, AccountType, CreatedAt
FROM Banking_OLTP.dbo.Accounts;
GO

DECLARE @StartDate DATE = '2017-01-01';

INSERT INTO dbo.DimDate (DateKey, FullDate, [Year], [Month], [Day], WeekdayName, Step)
SELECT DISTINCT
    CONVERT(INT, CONVERT(VARCHAR(8), DATEADD(DAY, t.Step, @StartDate), 112)) AS DateKey,
    DATEADD(DAY, t.Step, @StartDate) AS FullDate,
    YEAR(DATEADD(DAY, t.Step, @StartDate)) AS [Year],
    MONTH(DATEADD(DAY, t.Step, @StartDate)) AS [Month],
    DAY(DATEADD(DAY, t.Step, @StartDate)) AS [Day],
    DATENAME(WEEKDAY, DATEADD(DAY, t.Step, @StartDate)) AS WeekdayName,
    t.Step
FROM Banking_OLTP.dbo.Transactions t;
GO


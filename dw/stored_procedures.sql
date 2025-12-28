-- Load Dimensions Procedure
CREATE OR ALTER PROCEDURE dbo.usp_Load_DW_Dimensions
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @start datetime2(0) = SYSDATETIME();
    DECLARE @rows int = 0;

    INSERT INTO dbo.DW_Load_Audit (ProcessName, StartTime, Status)
    VALUES ('Load_Dimensions', @start, 'STARTED');

    BEGIN TRY
        /* Clear tables in FK-safe order */
        DELETE FROM dbo.FactTransactions;
        DELETE FROM dbo.DimTransactionType;
        DELETE FROM dbo.DimAccount;
        DELETE FROM dbo.DimDate;

        /* DimTransactionType: TransactionTypeKey is IDENTITY -> do not insert it */
        INSERT INTO dbo.DimTransactionType
        (
            TransactionTypeID,
            TypeName
        )
        SELECT
            TransactionTypeID,
            TypeName
        FROM Banking_OLTP.dbo.TransactionTypes;

        SET @rows += @@ROWCOUNT;

        /* DimAccount: AccountKey is IDENTITY -> do not insert it */
        INSERT INTO dbo.DimAccount
        (
            AccountID,
            AccountCode,
            AccountType,
            CreatedAt
        )
        SELECT
            AccountID,
            AccountCode,
            AccountType,
            CreatedAt
        FROM Banking_OLTP.dbo.Accounts;

        SET @rows += @@ROWCOUNT;

        /* DimDate: DateKey is not identity (key derived from Step) */
        INSERT INTO dbo.DimDate
        (
            DateKey,
            FullDate,
            [Year],
            [Month],
            [Day],
            WeekdayName,
            Step
        )
        SELECT DISTINCT
            CONVERT(int, CONVERT(char(8),
                DATEADD(day, t.Step - 1, '2017-01-01'), 112)) AS DateKey,
            CAST(DATEADD(day, t.Step - 1, '2017-01-01') AS date) AS FullDate,
            YEAR(DATEADD(day, t.Step - 1, '2017-01-01')) AS [Year],
            MONTH(DATEADD(day, t.Step - 1, '2017-01-01')) AS [Month],
            DAY(DATEADD(day, t.Step - 1, '2017-01-01')) AS [Day],
            DATENAME(weekday, DATEADD(day, t.Step - 1, '2017-01-01')) AS WeekdayName,
            t.Step
        FROM Banking_OLTP.dbo.Transactions t;

        SET @rows += @@ROWCOUNT;

        UPDATE dbo.DW_Load_Audit
        SET EndTime = SYSDATETIME(),
            RowsAffected = @rows,
            Status = 'SUCCESS'
        WHERE ProcessName = 'Load_Dimensions'
          AND StartTime = @start;

    END TRY
    BEGIN CATCH
        UPDATE dbo.DW_Load_Audit
        SET EndTime = SYSDATETIME(),
            Status = 'FAILED',
            ErrorMessage = ERROR_MESSAGE()
        WHERE ProcessName = 'Load_Dimensions'
          AND StartTime = @start;

        THROW;
    END CATCH
END;
GO

-- Load Fact Procedure
CREATE OR ALTER PROCEDURE dbo.usp_Load_DW_FactTransactions
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @start datetime2(0) = SYSDATETIME();
    DECLARE @rows int = 0;

    INSERT INTO dbo.DW_Load_Audit (ProcessName, StartTime, Status)
    VALUES ('Load_FactTransactions', @start, 'STARTED');

    BEGIN TRY
        /* Clear fact (safe) */
        DELETE FROM dbo.FactTransactions;

        /* FactTransactions: FactTransactionKey is IDENTITY -> do NOT insert it */
        INSERT INTO dbo.FactTransactions
        (
            TransactionSK,
            DateKey,
            SourceAccountKey,
            DestinationAccountKey,
            TransactionTypeKey,
            Step,
            Amount,
            OldBalanceSource,
            NewBalanceSource,
            OldBalanceDest,
            NewBalanceDest,
            IsFraud,
            IsFlaggedFraud,
            LoadDts
        )
        SELECT
            t.TransactionSK,
            d.DateKey,
            sa.AccountKey,
            da.AccountKey,
            tt.TransactionTypeKey,
            t.Step,
            t.Amount,
            t.OldBalanceSource,
            t.NewBalanceSource,
            t.OldBalanceDest,
            t.NewBalanceDest,
            t.IsFraud,
            t.IsFlaggedFraud,
            t.LoadDts
        FROM Banking_OLTP.dbo.Transactions t
        JOIN dbo.DimDate d
            ON d.Step = t.Step
        JOIN dbo.DimTransactionType tt
            ON tt.TransactionTypeID = t.TransactionTypeID
        JOIN dbo.DimAccount sa
            ON sa.AccountID = t.SourceAccountID
        JOIN dbo.DimAccount da
            ON da.AccountID = t.DestinationAccountID;

        SET @rows = @@ROWCOUNT;

        UPDATE dbo.DW_Load_Audit
        SET EndTime = SYSDATETIME(),
            RowsAffected = @rows,
            Status = 'SUCCESS'
        WHERE ProcessName = 'Load_FactTransactions'
          AND StartTime = @start;

    END TRY
    BEGIN CATCH
        UPDATE dbo.DW_Load_Audit
        SET EndTime = SYSDATETIME(),
            Status = 'FAILED',
            ErrorMessage = ERROR_MESSAGE()
        WHERE ProcessName = 'Load_FactTransactions'
          AND StartTime = @start;

        THROW;
    END CATCH
END;
GO


-- Orchestrator Procedure
CREATE OR ALTER PROCEDURE dbo.usp_Run_Full_DW_Load
AS
BEGIN
    SET NOCOUNT ON;

    EXEC dbo.usp_Load_DW_Dimensions;
    EXEC dbo.usp_Load_DW_FactTransactions;
END;
GO



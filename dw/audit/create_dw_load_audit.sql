CREATE TABLE dbo.dw_Load_Audit
(
    AuditID       int IDENTITY(1,1) PRIMARY KEY,
    ProcessName   varchar(100) NOT NULL,
    StartTime     datetime2(0) NOT NULL,
    EndTime       datetime2(0) NULL,
    RowsAffected  int NULL,
    Status        varchar(20) NOT NULL,
    ErrorMessage  varchar(4000) NULL
);
GO
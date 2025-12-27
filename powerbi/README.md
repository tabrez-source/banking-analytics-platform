\## Power BI Dashboard



This folder contains screenshots and documentation for the Power BI report

built on top of the Banking Analytics Data Warehouse.



\### Why PBIX is not included

The PBIX file is intentionally excluded due to its large size (~1.16 GB),

which exceeds GitHub limits. In enterprise environments, PBIX files are

stored in Power BI Service or SharePoint, not in source control.



\### Data Source

\- SQL Server Data Warehouse

\- Star schema design



\### Core Tables

\- FactTransactions

\- DimAccount

\- DimAccount\_Destination

\- DimTransactionType

\- DimDate



\### KPIs

\- Total Transactions

\- Total Transaction Amount

\- Fraud Transactions

\- Fraud Rate %



\### Rebuild Instructions

1\. Open Power BI Desktop

2\. Connect to SQL Server

3\. Select DW tables

4\. Recreate visuals using provided measures




\# Banking Analytics Platform



\## Overview

This project is an end-to-end \*\*Banking Analytics Platform\*\* built using SQL Server and Power BI.

It demonstrates real-world data engineering, OLTP modeling, data warehousing, and BI reporting concepts.



\## Architecture

The solution is designed using a \*\*3-layer architecture\*\*:



\- \*\*Staging Layer\*\*  

&nbsp; Raw data ingestion using BULK INSERT with minimal constraints.



\- \*\*OLTP Layer\*\*  

&nbsp; Clean, normalized relational model with primary keys, foreign keys, and data quality rules.



\- \*\*Data Warehouse (OLAP) Layer\*\*  

&nbsp; Star schema optimized for analytical queries and Power BI dashboards.



\## Dataset

\- Source: Kaggle – Synthetic Financial Transactions Dataset

\- Size: ~6.3 million transactions

\- Domain: Retail banking \& fraud analytics



> Note: Raw datasets are not included in this repository due to GitHub file size limits.

> Instructions to download and load the dataset are provided in `data/README.md`.



\## Technologies Used

\- SQL Server

\- T-SQL (DDL, DML, Constraints, Indexes)

\- Power BI

\- Git \& GitHub



\## Key Features

\- BULK INSERT–based ETL pipeline

\- Data validation using CHECK constraints

\- Reject table for invalid records

\- Normalized OLTP schema

\- Indexing for performance at scale

\- Star schema for analytics



\## Project Status

\- Folder structure: ✅ Completed

\- Staging \& OLTP scripts: 🚧 In progress

\- Data Warehouse: 🚧 Planned

\- Power BI Dashboards: 🚧 Planned




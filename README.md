# Banking Analytics Platform

## Overview
This repository contains an end-to-end **Banking Analytics Platform** built using **SQL Server and Power BI**.

The project demonstrates how large-scale financial transaction data can be ingested, validated, modeled, transformed, and prepared for analytical reporting using a layered enterprise-style data architecture.

The primary focus of this project is **data engineering, OLTP schema design, data quality enforcement, data warehousing, reporting readiness, and operational maintenance**, following patterns commonly used in real-world enterprise environments.

---

## Architecture Overview
The platform follows a layered architecture to ensure scalability, data quality, performance, and separation of concerns.

A visual architecture diagram is available in the repository: architecture/architecture-overview.png


---

## Data Source
- Large-scale CSV dataset representing banking transactions  
- Approximately **6.3 million records**  
- Includes transaction behavior and fraud indicators  
- Simulates real-world financial and fraud-related scenarios  

---

## Staging Layer (SQL Server)
The staging layer is responsible for raw data ingestion.

**Key characteristics:**
- High-volume ingestion using `BULK INSERT`
- Minimal constraints to maximize load performance
- Handles encoding issues and malformed rows
- Acts as a landing zone for all incoming data
- Preserves source data for auditing and reprocessing

---

## ETL Layer (T-SQL)
The ETL layer enforces data quality and business rules before data reaches the OLTP layer.

**Responsibilities:**
- Data type validation using `TRY_CONVERT`
- Business rule enforcement
- Identification and logging of rejected records
- Ensures only clean and validated data progresses downstream

---

## OLTP Layer (SQL Server)
The OLTP layer stores validated transactional data and enforces strict data integrity.

**Key features:**
- Fully normalized schema
- Surrogate primary keys
- Foreign key relationships for referential integrity
- CHECK constraints (e.g. positive transaction amounts)
- Indexes on frequently accessed columns
- Dedicated rejected transactions table for audit and troubleshooting

---

## Data Warehouse Layer (SQL Server)
The data warehouse is designed for analytical reporting and BI consumption.

**Design and capabilities:**
- Star schema implementation
  - FactTransactions
  - DimAccount
  - DimDate
  - DimTransactionType
- Surrogate keys for all dimensions
- Automated DW refresh via stored procedures
- ETL audit logging using `DW_Load_Audit`
- Reporting views providing a stable semantic layer
- Parameterized reporting stored procedures for controlled access

---

## Reporting and BI Layer (Power BI)
Power BI is used for analytical reporting and visualization.

**Features:**
- Fraud analysis dashboards
- Transaction trends and volume analysis
- Business-friendly reporting model built on DW views
- Reduced model complexity by consuming curated views

**Notes:**
- Power BI `.pbix` files are excluded due to file size constraints
- Dashboard screenshots are included in the repository
- Dashboards can be fully recreated using documented DW views

---

## Database Layers Summary

**Staging Database**
- Raw data ingestion
- High tolerance for malformed data
- Minimal constraints

**OLTP Database**
- Clean and validated transactional data
- Strong data integrity and business rule enforcement

**Data Warehouse**
- Analytics-optimized star schema
- Reporting views and stored procedures
- ETL and maintenance audit logging

---

## Data Quality Handling
Data quality is enforced at multiple stages:
- Invalid numeric values filtered using `TRY_CONVERT`
- Transactions with invalid or non-positive amounts rejected
- Rejected records logged with timestamps and rejection reasons
- OLTP and DW layers remain clean and consistent

---

## Maintenance and Operations
The platform includes enterprise-style maintenance automation:
- Index fragmentation analysis
- Index rebuild and reorganize based on thresholds
- Statistics updates after large ETL loads
- Maintenance execution logged using the audit framework

---

## Technologies Used
- Microsoft SQL Server
- T-SQL (DDL, DML, constraints, indexing, stored procedures)
- Power BI
- Git and GitHub
- draw.io (architecture diagrams)

---

## Repository Structure
banking-analytics-platform/
├── architecture/
├── staging/
├── oltp/
├── dw/
├── maintenance/
├── powerbi/
├── docs/
├── data/
├── .gitignore
└── README.md


---

## Dataset Information
- Public synthetic banking transaction dataset
- Approximately **6.3 million rows**
- Domain: financial transactions and fraud detection

Raw dataset files are excluded due to GitHub file size limits.  
Instructions to obtain and load the dataset are provided in `data/README.md`.

---

## Project Status
- Staging layer: Completed
- OLTP layer: Completed
- Data warehouse: Completed
- Reporting views and stored procedures: Completed
- Maintenance automation: Completed
- Power BI dashboards: Completed
- Documentation: Completed

---

## Purpose of This Project
This project is designed to demonstrate:
- Real-world data ingestion patterns
- OLTP and data warehouse schema design
- Data validation and rejection handling
- Enterprise ETL orchestration and auditing
- Analytics-ready data modeling
- BI-friendly reporting layers



# Interview Explanation – Banking Analytics Platform

## 1. Project Objective
The goal of this project was to design and implement an end-to-end banking analytics platform that demonstrates real-world data engineering and BI principles using SQL Server.

The project focuses on:
- Handling large-scale transactional data
- Enforcing data quality and integrity
- Designing a clean OLTP system
- Preparing data for analytics and reporting
- Following enterprise-style architecture and version control practices

---

## 2. Why a Layered Architecture Was Used
A layered architecture was chosen to clearly separate responsibilities and ensure scalability, maintainability, and data quality.

Each layer serves a specific purpose:
- Staging handles raw ingestion
- ETL enforces rules and transformations
- OLTP ensures transactional integrity
- Data Warehouse (planned) supports analytics
- Power BI (planned) provides business insights

This approach mirrors how data platforms are built in real organizations.

---

## 3. Staging Layer Design
### Purpose
The staging database acts as a landing zone for raw data.

### Key Design Decisions
- All columns are stored as VARCHAR
- No constraints or relationships are enforced
- High tolerance for malformed or unexpected data

### Reasoning
In real-world systems, rejecting data at the ingestion stage can lead to data loss. By keeping staging flexible, raw data is preserved for reprocessing, auditing, and troubleshooting.

### Techniques Used
- BULK INSERT for high-volume ingestion
- UTF-8 encoding handling
- Error logging using MAXERRORS and ERRORFILE

---

## 4. ETL and Data Validation Strategy
The ETL logic is implemented using T-SQL scripts.

### Validation Techniques
- TRY_CONVERT is used to safely convert data types
- Business rules are applied during transformation
- Invalid records are filtered out before reaching OLTP

### Reject Handling
- Invalid records are written to a dedicated `Rejected_Transactions` table
- Each rejected record includes a rejection reason and timestamp
- This allows auditability without polluting core transactional tables

This pattern ensures OLTP integrity while maintaining visibility into data quality issues.

---

## 5. OLTP Schema Design
### Core Tables
- Accounts
- TransactionTypes
- Transactions

### Key Features
- Surrogate primary keys for performance and stability
- Foreign keys for referential integrity
- CHECK constraints to enforce business rules (e.g., positive transaction amounts)
- Indexes on frequently queried columns

### Reasoning
The OLTP schema is fully normalized to reduce redundancy and ensure consistency. Constraints are enforced at the database level to prevent invalid data from entering the system.

---

## 6. Performance Considerations
Performance was considered at multiple levels:
- BULK INSERT used for fast ingestion
- Indexes added on lookup and filter columns
- Separation of staging and OLTP to reduce locking and contention

This design allows the system to scale with large transaction volumes.

---

## 7. Why Rejected Records Are Stored Separately
Rejected records are not discarded. Instead, they are stored in a dedicated table.

Benefits:
- OLTP tables remain clean and reliable
- Data quality issues can be analyzed separately
- Business and technical teams can review rejection patterns

This approach is commonly used in enterprise data platforms.

---

## 8. Data Warehouse (Planned)
The next phase of the project introduces a Data Warehouse layer.

Planned features:
- Star schema design
- FactTransactions table
- Dimension tables for Accounts and Transaction Types
- Optimized for analytical queries

This layer will decouple analytics from transactional workloads.

---

## 9. Power BI Integration (Planned)
Power BI will consume the Data Warehouse layer to create:
- Fraud analysis dashboards
- Transaction volume trends
- Account behavior insights

The warehouse-first approach ensures consistent and performant reporting.

---

## 10. Version Control and Project Organization
The project follows best practices for Git and GitHub:
- Clear folder structure by layer
- Meaningful, incremental commits
- No raw data committed
- Documentation included for architecture and decisions

This reflects how data engineering projects are managed in professional environments.

---

## 11. How to Explain This Project in an Interview
A concise explanation:

“I built an end-to-end banking analytics platform where raw transactional data is ingested into a staging layer, validated and transformed using T-SQL, and loaded into a normalized OLTP system with strong data integrity rules. Invalid data is captured separately for audit purposes. The architecture is designed to support a downstream data warehouse and Power BI reporting.”

---

## 12. Key Skills Demonstrated
- SQL Server and T-SQL
- ETL pipeline design
- OLTP data modeling
- Data quality enforcement
- Performance optimization
- Enterprise-style architecture
- Git and documentation discipline


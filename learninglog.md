# Learning Log: Bank Financial Analysis & Econometrics (`bank_fa`)

## Project Overview
- **Project Name:** Bank Financial Analysis (`bank_fa`)
- **Dataset:** Panel dataset of banks (2019–2024) containing bank-specific indicators (ROA, ROE, NPL, CAR, Size, CostToIncome, LDR) and macroeconomic controls (GDP Growth, Inflation).
- **Core Objectives:**
  - Exploratory data analysis (EDA) and summary statistics of bank performance.
  - Financial ratio and risk analysis (credit risk, profitability, liquidity, capitalization).
  - Econometric panel modeling (Pooled OLS, Fixed Effects, Random Effects) or Factor Analysis.

---

## Log Template

Use this template for each study or analysis session:

```markdown
### [YYYY-MM-DD] - Session Title / Milestone
- **Focus Area:** (e.g., Data Cleaning, Exploratory Analysis, Panel Regression)
- **What was done:**
  - 
- **Key Concepts Learned:**
  - 
- **Findings / Insights:**
  - 
- **Challenges & Solutions:**
  - 
- **Next Steps:**
  - 
```

---

## Log Entries

## Oct 31, 2026
- Set up R project `bank_fa` with data/, scripts/, output/ folders.
- Loaded bank panel CSV (22 banks x 6 years, 132 rows, no missing values).
- Learned: panel data = same entities observed over time; plm needs to know the entity (bank_id) and time (year) columns.

---

## Variable Reference Guide

| Variable | Type | Description | Interpretation |
| :--- | :--- | :--- | :--- |
| `bank_id` / `bank_name` | Identifier | Bank ticker / Legal name | Entity identifier |
| `year` | Time | Fiscal Year (2019–2024) | Time dimension in panel |
| `ROA` | Bank-level | Return on Assets (%) | Profitability & asset efficiency |
| `ROE` | Bank-level | Return on Equity (%) | Profitability to shareholders |
| `NPL` | Bank-level | Non-Performing Loan ratio (%) | Asset quality & credit risk |
| `CAR` | Bank-level | Capital Adequacy Ratio (%) | Regulatory capital & solvency |
| `Size` | Bank-level | Log of Total Assets | Scale / Size control |
| `CostToIncome` | Bank-level | Cost-to-Income ratio (%) | Operational efficiency |
| `LDR` | Bank-level | Loan-to-Deposit Ratio (%) | Liquidity position |
| `GDP_Growth` | Macroeconomic | Annual GDP Growth Rate (%) | Economic cycle control |
| `Inflation` | Macroeconomic | Annual Inflation Rate (%) | Price level / monetary conditions |

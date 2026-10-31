# Commercial Bank Financial Performance in Bangladesh: Panel Data Analysis (`bank_fa`)

An econometric panel data analysis and financial performance study of commercial banks in Bangladesh using R (`tidyverse`, `plm`, `sandwich`, `lmtest`).

---

## 1. Problem Statement & Research Objectives
This study investigates the financial determinants of bank performance, credit risk, solvency, and stability across commercial banks in Bangladesh using panel econometric techniques (Pooled OLS, Fixed Effects, and Random Effects).

Key areas of investigation:
- Determinants of profitability (`roa`, `roe`)
- Credit risk and asset quality dynamics (`npl_ratio_pct`)
- Capital adequacy and regulatory buffers (`car_crar_pct`, `car_surplus`)
- Bank size, efficiency, and solvency risk metrics (`size_ln_assets`, `zscore`, `ln_zscore`)

---

## 2. Dataset Overview

- **Data File:** [`data/processed_BD_Banks_features_final.csv`](data/processed_BD_Banks_features_final.csv)
- **Source Platform:** Mendeley Data

### Key Variables

| Variable | Description |
| :--- | :--- |
| `bank` | Full legal name of the commercial bank |
| `year` | Fiscal observation year |
| `basis` / `unit` | Reporting basis (solo/consolidated) and currency unit (BDT million) |
| `total_assets`, `total_loans`, `deposits`, `equity`, `net_income` | Balance sheet and income statement items |
| `npl_ratio_pct` | Non-Performing Loan ratio (%) |
| `car_crar_pct` | Capital Adequacy / CRAR (%) |
| `roa` | Return on Assets (%) |
| `roe` | Return on Equity (%) |
| `ldr` | Loan-to-Deposit Ratio (%) |
| `size_ln_assets` | Natural log of total assets |
| `zscore` / `ln_zscore` | Bank stability and insolvency risk index |

---

## 3. Data Sources

- Mendeley Data: https://data.mendeley.com/datasets/x67kms4wz5/2

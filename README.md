# Commercial Bank Financial Performance in Bangladesh: Panel Data Analysis 

This project is an econometric panel data study of commercial banks in Bangladesh, built in R using `tidyverse`, `plm`, `sandwich`, `lmtest`, and `car`. 

I started this project to rebuild and expand my university thesis analysis in R, moving from my original manual 22-bank sample to a larger, publicly verifiable dataset.

---

## 1. Problem Statement
Banks in Bangladesh have faced severe asset quality challenges over the last decade, with rising non-performing loans (NPLs) and regulatory pressure on capital adequacy. 

The main research questions are:
- How much do bad loans (NPLs) actually drag down bank profitability (measured by Return on Assets, ROA)?
- Do higher capital buffers (CAR) and aggressive lending (Loan-to-Deposit Ratio, LDR) make banks more profitable, or do they just separate safe banks from risky ones?
- Does bank size give an institution an advantage in profitability once we account for bank-specific and year-to-year industry shocks?

---

## 2. Dataset Overview
- **Source**: "A comprehensive panel dataset of Bangladeshi banks (1997-2025)", Yeasmin, Mendeley Data, CC BY 4.0.
- **Raw Data**: 780 observations across 57 commercial banks from 1997 to 2025.
- **Cleaning & Filtering**:
  - Sample restricted to **2013–2025** (670 bank-year rows) because reporting was too sparse before 2013.
  - Dropped Citizens Bank PLC (2020) because total assets were listed as only 25.5 BDT million (a clear reporting error).
  - Retained Union Bank PLC (2024) to keep real distress dynamics, but treated extreme outliers by **winsorizing** all continuous ratios at the 1st and 99th percentiles.
- **Note on Sample**: I originally planned a 22-bank thesis sample (2019–2024), but upgraded to this 57-bank dataset (2013–2025) because it covers almost the whole banking sector over a 13-year period.

### Variables Used

| Variable | Column | Description |
| :--- | :--- | :--- |
| **Profitability (ROA)** | `roa_w` | Dependent variable: Return on Assets (%) |
| **Credit Risk (NPL)** | `npl_ratio_pct_w` | Non-Performing Loan ratio (%) |
| **Capital Buffer (CAR)** | `car_crar_pct_w` | Capital Adequacy / CRAR (%) |
| **Bank Size** | `size_ln_assets_w` | Natural log of total assets |
| **Liquidity (LDR)** | `ldr_w` | Loan-to-Deposit Ratio (%) |

---

## 3. Econometric Methodology
I followed a step-by-step panel modeling approach:
1. **Pooled OLS**: Stacking all bank-years together as a baseline comparison.
2. **Fixed Effects (Within)**: Giving each bank its own intercept to remove unobserved bank differences (management style, brand reputation, ownership).
3. **Random Effects (GLS)**: Assuming bank differences are random noise uncorrelated with predictors.
4. **Model Selection**:
   - **Chow F-test** ($p < 2.2 \times 10^{-16}$): Confirmed pooled OLS is inadequate.
   - **Breusch-Pagan LM test** ($p < 2.2 \times 10^{-16}$): Confirmed bank-level effects exist.
   - **Hausman test** ($p = 0.00067$): Decisively rejected Random Effects in favor of **Fixed Effects**.
5. **Diagnostics & Robust SEs**:
   - VIF was checked (all $< 1.70$, so no multicollinearity problems).
   - Breusch-Pagan test showed unequal error variance ($p < 2.2 \times 10^{-16}$).
   - Wooldridge test showed serial correlation within banks ($p = 2.8 \times 10^{-12}$).
   - Because of both issues, I report the final Fixed Effects model with **cluster-robust standard errors** (clustered by bank using the sandwich estimator).

---

## 4. Empirical Results
- **Bad loans are the biggest enemy of profitability**: In the Fixed Effects model, NPL is negative and stays statistically significant even after clustering ($t = -4.23, p = 0.00003$). An increase of 1 percentage point in bad loans reduces ROA by about **0.044 percentage points**.
- **Capital and liquidity matter across banks, not within banks**: In Pooled OLS, CAR and LDR had positive and significant coefficients. But in Fixed Effects, they lose significance ($p > 0.60$). This means that banks with higher capital and loan ratios are generally more profitable than weaker banks, but for any single bank, moving its CAR or LDR in a single year doesn't reliably move its ROA.
- **Bank size**: Size is not statistically significant in one-way Fixed Effects, but when two-way year effects are added, size becomes positive and significant, suggesting mild economies of scale once macro shocks are controlled.

---

## 5. Limitations
- **Association, not causation**: Static fixed effects shows correlations, but doesn't solve potential two-way causality (low profits might cause higher defaults just as higher defaults cause low profits).
- **Missing macroeconomic factors**: The Mendeley dataset has balance sheet numbers, but no GDP growth, inflation, or policy interest rate caps. Year fixed effects absorb some of this, but country-level variables would be better.
- **Unbalanced panel**: Banks have between 5 and 13 years of observations, so cluster-robust standard errors rely on asymptotic approximations.

---

## 6. Business & Policy Recommendations
1. **Focus on Loan Recovery over Asset Growth**: Because NPL has such a direct negative hit on ROA, banks shouldn't try to grow their way out of trouble just by issuing more loans. Recovering non-performing assets and setting strict credit underwriting criteria will protect profitability far better than expanding the loan book.
2. **Early Provisioning**: Regulators (Bangladesh Bank) should enforce timely loan-loss provisioning so hidden bad loans do not suddenly wipe out equity in distress years (as seen with Union Bank in 2024).
3. **Capital as a Safety Net, Not a Profit Engine**: Maintaining high CAR is essential for solvency and regulatory compliance, but bank managers shouldn't expect capital injections alone to immediately turn around an unprofitable bank without fixing bad loan recovery.

---

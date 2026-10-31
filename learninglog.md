# LEARNING LOG

### Oct 31, 2026: Step 1: Load data and declare panel
- Set up the RStudio project `bank_fa` with folders data/, scripts/, output/.
- Installed and loaded tidyverse and plm.
- Panel data = the same entities (banks) observed over several years.
  plm needs the entity column (bank) and time column (year).
- A panel can be balanced or unbalanced; plm handles both.
- `<-` stores a result; `|>` means "and then".
- glimpse(), names(), colSums(is.na()), and pdim() are my first checks
  for any new dataset.
- roe, net_income, zscore and ln_zscore are tied to ROA, so they should
  not be used to explain ROA.
# The Super Simple Guide to the Bank Detective Project (`bank_fa`)
### *How we investigated 57 banks in Bangladesh using computers, math, and detective work — explained for an 8-year-old!*

---

# Welcome, Junior Detective! 🕵️‍♂️
Have you ever wondered what happens when grown-ups put their money inside a big bank? Or why some banks become super rich while other banks lose all their pocket money and get into big trouble?

In this project, called **`bank_fa`** (which stands for *Bank Financial Analysis*), we acted like financial detectives! We took a giant notebook of information about **57 commercial banks in Bangladesh**, put it into a coding program called **R**, and solved the mystery of:
> **"What actually makes a bank healthy and profitable, and what is the monster that destroys them?"**

This guide explains **every single thing we did, step by step, word by word**, in a way that anyone can understand!

---

# Chapter 1: The Magic of Banks (How Banks Work)

Before we look at the computer code, let's understand how a bank works using a simple story:

### 1. The Piggy Bank (Deposits) 🏦
Imagine you have \$10 of birthday money. You don't want to lose it in your bedroom, so you give it to a bank. The bank says: *"Don't worry, we'll keep your \$10 safe in our big vault, and whenever you want it back, you can ask for it."* That money is called a **Deposit**.

### 2. The Lending Tree (Loans) 🌳
Now, imagine a baker walks into the bank. She says: *"I want to bake 500 delicious chocolate cakes, but I need \$10 to buy flour and sugar. Can I borrow \$10?"*
The bank says: *"Yes! But next month, you must pay us back \$11 (the \$10 you borrowed, plus \$1 extra for letting you borrow it)."* That \$1 extra is called **Interest**.

### 3. The Bank's Lunch Money (Profit and ROA) 🥪
- If the baker pays back \$11, the bank gives you your \$10 back, and keeps the \$1 profit!
- In our project, we measure this using something called **ROA** (*Return on Assets*). 
- **ROA is simple**: If a bank has \$100 worth of stuff (buildings, vaults, cash), how many coins of pure profit does it make every year? A normal bank usually makes about **70 cents** for every \$100 (which is an ROA of 0.70%).

### 4. The Monster: Bad Loans (NPL) 👹
What happens if the baker drops all the flour in the mud, eats all the cakes, and runs away without paying the bank back? 
- That borrowed money is **lost**!
- In banking, this is called an **NPL** (*Non-Performing Loan*, or a "Bad Loan").
- When loans go bad, the bank has to take money out of its own pocket to make up for the loss. This hurts the bank's profit badly!

### 5. The Safety Pillow: Capital Cushion (CAR) 🛡️
Central banks (the "principal of all banks") tell every bank: *"You must always keep a safety pillow of your own cash in case borrowers don't pay you back!"* 
- This cushion is called **CAR** (*Capital Adequacy Ratio*). 
- If a bank has a thick safety pillow (like 12% or 15%), it can survive a few bad borrowers without going broke.

### 6. Small Kids vs. Big Kids (Bank Size) 🐘
Some banks are giant elephants with branches in every town. Other banks are small mice with just a few offices. We measure bank size by taking the natural logarithm of all their assets (`size_ln_assets`).

### 7. How Eager is the Bank to Lend? (LDR) 🚀
The **Loan-to-Deposit Ratio (LDR)** tells us: for every \$100 people gave the bank to keep safe, how much did the bank lend out to borrowers? If they lent out \$85, the LDR is 85%.

---

# Chapter 2: The Magic Notebook (What is Panel Data?)

Imagine you have **57 friends** in school.
- If you only weigh your 57 friends once in the 3rd grade, that is called a **cross-section** (just one picture in time).
- But what if you weigh all 57 friends **every year from Grade 1 all the way to Grade 13**?
- That is called **PANEL DATA**! 

Panel data is awesome because you can see:
1. Are some friends taller than others? (*Between-friend differences*)
2. Did a friend grow taller this year compared to last year? (*Within-friend changes*)

In our project, we followed **57 Bangladeshi banks** across **13 years (from 2013 to 2025)**! That gave us **670 bank-year reports** to investigate.

---

# Chapter 3: Step 1 – Loading and Inspecting the Data
*(File: `scripts/load_inspect.R`)*

Before doing any math, a good detective opens the case file and checks if anything is torn or missing.

### What we did in this step:
1. **Loaded the tools**: We loaded two software toolkits in R:
   - `tidyverse`: Helps us slice, filter, and draw charts.
   - `plm`: The special tool for analyzing panel data.
2. **Read the raw CSV file**: We imported `processed_BD_Banks_features_final.csv` (780 total rows from 1997 to 2025).
3. **Fixed data types**: We made sure the computer knew that `bank` is a name/category (factor) and `year` is a whole counting number (integer).
4. **Checked for missing pieces (`is.na`)**: We asked the computer: *"Are there any blanks or missing numbers?"* The answer was **0**! Every single number was filled in.
5. **Checked for twin clones (`duplicated`)**: We asked: *"Did any bank report twice in the same year?"* The answer was **0**! No duplicates.
6. **Counted the years**: We counted how many banks reported each year. We noticed something big:
   - Between 1997 and 2012, very few banks reported data (sometimes only 1 or 5 banks).
   - But from **2013 to 2025**, almost all 57 banks reported every year! That told us the most reliable years to study are 2013 to 2025.

---

# Chapter 4: Step 2 – Cleaning the Mess and Drawing Pictures
*(File: `scripts/explore_data.R`)*

Sometimes datasets have silly typing mistakes or crazy numbers. If you don't clean them up, your math will get tricked!

### 1. The Math Check (Sanity Check)
We checked if Return on Assets really equals:
$$\frac{\text{Net Income}}{\text{Total Assets}} \times 100$$
It matched 100%! Because net income is used to calculate ROA, we wrote down a golden rule: **Never use net income to predict ROA** (that would be like saying "a cake is sweet because it contains sugar that makes it sweet").

### 2. Spotting the Aliens (Outliers)
We sorted all banks from the worst loss to the best profit. Two banks looked crazy:

* **Alien #1: Citizens Bank PLC in 2020** 🛸
  - It reported an ROA of **-79.6%**, but its total assets were listed as only **25.5 million BDT**! 
  - To understand how tiny 25.5 is: normal banks have 200,000 million! A bank with 25.5 is like a lemonade stand pretending to be a giant bank. It was clearly a typing mistake in the original data, so **we dropped it!**
  
* **Alien #2: Union Bank PLC in 2024** 💥
  - It reported an ROA of **-87.2%**, but its assets were **299,820 million BDT** (a huge real bank!).
  - In 2024, Bangladesh had a major banking crisis where Union Bank really did suffer a gigantic loss.
  - We did **NOT** want to delete it because it was a real historical event. But if you leave a number like -87% in a regression, it will bend the math ruler like a boomerang!

### 3. The Haircut Trick (Winsorizing) ✂️
To solve this, we used a smart trick called **Winsorization at the 1st and 99th percentiles**:
- Imagine you line up 100 runners by speed. 
- If one runner rides a rocket ship and finishes in 0.1 seconds, you don't throw him out of the race; you just say: *"Your recorded speed will be capped at the speed of the 99th fastest runner."*
- For our banks: any ROA lower than -5.78% was set to **-5.78%**. 
- Union Bank is still shown as suffering a massive loss, but it no longer breaks our math!

### 4. Drawing Pictures (Charts)
We drew two important pictures:
1. **The Profit Timeline (`median_roa_by_year.png`)**:
   - Showed that Bangladeshi banks were doing okay (around 0.7% to 0.8% ROA) until 2022, but then profits took a giant downward slide in 2023 and 2024!
2. **The Slippery Slide (`roa_vs_npl.png`)**:
   - A scatterplot comparing Bad Loans (NPL) on the bottom against Profit (ROA) on the side.
   - The red trendline goes straight down! The more bad loans a bank has, the lower its profit.

### 5. Packing the Clean Lunchbox
We saved this clean, winsorized 2013–2025 dataset (670 rows, 57 banks) to `data/dfm_2013_2025.rds`.

---

# Chapter 5: Step 3 – The Three Math Machines
*(File: `scripts/data_modeling.R`)*

Now comes the fun part: running **regressions**! 

A regression is like asking a magic math formula:
> *"If Bad Loans go up by 1 point, how many points does Bank Profit go down?"*

Our recipe formula was:
$$\text{Profit (ROA)} \sim \text{Bad Loans (NPL)} + \text{Capital Cushion (CAR)} + \text{Bank Size} + \text{Lending (LDR)}$$

We tried three different math machines:

### Machine 1: Pooled OLS (The Blender) 🥤
- **How it thinks**: It tosses all 670 reports into a giant blender, pretending all 57 banks are identical strangers.
- **What it found**:
  - Bad loans (NPL) hurt profits ($\hat{\beta} = -0.0475$, super significant!).
  - Capital (CAR) helps profits ($\hat{\beta} = +0.0103$).
  - Lending more (LDR) helps profits ($\hat{\beta} = +0.0024$).
- **The flaw**: It ignores that Sonali Bank is not the same as BRAC Bank! Some banks have better managers and better reputations that never change.

### Machine 2: Fixed Effects (The Personal Mirror) 🪞
- **How it thinks**: It looks at **each bank individually** and subtracts the bank's own average. It asks: *"When THIS specific bank gets more bad loans this year compared to its normal self, what happens to its profit?"*
- **What it found**:
  - **Bad loans (NPL)** is still strongly negative ($\hat{\beta} = -0.0443$, $p < 0.0000000000000002$!). When bad loans go up by 1%, ROA drops by about 0.044%.
  - **CAR, Size, and LDR became totally insignificant ($p > 0.60$)!**

> **🤔 The Big Mystery: Why did Capital (CAR) stop being significant in Fixed Effects?**
> Imagine this: Kids who study hard tend to have clean desks and get high grades.
> If you look across the whole school (Pooled OLS), a clean desk looks like it causes good grades!
> But if one student cleans her desk on Tuesday, does she magically get 100% on her math test on Wednesday? No!
> In banking: Well-run banks generally have both good capital cushions AND good profits. But for any single bank, just tweaking its capital ratio this year doesn't magically create profits. **Bad loans are the real thing that destroys profits!**

### Machine 3: Random Effects (The Lucky Guess) 🎲
- **How it thinks**: It assumes bank differences are just random luck drawn from a hat.
- **What it found**: It calculated that **58.3% of the variation in bank profits comes from permanent differences between banks**, not random year-to-year noise!

---

# Chapter 6: Step 4 – The Grand Detective Contest (Which Model Wins?)

We had three models. Which one should we crown as the champion? We ran three referee tests:

1. **The Chow F-Test (Pooled OLS vs. Fixed Effects)**
   - *Question*: Are all banks identical?
   - *Answer*: $p < 0.0000000000000002$. **NO!** Banks are completely different. Pooled OLS is defeated!
2. **The Breusch-Pagan LM Test (Pooled OLS vs. Random Effects)**
   - *Question*: Do bank differences matter?
   - *Answer*: $p < 0.0000000000000002$. **YES!** Simple pooling is rejected again.
3. **The Hausman Test (Fixed Effects vs. Random Effects)**
   - *Question*: Is Random Effects honest, or is it biased?
   - *Answer*: $p = 0.00067$ (less than 0.05). **Random Effects is biased!**
   - 🏆 **Winner**: **Fixed Effects (Within Model) wins the gold medal!**

---

# Chapter 7: Step 5 – Checking if our Math Ruler is Bent (Diagnostics)

Before a scientist tells the world they found the truth, they must check if their instruments are broken. In Step 4 of our learning log, we ran three diagnostic checks:

### Trap 1: The Parrot Check (Multicollinearity / VIF) 🦜
- *What is it?* If you ask two friends what happened, and one friend just repeats every word the other says, you don't have two witnesses; you have one parrot!
- *Test*: Variance Inflation Factor (VIF).
- *Result*: All scores were between **1.0 and 1.7** (anything under 5.0 is great). No parrots here!

### Trap 2: The Whispering Mouse & The Roaring Lion (Heteroskedasticity) 🦁
- *What is it?* Do small banks have tiny random errors, while giant banks have massive wild errors?
- *Test*: Breusch-Pagan test.
- *Result*: $p < 0.0000000000000002$. The errors have unequal spread!

### Trap 3: The Yesterday's Hiccups (Autocorrelation) 🗣️
- *What is it?* If a bank has trouble in 2020, does that trouble carry over into 2021?
- *Test*: Wooldridge serial correlation test.
- *Result*: $p = 0.0000000000028$. Yes, bank problems linger from year to year!

### 👓 The Solution: Cluster-Robust Standard Errors
Because our data had unequal spread (Trap 2) and lingering hiccups (Trap 3), regular textbook standard errors were **too small** (they made our results look unrealistically over-confident).

So we put on **Cluster-Robust Goggles** (clustering standard errors by bank using the `sandwich` and `lmtest` packages):
- **What happened to the slope?** It did **NOT** change! It stayed **-0.0443**.
- **What happened to the standard error?** It grew from **0.0036** to **0.0105** (almost 3 times bigger!).
- **Did NPL survive?** YES! Even with the bigger error bar, the $t$-value was $-4.23$ and the $p$-value was **0.00003**!

> **🎓 Big Lesson**: Correcting standard errors doesn't change your estimate of reality; it just makes you an honest scientist who reports true uncertainty!

---

# Chapter 8: The Grand Summary Table

Here is the final scoreboard that shows all our models side-by-side:

| Variable | Pooled OLS | Fixed Effects | FE with Robust Goggles | Random Effects |
| :--- | :---: | :---: | :---: | :---: |
| **Bad Loans (NPL)** | **-0.048\*\*\*** | **-0.044\*\*\*** | **-0.044\*\*\*** | **-0.047\*\*\*** |
| *(How certain we are)* | *(0.003)* | *(0.004)* | *(0.010)* | *(0.003)* |
| **Capital Cushion (CAR)** | +0.010\*\*\* | +0.001 | +0.001 | +0.003 |
| **Bank Size** | -0.013 | -0.012 | -0.012 | +0.017 |
| **Lending Ratio (LDR)** | +0.002\*\*\* | -0.000 | -0.000 | +0.000 |
| **Observations** | 670 | 670 | 670 | 670 |
| **Banks** | 57 | 57 | 57 | 57 |

*\*\*\* means super statistically significant ($p < 0.001$).*

---

# Chapter 9: What Did We Learn? (The Big Takeaway)

If an 8-year-old child had to give advice to the Governor of the Central Bank of Bangladesh, here is what they would say based on our data:

1. **Bad loans are the #1 enemy of banks**:
   Every time bad loans rise by 1%, bank profits drop by 0.044%. When borrowers don't pay back loans, banks have to use their own piggy banks to cover the loss.
2. **You can't grow your way out of trouble**:
   Lending more money without checking if borrowers are honest doesn't fix a bank. It just creates bigger bad loans later.
3. **Capital cushions are safety nets, not magic wands**:
   Having high capital makes a bank safe, but giving an unprofitable bank a bag of cash won't make it profitable unless it learns how to collect its bad loans!

---

# Chapter 10: Where are all the Project Files?

Everything we built lives right here in the project folder:

```
bank_fa/
├── data/
│   ├── processed_BD_Banks_features_final.csv   # The raw 780-row case file
│   └── dfm_2013_2025.rds                       # The clean 670-row lunchbox
├── scripts/
│   ├── load_inspect.R                          # Step 1: Open the case file
│   ├── explore_data.R                          # Step 2: Clean aliens & draw pictures
│   └── data_modeling.R                         # Step 3: Run the 3 math machines
├── output/
│   ├── median_roa_by_year.png                  # Chart showing profit drop after 2022
│   └── roa_vs_npl.png                          # Chart showing bad loans hurt profit
├── analysis.Rmd                                # The complete scientific report (source)
├── analysis.md                                 # The rendered readable report
├── learninglog.md                              # The dated diary of what worked & what failed
├── README.md                                   # The formal project presentation
└── Guide.md                                    # This super friendly guide!
```

**And that is how we solved the Bank Detective Mystery! 🎉**

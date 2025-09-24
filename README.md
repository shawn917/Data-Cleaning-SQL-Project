# SQL Data Cleaning – World Layoffs Dataset

This project demonstrates how I used SQL to clean and prepare a dataset on world layoffs for further analysis.  
The dataset includes company details, industry, location, funding, and layoff counts.  
The goal was to transform raw, messy data into a clean and reliable format.

---

## Objectives
- Identify and remove duplicate records
- Standardize inconsistent values (company, industry, country)
- Convert dates into the correct format
- Handle missing or blank values
- Deliver a cleaned dataset ready for analysis or visualization

---

## Cleaning Process

### 1. Remove Duplicates
- Created a staging table to protect raw data.
- Applied `ROW_NUMBER()` with `PARTITION BY` across key fields to detect duplicates.
- Deleted duplicate rows.

### 2. Standardize Data
- Trimmed whitespace from company names.
- Grouped similar industry names (e.g., all variations of *Crypto* → `Crypto`).
- Fixed country names (e.g., removed trailing periods in `United States.`).
- Converted `date` from text (`MM/DD/YYYY`) into proper `DATE`.

### 3. Handle Nulls & Blanks
- Replaced blank industry values with `NULL`.
- Filled missing industry values using self-joins on company and location.
- Removed rows with no layoff information (`total_laid_off` and `percentage_laid_off` both missing).

### 4. Finalize Table
- Dropped helper columns such as `row_number`.
- Ensured only clean, consistent fields remain.

---

## SQL Concepts Applied
- Window functions (`ROW_NUMBER()` with `OVER`)
- Common Table Expressions (CTEs)
- String functions (`TRIM()`, `TRAILING`)
- Date functions (`STR_TO_DATE()`)
- Joins and updates for data filling
- Conditional deletes

---

## File Structure
- `layoffs_cleaning.sql` → Main SQL script with all cleaning steps
- `README.md` → Project documentation

---

## Tools Used
- **Database:** MySQL  
- **Editor:** MySQL Workbench  

---

## Next Steps
With the dataset cleaned, the next phase would be:
- Performing exploratory data analysis (EDA) to uncover layoff trends
- Building visual dashboards to present insights

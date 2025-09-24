/*

Cleaning Data in SQL Queries

*/

SELECT * FROM world_layoffs.layoffs;

-- Removing Duplicates
CREATE TABLE layoffs_staging
LIKE layoffs
;

SELECT *
FROM layoffs_staging
;

INSERT layoffs_staging
SELECT *
FROM layoffs
;

SELECT *,
ROW_NUMBER() OVER( 
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) `row_number`
FROM layoffs_staging
;

WITH duplicate_cte AS (
SELECT *,
ROW_NUMBER() OVER( 
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) `row_number`
FROM layoffs_staging
)

SELECT *
FROM duplicate_cte
WHERE `row_number` > 1
;

SELECT *
FROM layoffs_staging
WHERE company = 'Casper'
ORDER BY `date` DESC
;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_number` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2
;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER( 
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) `row_number`
FROM layoffs_staging
;

SELECT *
FROM layoffs_staging2
WHERE `row_number` > 1
;

SET SQL_SAFE_UPDATES = 0;

DELETE
FROM layoffs_staging2
WHERE `row_number` > 1
;

-- Standardizing Data
SELECT company, TRIM(company)
FROM layoffs_staging2
;

UPDATE layoffs_staging2
SET company = TRIM(company)
;

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1
;

SELECT industry
FROM layoffs_staging2
WHERE industry like 'Crypto%'
;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'
;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1
;

SELECT DISTINCT country, TRIM(country), TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1
;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%'
;

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2
;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y')
;

ALTER TABLE layoffs_staging2
MODIFY `date` DATE
;

-- Removing Null/Blank Values
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL
;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL OR industry = ''
;

SELECT *
FROM layoffs_staging2
WHERE company = `Bally's Interactive`
;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = ''
;

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
 AND t1.location = t2.location
WHERE t1.industry IS NULL
 AND t2.industry IS NOT NULL
 ;
 
 UPDATE layoffs_staging2 t1
 JOIN layoffs_staging2 t2
ON t1.company = t2.company
 AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
 AND t2.industry IS NOT NULL
 ;
 
 -- Removing Unnecessary Columns
 DELETE
 FROM layoffs_staging2
 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL
 ;
 
 ALTER TABLE layoffs_staging2
 DROP `row_number`
 ;
 
 SELECT *
FROM layoffs_staging2
;
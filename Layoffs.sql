-- Active: 1708084604495@@127.0.0.1@3306@world_layoffs
-- Data cleaning.

SELECT *
FROM layoffs;

-- Remove duplicates
-- Standardize data
-- Check for null values
-- Remove any columns if need

-- Removing duplicates

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT * , row_number() 
OVER(
PARTITION BY company ,industry ,total_laid_off,percentage_laid_off,`date`) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS 
(
SELECT * , row_number() 
OVER(
PARTITION BY company ,location, industry ,total_laid_off,percentage_laid_off,`date`,stage ,country,
funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1 ;

SELECT *
FROM layoffs_staging
WHERE company = 'Casper';

WITH duplicate_cte AS 
(
SELECT * , row_number() 
OVER(
PARTITION BY company ,location, industry ,total_laid_off,percentage_laid_off,`date`,stage ,country,
funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE 
FROM duplicate_cte
WHERE row_num > 1 ;

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
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT * , row_number() 
OVER(
PARTITION BY company ,location, industry ,total_laid_off,percentage_laid_off,`date`,stage ,country,
funds_raised_millions) AS row_num
FROM layoffs_staging ;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

DELETE 
FROM layoffs_staging2
WHERE row_num > 1 ;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- Standardizing data ( A check on all columns)
-- 1. company
SELECT DISTINCT(company)
FROM layoffs_staging2;

-- There are whitespaces , removed below

SELECT company , trim(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = trim(company);

SELECT DISTINCT(company)
FROM layoffs_staging2;

-- 2. Industry
SELECT DISTINCT(industry)
FROM layoffs_staging2
ORDER BY 1;

-- There are null and empty rows 
-- There are three separate crypto columns , which need to be concatenated to one.

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

-- 3. Location
SELECT DISTINCT(location)
FROM layoffs_staging2
ORDER BY 1;
-- No issues identified.

-- 4 . Country
SELECT DISTINCT(country)
FROM layoffs_staging2
ORDER BY 1;
-- An issue with United States ( Two instances )
-- Caused by one having a fullstop (period) and one doesn't have

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%'
AND country = 'United States.'
ORDER BY 1;

SELECT DISTINCT(country) , trim(trailing'.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = trim(trailing'.' FROM country)
WHERE country LIKE 'United States%';

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%'
AND country = 'United States.'
ORDER BY 1;

-- 5. Date
SELECT `date`,
STR_TO_DATE(`date` ,'%m/%d/%Y')
FROM layoffs_staging2;

-- Its is in text format rather than date format , Not suitable for any time series analysis
-- Format into mm/dd/yyyy

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date` ,'%m/%d/%Y') ;

SELECT `date`
FROM layoffs_staging2;

-- modify column to date.
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Checking and handling NULL VALUES .
-- check on total_laid_off and percentage_laid_off column.
SELECT *
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL;

-- set blanks to NULL 

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- check on industry column.
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%';

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

-- first row has a null value in industry , this should be filled using same industry value ie travel

UPDATE layoffs_staging2
SET industry ='Travel'
WHERE company = 'Airbnb';

-- Solving the problem for other companies 
SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
   ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND  t2.industry IS NOT NULL;

SELECT t1.industry , t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
   ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND  t2.industry IS NOT NULL;

-- Transportation and consumer industries identified
-- performing update on missing industry values ie transportation and consumer.

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
   ON t1.company = t2.company
SET  t1.industry = t2.industry  
WHERE (t1.industry IS NULL OR t1.industry = ' ')
AND  t2.industry IS NOT NULL;

-- Performing a check on one of the companies.
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

-- check for another industry that has null values
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

-- a review on the layoffs_staging2.
SELECT *
FROM layoffs_staging2;

-- a review on total_laid_off and percentage_laid_off column.
SELECT *
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL;

-- There are some rows where total_laid_off and percentage_laid_off is null.
-- Deleting the rows as they seem to be of no essence.ALTER

DELETE 
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL;

SELECT *
FROM layoffs_staging2;

-- Drop column 'row_num' , its usage is done.
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- Final clean up file.
SELECT *
FROM layoffs_staging2;
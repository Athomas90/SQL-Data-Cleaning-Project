-- Data Cleaning 

SELECT * 
FROM layoffs;

CREATE TABLE layoffs_review
LIKE layoffs;

INSERT layoffs_review
SELECT * FROM layoffs;



-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary 


-- 1. Remove Duplicates

SELECT *
FROM layoffs_review;

WITH duplicate_cte AS (SELECT *,
						ROW_NUMBER() OVER(
						PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date') AS row_num
						FROM layoffs_review)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;


DELETE 
FROM duplicate_cte
WHERE company = 'Oyster';


CREATE TABLE `layoffs_review2` (
`company` text,
`location`text,
`industry`text,
`total_laid_off` INT,
`percentage_laid_off` text,
`date` text,
`stage`text,
`country` text,
`funds_raised_millions` int,
 `row_num`  INT
);

SELECT *
FROM layoffs_review2;

INSERT INTO layoffs_review2
SELECT *,
		ROW_NUMBER() OVER(
		PARTITION BY company,location,industry, total_laid_off, percentage_laid_off, 'date',stage, country, funds_raised_millions) AS row_num
FROM layoffs_review;


DELETE
FROM layoffs_review2
WHERE row_num > 1;

-- 2. standardize data and fix errors

SELECT company, TRIM(company)
FROM layoffs_review2;

UPDATE layoffs_review2
SET company = TRIM(company);

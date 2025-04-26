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

SELECT DISTINCT industry
FROM layoffs_review2
ORDER BY 1;

SELECT *
FROM layoffs_review2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;


UPDATE layoffs_review2
SET industry = 'Travel'
WHERE company = 'Airbnb';

UPDATE layoffs_review2 l1
JOIN layoffs_review2 l2
ON l1.company = l2.company
SET l1.industry = l2.industry
WHERE l1.industry IS NULL
AND l2.industry IS NOT NULL;

SELECT DISTINCT country
FROM layoffs_review2
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING "." FROM country)
FROM layoffs_review2;


UPDATE layoffs_review2
SET country = TRIM(TRAILING "." FROM country);

SELECT *
FROM layoffs_review2;

UPDATE layoffs_review2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_review2
MODIFY COLUMN `date` DATE;

-- 3. Look at Null Values

SELECT *
FROM layoffs_review2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_review2
WHERE industry IS NULL
OR industry = ' ';



SELECT l1.industry, l2.industry
FROM layoffs_review2 l1
JOIN layoffs_review2 l2
	ON l1.company = l2.company
WHERE (l1.industry IS NULL OR l1.industry = ' ')
AND l2.industry IS NOT NULL;

UPDATE layoffs_review2 l1
JOIN layoffs_review2 l2
	ON l1.company = l2.company
SET l1.industry = l2.industry
WHERE l1.industry IS NULL
AND l2.industry IS NOT NULL;

UPDATE layoffs_review2
SET industry = 'Entertainment'
WHERE company = 'Bally''s Interactive';

SELECT *
FROM layoffs_review2;

-- 4. remove any columns and rows that are not necessary 

SELECT *
FROM layoffs_review2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_review2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_review2;

ALTER TABLE layoffs_review2
DROP COLUMN row_num;

SELECT *
FROM layoffs_review2;

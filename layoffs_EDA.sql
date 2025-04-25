USE world_layoffs;

-- EDA

SELECT *
FROM layoffs_review2;

SELECT MAX(total_laid_off) AS max_laid_off
FROM layoffs_review2;

-- Percentage to see how big these layoffs
SELECT MAX(percentage_laid_off) AS max_laid_off_perc, MIN(percentage_laid_off) AS min_laid_off_perc
FROM layoffs_review2
WHERE percentage_laid_off IS NOT NULL;

-- Which companies had 1 which is basically 100 percent of they company laid off

SELECT *
FROM layoffs_review2
WHERE percentage_laid_off = 1;

-- if we order by funcs_raised_millions we can see how big some of these companies were
SELECT *
FROM layoffs_review2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Companies with the biggest single Layoff
SELECT company, total_laid_off
FROM layoffs_review2
ORDER BY 2 DESC
LIMIT 5;

-- Companies with the most Total Layoffs
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM layoffs_review2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

-- by location
SELECT location, SUM(total_laid_off) AS total_laid_off
FROM layoffs_review2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

SELECT industry, SUM(total_laid_off) AS total_laid_off
FROM layoffs_review2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off) AS total_laid_off
FROM layoffs_review2
GROUP BY country
ORDER BY 2 DESC;

SELECT stage, SUM(total_laid_off) AS total_laid_off
FROM layoffs_review2
GROUP BY stage
ORDER BY 2 DESC;

-- companies with the most laid off and per year 
WITH company_year AS
		(SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
		FROM layoffs_review2
		GROUP BY company, YEAR(date)),
        
     company_ranking AS
		(SELECT company, years, total_laid_off,
				DENSE_RANK () OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
		FROM company_year)

SELECT company, years, total_laid_off, ranking
FROM company_ranking
WHERE ranking <= 3
AND total_laid_off IS NOT NULL
ORDER BY years DESC;

-- Rolling Total of Layoffs Per Month

WITH date_cte AS
		(SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
		FROM layoffs_review2
		GROUP BY dates
		ORDER BY dates ASC)
        
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM date_cte
ORDER BY dates ASC;
SELECT * FROM ds_salaries;

-- 1. Apakah ada data yang NULL?
SELECT * 
FROM ds_salaries
WHERE work_year IS NULL
OR experience_level IS NULL
OR employment_type IS NULL 
OR job_title IS NULL
OR salary IS NULL
OR salary_currency IS NULL
OR salary_in_usd IS NULL
OR employee_residence IS NULL
OR remote_ratio IS NULL
OR company_location IS NULL
OR company_size IS NULL;

-- 2. Melihat ada job title apa saja?
SELECT DISTINCT job_title FROM ds_salaries ORDER BY job_title;

-- 3. Melihat job title apa saja yang berkaitan dengan data analyst?
SELECT DISTINCT job_title 
FROM ds_salaries 
WHERE job_title LIKE "%data analyst%"
ORDER BY job_title;

-- 4. Berapa rata-rata gaji data analyst?
SELECT AVG(salary_in_usd) FROM ds_salaries;
-- salary dikonfersi ke rupiah:
SELECT (AVG(salary_in_usd) * 17500) /12 AS avg_sal_RP_monthly FROM ds_salaries;
-- rata-rata gaji data analyst 
SELECT
    AVG(salary_in_usd) AS avg_salary
FROM ds_salaries
WHERE job_title LIKE '%Data Analyst%';

-- 4.1 Berapa rata-rata gaji data analyst berdasarkan experience levelnya?
SELECT experience_level, (AVG(salary_in_usd) * 17500) /12 AS avg_sal_RP_monthly 
FROM ds_salaries
GROUP BY experience_level;

SELECT experience_level, AVG(salary_in_usd) AS avg_sal_monthly 
FROM ds_salaries
GROUP BY experience_level
ORDER BY avg_sal_monthly;

-- 4.1 bagaimana pengaruh experience level terhadap gaji data analyst?
SELECT
    experience_level,
    AVG(salary_in_usd) AS avg_salary
FROM ds_salaries
WHERE job_title LIKE '%Data Analyst%'
GROUP BY experience_level
ORDER BY avg_salary;

-- 4.2 bagaimana pengaruh jenis employment berdasarkan jenis employment?
SELECT
    employment_type,
    AVG(salary_in_usd) AS avg_salary
FROM ds_salaries
WHERE job_title LIKE '%Data Analyst%'
GROUP BY employment_type
ORDER BY avg_salary DESC;



-- 4.2 Berapa rata-rata gaji data analyst berdasarkan experience level dan jenis employment? 
SELECT experience_level, employment_type, company_location,
	AVG(salary_in_usd)  AS avg_sal_monthly 
FROM ds_salaries
GROUP BY experience_level,
	employment_type,
    company_location
ORDER BY experience_level, employment_type, company_location, avg_sal_monthly;
-- 
-- 5. Negara dengan gaji yang menarik untuk posisi data analys, full time, experience kerjanya entry level dan menengah atau mid
SELECT company_location, experience_level, 
	AVG(salary_in_usd) avg_sal_in_usd
FROM ds_salaries
WHERE job_title LIKE "%data analyst%"
	AND employment_type = 'FT' 
	AND	experience_level IN ('EN', 'MI')
GROUP BY company_location, experience_level
HAVING avg_sal_in_usd >= 20000; 

-- 6. Ditahun berapa kenaikan gaji dari mid ke expert itu memiliki kenaikan yang tertinggi?
-- untuk pekerjaan yang berkaitan dengan data analyst, full time
WITH ds_1 AS (
	SELECT work_year,
		AVG(salary_in_usd) sal_in_usd_ex
    FROM ds_salaries
    WHERE 
		employment_type = 'FT'
        AND experience_level = 'EX'
        AND job_title LIKE "%data analyst%"
	GROUP BY work_year
), ds_2 AS (
	SELECT work_year,
		AVG(salary_in_usd)sal_in_usd_mi
    FROM ds_salaries
    WHERE 
		employment_type = 'FT'
        AND experience_level = 'MI'
        AND job_title LIKE "%data analyst%"
	GROUP BY work_year
), t_year AS (
	SELECT DISTINCT work_year
    FROM ds_salaries
) SELECT t_year.work_year, 
	ds_1.sal_in_usd_ex,
    ds_2.sal_in_usd_mi,
    ds_1.sal_in_usd_ex - ds_2.sal_in_usd_mi difference
FROM t_year
LEFT JOIN ds_1 ON ds_1.work_year = t_year.work_year
LEFT JOIN ds_2 ON ds_2.work_year = t_year.work_year;

-- 7. Negara dengan gaji data analyst tertinggi
SELECT
    company_location,
    COUNT(*) AS total_data,
    AVG(salary_in_usd) AS avg_salary
FROM ds_salaries
WHERE job_title LIKE '%Data Analyst%'
GROUP BY company_location
HAVING COUNT(*) >= 5
ORDER BY avg_salary DESC;

-- 8. Apakah pekerjaan data analyst remote mempunyai gaji yang lebih tinggi daripada yang onsite?
SELECT DISTINCT remote_ratio
FROM ds_salaries
ORDER BY remote_ratio;

SELECT
    remote_ratio,
    COUNT(*) AS total_data,
    AVG(salary_in_usd) AS avg_salary
FROM ds_salaries
WHERE job_title LIKE '%Data Analyst%'
GROUP BY remote_ratio
ORDER BY remote_ratio;

SELECT
    CASE
        WHEN remote_ratio = 0 THEN 'Onsite'
        WHEN remote_ratio = 50 THEN 'Hybrid'
        WHEN remote_ratio = 100 THEN 'Fully Remote'
    END AS work_mode,
    COUNT(*) AS total_data,
    AVG(salary_in_usd) AS avg_salary
FROM ds_salaries
WHERE job_title LIKE '%Data Analyst%'
GROUP BY remote_ratio
ORDER BY avg_salary DESC;

-- 9. Apakah company size mempengaruhi gaji data analyst?
SELECT DISTINCT company_size
FROM ds_salaries;

SELECT
    CASE
        WHEN company_size = 'S' THEN 'Small'
        WHEN company_size = 'M' THEN 'Medium'
        WHEN company_size = 'L' THEN 'Large'
    END AS company_size_category,
    COUNT(*) AS total_data,
    AVG(salary_in_usd) AS avg_salary
FROM ds_salaries
WHERE job_title LIKE '%Data Analyst%'
GROUP BY company_size
ORDER BY avg_salary DESC;

-- 10. Spesialisasi data analyst yang mana yang memiliki rata-rata gaji tertinggi?
SELECT
    job_title,
    COUNT(*) AS total_data,
    AVG(salary_in_usd) AS avg_salary
FROM ds_salaries
WHERE job_title LIKE '%Data Analyst%'
GROUP BY job_title
HAVING COUNT(*) >= 5
ORDER BY avg_salary DESC;





		
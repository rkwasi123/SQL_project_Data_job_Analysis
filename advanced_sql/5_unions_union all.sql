-- Get jobs and companies from January
SELECT 
	job_title_short,
	company_id,
	job_location
FROM
	january_jobs

UNION -- combine the two tables 

-- Get jobs and companies from February 
SELECT 
	job_title_short,
	company_id,
	job_location
FROM
	february_jobs

UNION -- combine another table

-- Get jobs and companies from March
SELECT 
	job_title_short,
	company_id,
	job_location
FROM
	march_jobs


-- Get jobs and companies from January
SELECT 
	job_title_short,
	company_id,
	job_location
FROM
	january_jobs

UNION ALL

-- Get jobs and companies from February 
SELECT 
	job_title_short,
	company_id,
	job_location
FROM
	february_jobs

UNION ALL

-- Get jobs and companies from March
SELECT 
	job_title_short,
	company_id,
	job_location
FROM
	march_jobs;


-- I only want to look at job postings from the first quarter that have a salary greater than $70k. 
SELECT
	quarter1_job_postings.job_title_short,
	quarter1_job_postings.job_location,
	quarter1_job_postings.job_via,
	quarter1_job_postings.job_posted_date::DATE,
    quarter1_job_postings.salary_year_avg
FROM (
	SELECT *
	FROM january_jobs
	UNION ALL
	SELECT *
	FROM february_jobs
	UNION ALL 
	SELECT *
	FROM march_jobs
	) AS quarter1_job_postings 
WHERE
	quarter1_job_postings.salary_year_avg > 70000
	AND quarter1_job_postings.job_title_short = 'Data Analyst'
ORDER BY
	quarter1_job_postings.salary_year_avg DESC

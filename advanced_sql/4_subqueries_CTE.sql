-- Subqueries: query nested inside a larger query

SELECT*
FROM (-- subquery starts here
    SELECT*
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs;
-- subquery ends here

WITH january_jobs AS(-- CTE definition starts here
    SELECT*
    FROM job_postings_fact  
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)-- CTE definition ends here

SELECT*
FROM january_jobs;
------------------------------------------
-- Query:
/* subquery creates a list of company_ids from the job_postings table where 
there is no degree/mentioned*/

SELECT 
    company_id,
	name as company_name
FROM 
	company_dim 
WHERE company_id IN (
    SELECT 
			company_id 
    FROM 
			job_postings_fact 
    WHERE 
			job_no_degree_mention = true
)

/*
Find the companies that have the most job openings. 

- Get the total number of job postings per company id
- Return the total number of jobs with the company name
- Order from the most job postings to the least (`DESC`)
- Why? Look at which companies have the most job posting
*/

WITH company_job_count AS (
    SELECT 
			company_id, 
			COUNT(*) AS total_jobs 
    FROM 
			job_postings_fact 
    GROUP BY 
			company_id
)
SELECT 
	company_dim.name as company_name, 
	company_job_count.total_jobs 
FROM company_dim
LEFT JOIN company_job_count ON company_dim.company_id = company_job_count.company_id
ORDER BY
    total_jobs DESC;


-- Get the number of job postings per skill for remote jobs
WITH remote_job_skills AS (
  SELECT 
		skill_id, 
		COUNT(*) as skill_count
  FROM 
		skills_job_dim AS skills_to_job
	-- only get the relevant job postings
  INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
  WHERE 
		job_postings.job_work_from_home = True AND
		-- If you only want to search for data analyst jobs (like Luke does in the video)
		job_postings.job_title_short = 'Data Analyst'
  GROUP BY 
		skill_id
)

-- Return the skill id, name, and count of how many times its asked for
SELECT 
	skills.skill_id, 
	skills as skill_name, 
	skill_count
FROM remote_job_skills
-- Get the skill name
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY 
	skill_count DESC
LIMIT 5;
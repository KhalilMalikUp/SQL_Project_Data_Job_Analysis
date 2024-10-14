/*
Question: What are the top paying remote data analyst jobs?
- Identified the top 10 highest-paying data analyst roles that are available remotely.
- Focused on the job postings with specified salaries (removed nulls).
- Why? Highlight the top-paying oppurtunities for remote data analyst.
*/

SELECT 
    job_id, job_title, job_location, job_schedule_type,
        salary_year_avg, job_posted_date, name AS company_name
FROM
    job_postings_fact AS jpf
LEFT JOIN 
    company_dim AS cd
     ON cd.company_id = jpf.company_id
WHERE
    job_title_short = 'Data Analyst' 
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
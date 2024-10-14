/*
Question: What are the most in-demand skills for remote data analysts?
- Joined job postings to inner join table 
- Idenitified the top 5 in-demand skills for remote data analyst
- Focused on all job postings
- Why? Provides inights into the most valuable skills for job seekers
*/

SELECT 
    skills, 
    count(sjd.job_id) as demand_count
FROM 
    job_postings_fact as jpf
INNER JOIN
    skills_job_dim as sjd 
    ON jpf.job_id = sjd.job_id
INNER JOIN
    skills_dim as sd
    ON sjd.skill_id = sd.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    demand_count DESC
Limit 5;
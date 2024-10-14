/*
Question: What are the most optimal skills to learn (aka it's high in demand and a high-paying skill)?
- Indentified skills in high demand and associated with high average salries for remote data analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
    offering strategic insights for career development in data analysis
*/

WITH skills_demand AS (
    SELECT 
        sd.skill_id,
        sd.skills, 
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
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY
        sd.skill_id
), average_salary AS (
    SELECT
        sjd.skill_id, 
        ROUND (AVG(salary_year_avg), 0) AS avg_salary
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
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY
        sjd.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN
    average_salary
    ON skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;









-- MORE CONSISE VERSION OF ABOVE QUERY
SELECT
    sd.skill_id,
    sd.skills,
    COUNT(sjd.job_id) AS demand_count,
    ROUND(AVG(jpf.salary_year_avg), 0) AS avg_salary
FROM    
    job_postings_fact as jpf
INNER JOIN 
    skills_job_dim as sjd 
    ON sjd.job_id = jpf.job_id
INNER JOIN
    skills_dim as sd
    ON sjd.skill_id = sd.skill_id
WHERE 
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    sd.skill_id
HAVING
    COUNT(sjd.job_id) > 10    
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
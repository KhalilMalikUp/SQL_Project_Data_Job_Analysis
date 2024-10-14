#  Introduction
📊 Dive into the data job market! Focusing on remote data analyst roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.

🔍 SQL queries? Check them out here: [project_sql](/project_sql/)

# Background
Driven by a quest to navigate the remote data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

Data hails from trusted Senior Data Analytics: [Luke Barousse](https://www.lukebarousse.com/). He provided insights of job titles, salaries, locations, and essential skills.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying remote data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries
5. What are the most optimal skills to learn?

# Tools I used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL**: The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL**: The choosen database managment system, ideal for handling the job posting data.
- **Visual Studio Code**: My go-to for database management and executing SQL queries.
- **Git & GitHub**: Essential for version control and sharig my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question:

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field. 

```sql
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
```
Here's the breakdown of the top data analyst job in 2023:
- **Wide Salary range:** Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salries, showing a broad interest across different industries.
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.

![Top Paying Roles](assets\1_top_paying_roles.png)
*Bar graph visualizing the salary for the top 10 salaries for data analysts; ChatGPT generated this graph from the SQL query results.*

### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
With top_paying_jobs AS (

    SELECT 
        job_id, job_title, 
        salary_year_avg,  name AS company_name
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
    LIMIT 10
)

SELECT 
    top_paying_jobs.*, sd.skills
FROM 
    top_paying_jobs
INNER JOIN
    skills_job_dim as sjd 
    ON top_paying_jobs.job_id = sjd.job_id
INNER JOIN
    skills_dim as sd
    ON sjd.skill_id = sd.skill_id
ORDER BY
    salary_year_avg DESC;
```

Here's a breakdown of the most demanded skills for remote data analyst in 2023, based on job postings:
- **Sql** is leading with a count of 8.
- **Python** follows closely with a count of 7.
- **Tableau** is also highly sought after, with a count of 6. Other skills like **R**, **Snowflake**, **Pandas**, and **Excel** show varying degrees of demand.

![Top Paying Skills][def]
*Bar graph visualizing the count of skills for the top 10 paying jobs for data analysts; ChatGPT generated this graph from the SQL query results.* 

### 3. In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
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
```
Here's the breakdown of the most demanded skills for data analysts in 2023
- **Sql** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in data proceessing and spreadsheet manipulation.
- **Programming** and **Visualization Tools** like **Python**, **Tableua**, and **Power BI** are essential, pointing towaards the increasing importance of technical skills in data storytelling and decision support.

| Skills   | Demand Count |
|----------|--------------|
| SQL      | 7291         | 
| Excel    | 4611         |
| Python   | 4330         |
| Tableau  | 3745         |
| Power BI | 2609         |

*Table of the demand for the top 5 skills in data analyst job postings*

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT 
    skills, 
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
    skills
ORDER BY
    avg_salary DESC
Limit 25;
```
Here's a breakdown of the results for top paying skills for Data Analysts
- **Big Data & ML Skills:** Top salaries are commanded by big data tech **(PySpark, Couchbase)**, machine learning tools **(DataRobot, Jupyter)** and Python libraries **(Pandas, NumPy).**
- **Software Development & Deployment Proficiency:** Knowledge in development and deployment tool.
    like **GitLab, Kubernetes,** and **Airflow.**
- **Cloud Computing Expertise:** Familiarity with cloud and data engineering tools like **Elasticsearch, Databricks**, and **GCP.**

| Skills   | Average Salary($) |
|----------|--------------|
| Pyspark      | 208,172         | 
| Bitbucket    | 189,155         |
| Couchbase   | 160,515         |
| Watson  | 160,515         |
| Datarobot | 155,486         |
| Gitlab | 154,500
| Swift | 153,750
| Jupyter | 152,777
| Pandas | 151,821
| Elasticsearch | 145,000

*Table of the average salary for the top 10 paying skills for data analysts*

### 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are high in demand and offering a strategic focus for skill development.

```sql
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
```
| Skill ID| Skills | Demand Count | Average Salary($)
|----------|--------------|---------|---
| 8      | Go      | 27 | 115,320
| 234    | Confluence         | 11 | 114,210
| 97   | Hadoop         | 22 | 113,193
| 80  | Snowflake        | 37 | 112,948
| 74 | Azure        | 34 | 111,225
| 77 | Bigquery | 13 | 109,654
| 76 | AWS | 32 | 108,317
| 4 | Java | 17 | 106,906
| 194 | SSIS | 12 | 106,683
| 233 | Jira | 20 | 104,918

*Table of the most optimal skills for data analysts sorted by salary*

Here's a breakdown of the most optimal skills for Data Analysts in 2023:
- **High-Demand Programming Languages:** Python and R stand out for their high demand, with demand counts of 236 and 148 respectively. Despite their high demand, their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued but also widely available.
- **Cloud Tools and Technologies:** Skills in specialized technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
- **Business Intelligence and Visualization Tools:** Tableau and Looker, with demand counts of 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in deriving actionable insights from data.
- **Database Technologies:** The demand for skills in traditional and NoSQL databases (Oracle, SQL Server, NoSQL) with average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retrieval, and management expertise.

# What I learned

Throughout this adventure, I've jumpstarted my SQL toolkit with some serious firepower:

= **🧩 Complex Query Crafting:** Learned the art of advanced SQL with Operators, Creating and Manipulating Tables, and merging data with Subqueries and CTEs.
- **📊 Data Aggregation:** Got comfortable with GROUP BY and made effective use of aggregate functions like COUNT() and AVG().
- **💡 Analytical Fundamentals:** Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.

# Conclusions 

### Insights
From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs:** The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs:** High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills:** SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries:** Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value:** SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

### Closing Thoughts

This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. As an aspiring data analysts, I can better position myself in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.

[def]: assets\2_top_paying_roles_skills.png
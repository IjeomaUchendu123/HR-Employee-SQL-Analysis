CREATE DATABASE PROJECTS;

USE PROJECTS;

SELECT * FROM hr;
ALTER TABLE hr CHANGE COLUMN ï»¿id EmpID VARCHAR(20) NULL;
SELECT * FROM hr;
DESCRIBE hr;
SET sql_safe_updates = 0;

UPDATE hr 
SET birthdate = CASE 
WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'),'%Y-%m-%d')
WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'),'%Y-%m-%d')
ELSE null
END;

SELECT birthdate from hr;
ALTER TABLE hr MODIFY COLUMN birthdate DATE;
UPDATE hr 
SET hire_date = CASE 
WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'),'%Y-%m-%d')
WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'),'%Y-%m-%d')
ELSE null
END;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

SELECT hire_date FROM hr;
SELECT termdate FROM hr;

UPDATE hr
SET termdate = date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate !='';

SET SQL_MODE = '';

ALTER TABLE hr 
MODIFY COLUMN termdate DATE;
DESCRIBE hr;
SELECT * FROM hr;
ALTER TABLE hr ADD COLUMN age INT;

SET sql_safe_updates = 0;

UPDATE hr 
SET age = timestampdiff(YEAR, birthdate, CURDATE());
SELECT * FROM hr;
SELECT min(age) AS youngest, max(age) AS oldest FROM hr;
SELECT count(*) FROM hr WHERE age < 18;

-- 1. What is the gender breakdown of employees in the company ?
SELECT gender, count(*) AS gender_count FROM hr 
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company ?
SELECT race, Count(*) AS Race_Count FROM hr 
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY race
ORDER BY count(*) DESC;

-- 3. What is the age distribution of employees in the company ?
SELECT min(age) AS youngest, max(age) AS oldest FROM hr
WHERE age >= 18 AND termdate = '0000-00-00';

SELECT
 CASE 
   WHEN age>= 18 AND age<=24 THEN '18-24'
   WHEN age>= 25 AND age<=34 THEN '25-34'
   WHEN age>= 35 AND age<=44 THEN '35-44'
   WHEN age>= 45 AND age<=54 THEN '45-54'
   WHEN age>= 55 AND age<=64 THEN '55-64'
   ELSE '65+'
   END AS age_group,
   count(*) AS age_group_count FROM hr 
   WHERE age >= 18 AND termdate = '0000-00-00'
   GROUP BY age_group
   ORDER BY age_group;
   
SELECT
 CASE 
   WHEN age>= 18 AND age<=24 THEN '18-24'
   WHEN age>= 25 AND age<=34 THEN '25-34'
   WHEN age>= 35 AND age<=44 THEN '35-44'
   WHEN age>= 45 AND age<=54 THEN '45-54'
   WHEN age>= 55 AND age<=64 THEN '55-64'
   ELSE '65+'
   END AS age_group, gender,
   count(*) AS age_group_count FROM hr 
   WHERE age >= 18 AND termdate = '0000-00-00'
   GROUP BY age_group, gender
   ORDER BY age_group, gender;
   
   SELECT * from hr;
   
   -- 4. How many employees work at headquarters versus remote location ?
   SELECT location, count(*) AS location_count FROM hr
   WHERE age >= 18 AND termdate = '0000-00-00'
   GROUP BY location
   ORDER BY location_count DESC;
   
   -- 5. What is the average length of employment for employees who have been terminated?
   SELECT round(avg(datediff(termdate, hire_date))/365,0) AS avg_length_employment FROM hr
   WHERE termdate <= curdate() AND termdate <> '0000-00-00' AND age>=18;
   
   
   -- 6. How does the gender distribution vary across departments and job titles?
   SELECT department, gender, count(*) AS dept_gender_dist FROM hr
   WHERE age >= 18 AND termdate = '0000-00-00'
   GROUP BY department, gender
   ORDER by department;
   
   -- 7. What is the distribution of job titles across the company ?
   SELECT jobtitle, count(*) as jobtitle_count FROM hr
   WHERE age >= 18 AND termdate = '0000-00-00'
   GROUP BY jobtitle
   ORDER BY jobtitle DESC;
   
   -- 8. Which department has the highest turnover rate ?
   SELECT department, total_count, terminated_count, terminated_count/total_count AS terminated_rate
   FROM (SELECT department, count(*) as total_count,
    sum(CASE WHEN termdate <>'0000-00-00' AND termdate <=curdate() THEN 1 ELSE 0 END) AS terminated_count
    FROM hr
    WHERE age>=18
    GROUP BY department)
    AS subquery
    ORDER BY terminated_rate DESC;
    
    -- 9. What is the distribution of employees across locations by city and state ?
    SELECT location_state, count(*) as location_count from hr 
    WHERE termdate= '0000-00-00' and age >= 18
    GROUP BY location_state
    ORDER BY location_count DESC;
    
    -- 10. How has the company's employee count changed over time based on hire and term dates?
    SELECT year, hires, terminations, hires-terminations AS net_change, 
    round((hires - terminations)/hires * 100, 2) AS net_change_percentage
    FROM(
      SELECT year(hire_date) AS year,
      count(*) AS hires,
      sum(CASE WHEN termdate <> '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminations
	  FROM hr
      WHERE age >=18
      GROUP BY year(hire_date))
      AS subquery
    ORDER BY year ASC;
    
    -- 11. What is the tenure distribution for each department ?
    SELECT department, round(avg(datediff(termdate, hire_date)/365),0) AS avg_tenure
    FROM hr
    WHERE termdate <> '0000-00-00' AND termdate <= curdate() AND age>= 18
    GROUP BY department
    ORDER BY avg_tenure;
    
    SELECT * FROM hr;
    
   

SET sql_mode = ''

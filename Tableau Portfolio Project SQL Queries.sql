/*
Queries used for Tableau Project
*/

-- 1.

SELECT 
    date, 
    SUM(new_cases) AS total_cases, 
    SUM(new_deaths) AS total_deaths, 
    SUM(new_deaths)/SUM(new_cases)*100 AS global_death_rate
FROM
    my-data-project-35921.portfolio_project.covid_deaths
WHERE
    continent IS NOT NULL 
GROUP BY date
ORDER BY 1,2

-- 2.

-- we remove ('World', 'European Union', 'International') because they are not inluded in the above queries and want to stay consistent
-- 'European Union' is part of 'Europe'

SELECT
    location, SUM(new_deaths) AS total_death_count
FROM
    my-data-project-35921.portfolio_project.covid_deaths
WHERE continent IS NULL 
AND
Location NOT IN ('World', 'European Union', 'International')
GROUP BY Location
ORDER BY total_death_count DESC

-- 3.

SELECT 
    Location, population,
    MAX(total_cases) AS number_of_cases,
    MAX((total_cases/population))*100 AS infection_rate
FROM
    my-data-project-35921.portfolio_project.covid_deaths
WHERE
    continent IS NOT NULL
GROUP BY Location, population
ORDER BY infection_rate DESC

-- 4.

SELECT
    Location, Population,date,
    MAX(total_cases) as number_of_cases,
    Max((total_cases/population))*100 AS infection_rate
FROM
    my-data-project-35921.portfolio_project.covid_deaths
GROUP BY Location, Population, date
ORDER BY infection_rate DESC

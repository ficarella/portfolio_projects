/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

SELECT 
    *
FROM
    my-data-project-35921.portfolio_project.covid_deaths
ORDER BY 3,4

-- Select Data that we are going to be starting with

SELECT
    Location, date, total_cases, new_cases, total_deaths, population
FROM
    my-data-project-35921.portfolio_project.covid_deaths
ORDER BY 1,2

-- looking at total_cases vs total_deaths
-- shows likelyhood of death if infected with COVID-19 in the UK

SELECT 
    Location, date, total_cases, total_deaths,
    (total_deaths/total_cases)*100 AS death_percentage
FROM
    my-data-project-35921.portfolio_project.covid_deaths
WHERE
    Location = "United Kingdom"
ORDER BY 1,2

-- looking at total_cases vs population
-- shows percentage of the population infected with COVID-19 in the UK

SELECT 
    Location, date, population, total_cases,
    (total_cases/population)*100 AS infection_rate
FROM
    my-data-project-35921.portfolio_project.covid_deaths
WHERE
    Location = "United Kingdom"
ORDER BY 1,2

-- countries with highest infection rate

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

-- total deaths per country

SELECT
    Location, MAX(total_deaths) as total_death_count
FROM
    my-data-project-35921.portfolio_project.covid_deaths
WHERE
    continent IS NOT NULL
GROUP BY Location
ORDER BY total_death_count DESC

-- countries with highest death count per capita

SELECT 
    Location, population,
    MAX(total_deaths) AS number_of_deaths,
    MAX((total_deaths/population))*100 AS death_rate
FROM
    my-data-project-35921.portfolio_project.covid_deaths
GROUP BY Location, population
ORDER BY death_rate DESC

-- GLOBAL NUMBERS

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

-- total population vs vaccinations
-- percentage of population with at least one COVID-19 vaccine

SELECT
    deaths.continent, deaths.Location, deaths.date, deaths.population, vacc.new_vaccinations,
    SUM(new_vaccinations) OVER (PARTITION BY deaths.Location ORDER BY deaths.location, deaths.date) AS total_number_of_vaccinations
FROM
    my-data-project-35921.portfolio_project.covid_deaths AS deaths
    JOIN my-data-project-35921.portfolio_project.covid_vaccinations AS vacc
        ON deaths.Location = vacc.Location
        AND 
        deaths.date = vacc.date
WHERE
    deaths.continent IS NOT NULL
ORDER BY 2,3

-- examples of CTE to perform calculation on 'PARTITION BY'

WITH
    pop_vs_vacc
AS
(SELECT
    deaths.continent, deaths.Location, deaths.date, deaths.population, vacc.new_vaccinations,
    SUM(new_vaccinations) OVER (PARTITION BY deaths.Location ORDER BY deaths.location, deaths.date) AS total_number_of_vaccinations
FROM
    my-data-project-35921.portfolio_project.covid_deaths AS deaths
    JOIN my-data-project-35921.portfolio_project.covid_vaccinations AS vacc
        ON deaths.Location = vacc.Location
        AND 
        deaths.date = vacc.date
WHERE
    deaths.continent IS NOT NULL)
SELECT 
    *, (total_number_of_vaccinations/Population)*100 AS percent_of_pop_vacc
FROM 
    pop_vs_vacc

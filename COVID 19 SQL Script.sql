-- Data Exploration with COVID-19 
-- Skills utilized: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

-- Select data to begin exploration process 
SELECT 
	location, 
    date, 
    total_cases, 
    new_cases, 
    total_deaths, 
    population
FROM 
	ProjectPortfolio.coviddeaths
WHERE 
	continent IS NOT NULL
ORDER BY
	1,2;

-- Evaluated the Total Cases vs Total Deaths
-- The death percentage represents the liklihood of dying if one contracts COVID in a specified country

SELECT 
	location, 
	date, 
    total_cases, 
    total_deaths, 
    (total_deaths/total_cases)*100 AS death_percentage
FROM 
	ProjectPortfolio.coviddeaths
WHERE 
	continent IS NOT NULL
ORDER BY 1,2;


-- Evaluated the Total Cases vs Population
-- Conveys the percentage of the population who has contracted COVID 

SELECT 
	location, 
	date, 
    population, 
    total_cases, 
    (total_cases/population)*100 AS infection_percentage
FROM 
	ProejectPortfolio.coviddeaths
WHERE 
	continent IS NOT NULL
ORDER BY 
	1,2;


-- Evaluated the countries with Highest Infection Rate compared to Population
-- Conveys the infection percentage within a specified country

SELECT 
	location, 
    population, 
    MAX(total_cases) AS Highest_Infection_Count, 
    MAX((total_cases/population))*100 AS infection_percentage
FROM 
	ProejectPortfolio.coviddeaths
WHERE 
	continent IS NOT NULL
GROUP BY 
	location, 
    population
ORDER BY 
	infection_percentage DESC; 


-- Shows the Countries with the highest Death Count per Population

SELECT 
	location, 
    MAX(CAST(total_deaths AS FLOAT)) AS Total_Death_Count
FROM 
	ProjectPortfolio.coviddeaths
GROUP BY 
	location
ORDER BY 
	Total_Death_Count DESC;


-- DISSECTED DATA BY CONTINENT
-- Conveys the contintents with the highest death count per population
SELECT 
	continent, 
	MAX(CAST(total_deaths AS FLOAT)) AS Total_Death_Count
FROM 
	ProejectPortfolio.coviddeaths
WHERE 
	continent IS NOT NULL
GROUP BY 
	continent
ORDER BY 
	Total_Death_Count DESC;


-- Evaluated the global numbers of cases and deaths 

SELECT 
	date, 
    SUM(new_cases) AS total_cases, 
    SUM(CAST(new_deaths AS FLOAT)) AS total_deaths, 
    SUM(CAST(new_deaths AS FLOAT))/SUM(new_cases)*100 AS Death_Percentage
FROM 
	ProjectPortfolio.coviddeaths
WHERE 
	continent IS NOT NULL
GROUP BY 
	date
ORDER BY 
	1,2;

SELECT 
	SUM(new_cases) AS total_cases, 
    SUM(CAST(new_deaths AS FLOAT)) AS total_deaths, 
    SUM(CAST(new_deaths AS FLOAT))/SUM(new_cases)*100 AS Death_Percentage
FROM 
	ProjectPortfolio.coviddeaths
WHERE 
	continent IS NOT NULL
ORDER BY
	1,2;


-- Evaluated the Total Population vs Vaccinations
-- Conveys the Percentage of Population that has recieved at least one Covid Vaccine

SELECT 
	d.continent, 
    d.location, 
    d.date, 
    d.population, 
    v.new_vaccinations, 
	SUM(CAST(v.new_vaccinations AS FLOAT)) OVER (PARTITION BY d.Location ORDER BY d.location, d.Date) AS Rolling_People_Vaccinated
FROM 
	coviddeaths d
JOIN covidvaccinations v
	ON d.location = v.location
	AND d.date = v.date
WHERE 
	d.continent IS NOT NULL
ORDER BY 
	2,3;


-- Utilizing CTE to perform Calculation on Partition By in previous query

WITH PopvsVac (continent, location, date, population, new_vaccinations, Rolling_People_Vaccinated)
as
(
SELECT 
	d.continent, 
    d.location, 
    d.date, 
    d.population, 
    v.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS FLOAT)) OVER (PARTITION BY d.Location ORDER BY d.location, d.Date) AS RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
FROM
	coviddeaths d
JOIN covidvaccinations v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent IS NOT NULL
-- order by 2,3
)
Select	
	*, 
    (Rolling_People_Vaccinated/population)*100
From 
	PopvsVac;


-- Implementing a Temp Table to perform Calculation on Partition By in previous query

/* DROP TABLE IF EXISTS 
	PercentPopulationVaccinated */
    
CREATE TABLE PercentPopulationVaccinated
(
	Continent NVARCHAR(255),
	Location NVARCHAR(255),
	Date DATETIME,
	Population NUMERIC,
	New_vaccinations NUMERIC,
	RollingPeopleVaccinated NUMERIC
);
INSERT INTO 
	PercentPopulationVaccinated
SELECT 
	d.continent, 
    d.location, 
    d.date, 
    d.population, 
    v.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS FLOAT)) OVER (PARRTITION BY d.Location ORDER BY d.location, d.Date) AS RollingPeopleVaccinated,
	(RollingPeopleVaccinated/population)*100
FROM 
	ProejectPortfolio.coviddeaths d
JOIN covidvaccinations v
	ON d.location = v.location
	AND d.date = v.date
WHERE 
	d.continent IS NOT NULL 
ORDER BY
	2,3

SELECT 
	*, 
    (RollingPeopleVaccinated/Population)*100
FROM 
	PercentPopulationVaccinated


-- Creating View to store data for later visualizations

CREATE VIEW 
	PercentPopulationVaccinated AS
SELECT 
	d.continent, 
	d.location, 
    d.date, 
    d.population,
    v.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS FLOAT)) OVER (PARTITION BY d.Location ORDER BY d.location, d.Date) AS RollingPeopleVaccinated,
	(RollingPeopleVaccinated/population)*100
FROM coviddeaths d
JOIN covidvaccinations v
	ON d.location = v.location
	AND d.date = v.date
WHERE 
	d.continent IS NOT NULL;


-- QUERIES UTILIZED FOR TABLEAU VISUALIZATIONS

-- Tableau Table 1. 
SELECT 
	SUM(new_cases) AS total_cases, 
    SUM(CAST(new_deaths AS FLOAT)) AS total_deaths, 
    SUM(CAST(new_deaths as FLOAT))/SUM(New_Cases)*100 AS DeathPercentage
FROM 
	PortfolioProject.coviddeaths
WHERE 
	continent IS NOT NULL
ORDER BY 
	1,2;


-- Tableau Table 2. 

SELECT 
	location, 
    SUM(CAST(new_deaths AS FLOAT)) AS TotalDeathCount
From 
	PortfolioProject.coviddeaths
WHERE 
	continent IS NULL
	AND location NOT IN ('World', 'European Union', 'International')
GROUP BY 
	location
ORDER BY 
	TotalDeathCount DESC;


-- Tableau Table 3.

SELECT 
	Location, 
	Population, MAX(total_cases) AS HighestInfectionCount,  
    Max((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject.coviddeaths
GROUP BY
	Location, 
    Population
ORDER BY
	PercentPopulationInfected DESC;


-- Tableau Table 4.

SELECT
	Location, 
	Population,
    date, 
    MAX(total_cases) AS HighestInfectionCount,  
    Max((total_cases/population))*100 AS PercentPopulationInfected
FROM
	PortfolioProject.coviddeaths
GROUP BY 
	Location, 
	Population, 
    date
ORDER BY
	PercentPopulationInfected DESC;

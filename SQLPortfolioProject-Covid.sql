SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, new_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Total Cases vs Total Deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%States%' AND continent IS NOT NULL
ORDER BY 1,2

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2


-- Total cases vs Population
-- Percentage of population got covit

SELECT location, date, population, total_cases, (total_cases/population) * 100 AS PercentageOfInfectedPopulation
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Countries with Highest Infection rate compared to Population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population) * 100) AS PercentageOfInfectedPopulation
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentageOfInfectedPopulation DESC

-- Countries with Highest Death Count per Population

SELECT location, MAX(total_deaths) AS TotalDeathCount 
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- group by continent

SELECT continent, MAX(total_deaths) AS TotalDeathCount 
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

SELECT location, MAX(total_deaths) AS TotalDeathCount 
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL AND location NOT LIKE '%income'
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Global Number

SELECT SUM(new_cases) AS total_cases, SUM (new_deaths) AS total_deaths , SUM(new_deaths) / SUM(new_cases) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 


-- Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingNumberOfVaccinatedPersons
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

--Use CTE

WITH PopVsVac (continent, location, date, population, new_vaccinations, RollingNumberOfVaccinatedPersons)
AS (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingNumberOfVaccinatedPersons
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL)
SELECT *, RollingNumberOfVaccinatedPersons/population 
FROM PopVsVac
ORDER BY 2,3

-- Temp Table

--DROP TABLE IF EXISTS #PopulationVsVaccination
CREATE TABLE #PopulationVsVaccination
(
continent nvarchar(255),
location nvarchar(255),
date date,
population numeric,
new_vaccinations numeric,
RollingNumberOfVaccinatedPersons numeric
)

INSERT INTO #PopulationVsVaccination
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingNumberOfVaccinatedPersons
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *, RollingNumberOfVaccinatedPersons/population 
FROM #PopulationVsVaccination
ORDER BY 2,3

-- Creating View to store data for later visualizations

CREATE VIEW PopulationVsVaccination AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingNumberOfVaccinatedPersons
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL


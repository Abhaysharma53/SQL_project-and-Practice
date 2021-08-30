/*CREATE DATABASE PortfolioProject;*/

SELECT * FROM PortfolioProject.dbo.covid_deaths;
--SELECT * FROM covid_deaths
--ORDER BY 3,4;

--SELECT COUNT(*) FROM covid_deaths;
--DROP TABLE covid_vaccination;
USE portfolioproject;
SELECT * FROM covid_vaccination;
SELECT location, date, total_cases, new_cases, total_deaths, population 

-- Selecting the data to be used

SELECT location, date, total_cases, new_cases, total_deaths, population from covid_deaths;

-- total cases vs total deaths  === % of the ppl who died out of cases
SELECT location, date, total_cases, total_deaths, ((total_deaths/total_cases)* 100) as Percentagedeath FROM covid_deaths;

-- in india
SELECT location, date, total_cases, total_deaths, ((total_deaths/total_cases)* 100) as Percentagedeath FROM covid_deaths
WHERE location = 'india';
-- so if we see the current stats then in india if a person got covid then there is around 1.34% that he will be dying out of that
-- there is a significant improvement compare to 16 june 2020 when it was around 3.36% when this rate was at its peak

-- looking at the total cases vs the poulation
SELECT location, date, population, total_cases, ((total_cases/population)*100) AS percent_population_infected  from covid_deaths
ORDER BY location, date;

-- which countries has highest infection rate with respect to its population
SELECT location, population, MAX(total_cases) AS highestinfectioncount, MAX((total_cases/ population)*100) as percentpopulationinfected from covid_deaths
GROUP BY location, population
ORDER BY percentpopulationinfected;

-- verifying
SELECT MAX(total_cases) FROM covid_deaths WHERE location = 'Brunei';  -- thats right

-- on no of people count (highest death count per population)
SELECT location, sum(CAST(new_deaths as int)) AS totaldeathcount from covid_deaths
WHERE continent is not NULL
GROUP BY location
ORDER BY totaldeathcount DESC;
-- so as per the data we can clearly see that total death in india due to corona by 26 july 2021 is around 42 lacs
-- whereas highest no of deaths is in united states
-- further more what if we try to check which of these countries was damaged the most due to covid according to their population

--CREATE TABLE #damagecte (location nvarchar(255), continent nvarchar(255),  new_deaths nvarchar(255), totaldeathcount numeric);
SELECT location, sum(CAST(new_deaths as int)) AS totaldeathcount, max(population) AS total population, 
sum(CAST(new_deaths as int))/max(population) AS percentagedamage from covid_deaths
WHERE continent is not NULL
GROUP BY location
ORDER BY totaldeathcount DESC;

-- breaking things down by continent
-- showing continents with highest death cont per population
SELECT continent, SUM(CAST(new_deaths as INT)) as total_deathbycontinent FROM covid_deaths WHERE continent is not null
GROUP BY continent ORDER BY total_deathbycontinent;

-- let's look at some global numbers like 
-- total  cases in the world day wise
SELECT date, SUM(new_cases) AS total_cases, sum(CAST(new_deaths as INT)) as total_deaths, 
(sum(CAST(new_deaths as INT))/ SUM(new_cases))*100 AS death_percentage FROM covid_deaths WHERE continent IS NOT NULL GROUP BY date 
ORDER BY date;


-- if we want the total cases so far globally
SELECT SUM(new_cases) AS total_cases, sum(CAST(new_deaths as INT)) as total_deaths, 
(sum(CAST(new_deaths as INT))/ SUM(new_cases))*100 AS death_percentage FROM covid_deaths WHERE continent IS NOT NULL;

-- lets look at the another table covid_vaccination
SELECT * FROM covid_vaccination;
-- looking at the total population vs vaccinated
-- what is the total amount and the percentage of the people who got vaccinated
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations FROM covid_deaths cd INNER JOIN covid_vaccination cv
ON cd.location = cv.location AND cd.date = cv.date
WHERE cd.continent IS NOT NULL ORDER BY cd.location, cd.date;

-- if we look at the population vaccination data by global way
--SELECT cd.continent, sum(cd.population)  AS populationbycontinent, MAX(CAST(cv.total_vaccinations AS NUMERIC)) AS total_vaccinated FROM covid_deaths cd 
--INNER JOIN covid_vaccination cv ON cd.continent = cv.continent 
--WHERE cd.continent IS NOT NULL GROUP BY cd.continent;

SELECT TOP 100 * from covid_deaths;







/* Queries used for the tableau dashboard */
-- query used for constructing the dashboard
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..covid_deaths
--Where location like 'india'
where continent is not null 
--Group By date
order by 1,2

--2 
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..covid_deaths

Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

--3
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..covid_deaths
Group by Location, Population
order by PercentPopulationInfected desc


--4
Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..covid_deaths
Group by Location, Population, date
order by PercentPopulationInfected desc




















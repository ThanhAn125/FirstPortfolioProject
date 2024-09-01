ALTER TABLE profol.dbo.Death alter column total_cases float;
ALTER TABLE profol.dbo.Death alter column total_deaths float;


-- looking at total deaths vs total cases
SELECT location,  date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPerCases
  FROM [Profol].[dbo].[Death]
  order by 1,2

-- looking at total death vs population
SELECT location,  date, population, total_cases, total_deaths, (total_deaths/population)*100 as DeathPerPopulation
  FROM [Profol].[dbo].[Death]
  where location like '%asia'
  order by 1,2

  -- looking at total cases vs population
  SELECT location,  date, population, total_cases, total_deaths, (total_cases/population)*100 as CasesPerPopulation
  FROM [Profol].[dbo].[Death]
  where location like '%asia'
  order by 1,2

  --looking at highest effective and death rate
  SELECT 
	location, 
	population, 
	max(total_cases) as TotalCases, 
	max(total_deaths) as TotalDeaths, 
	(max(total_deaths)/max(total_cases))*100 as DeathsPerCase,
	max(total_cases/population)*100 as CasesPerPopulation,
	max(total_deaths/population)*100 as DeathPerPopulation
  FROM [Profol].[dbo].[Death]
  where continent is not null
  group by location,population
  order by location

    SELECT 
	location, 
	population, 
	max(total_cases) as Max_case, 
	max(total_deaths) as Max_death, 
	max(total_cases/population)*100 as CasesPerPopulation,
	max(total_deaths/population)*100 as DeathPerPopulation
  FROM [Profol].[dbo].[Death]
  where continent is not null
  group by location,population
  order by CasesPerPopulation desc

  -- Looking at continent
  SELECT 
	location Location, 
	population Population, 
	max(total_cases) as TotalCases,
	max(total_deaths) as TotalDeaths, 
	(max(total_deaths)/max(total_cases))*100 as DeathsPerCase
  FROM [Profol].[dbo].[Death]
  where continent is null
  group by location,population
  order by DeathsPerCase desc 

  SELECT 
	location, 
	population, 
	max(total_cases) as Max_case, 
	max(total_deaths) as Max_death, 
	max(total_cases/population)*100 as CasesPerPopulation,
	max(total_deaths/population)*100 as DeathPerPopulation
  FROM Profol.dbo.Vacctionation
  where continent is null
  group by location,population
  order by DeathPerPopulation desc

    -- Looking at Global
select * from [Profol].[dbo].[Death] order by date

--with TTDeaths (location,population,TotalDeaths)
--as 
--(
--SELECT location, population, sum(total_deaths) over (partition by location order by location,date) as TotalDeaths
--from [Profol].[dbo].[Death])

--select *, (TotalDeaths/population) * 100 as PercantDeathPerDate
--from TTDeaths


Create view Covid19Infor as
  SELECT 
	dea.location, 
	dea.population,
	max(total_cases) as Total_Cases, 
	max(total_deaths) as Total_Deaths,
	max(people_vaccinated) as People_Vacinate,
	max(people_fully_vaccinated) as PP_VacFull,
	(max(total_deaths)/max(total_cases))*100 as DeathsPerCase,
	(max(total_cases) /dea.population) *100 as CasesPerPopulation,
	(max(total_deaths) /dea.population) *100 as DeathPerPopulation,
	(max(people_vaccinated)/dea.population) * 100 as TotalPPVacPerPop,
    (max(people_fully_vaccinated) /dea.population)*100 as FullVacPerPop,
	(max(total_deaths)/max(people_vaccinated)) *100 as DeathPerPPVacinnated

  FROM [Profol].[dbo].[Death] dea
  join [Profol].[dbo].[Vaccinate] vac
  on dea.location = vac.location and dea.date = vac.date
  where dea.continent is not null
  group by dea.location,dea.population
  --order by DeathsPerCase DESC
  ;
 




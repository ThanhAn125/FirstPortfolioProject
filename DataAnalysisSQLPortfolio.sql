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

with TTDeaths (location,population,TotalDeaths)
as 
(
SELECT location, population, sum(total_deaths) over (partition by location order by location,date) as TotalDeaths
from [Profol].[dbo].[Death])

select *, (TotalDeaths/population) * 100 as PercantDeathPerDate
from TTDeaths


-- Creat View 
Create view Covid19Infor as
  with CVInforBytime (location,Date,Population,Total_Cases,Total_Deaths,People_Vaccinate,PP_VacFull)
 as
(
SELECT 
	dea.location,
	dea.date, 
	dea.population,
	max(total_cases) as Total_Cases, 
	max(total_deaths) as Total_Deaths,
	max(people_vaccinated) as People_Vaccinate,
	max(people_fully_vaccinated) as PP_VacFull
  FROM [Profol].[dbo].[Death] dea
  join [Profol].[dbo].[Vaccinate] vac
  on dea.location = vac.location and dea.date = vac.date
  where dea.continent is not null
  group by dea.location, dea.date, dea.population
  )
  select 
  *, 
  Total_Deaths/Total_Cases as DeathsPerCase, 
  Total_Cases/population as CasesPerPopulation,
  Total_Deaths/population as DeathPerPopulation,
  People_Vaccinate/population as TotalPPVacPerPop,
  PP_VacFull/population as FullVacPerPop,
  Total_Deaths/nullif(People_Vaccinate,0) as DeathPerPPVacinnated        
  from CVInforBytime
 




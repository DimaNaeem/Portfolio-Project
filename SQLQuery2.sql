use Portfolio Project;
use SPARTA

select * 
from CovidDeaths$
order by 3,4

select * 
from CovidVaccinations$
order by 3,4

select * 
from CovidDeaths$
where continent is not null
order by 3,4

--seelct data that we are going to be using
Select  Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths$
order by 1,2

--looking at Total Cases vs Total Deaths
Select  Location, date, total_cases,total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths$
order by 1,2
--shows likelihood of dying if u contract covid in country
Select  Location, date, total_cases,total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths$
Where location like '%Pakistan%'
order by 1,2

--looking at total cases vs population
Select  Location, date, Population, total_cases, (total_cases/population)*100 as DeathPercentage
From CovidDeaths$
Where location like '%Pakistan%'
order by 1,2

--Looking at countries with Highest Infection Rate compared to Population

Select  Location, Population, MAX( total_cases)as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths$
--Where location like '%Pakistan%'
Group by Location, Population
order by PercentPopulationInfected desc

--showing Countries with Highest death Count per population
Select  Location, MAX(cast(total_deaths as int))as TotalDeathCount
From CovidDeaths$
--Where location like '%Pakistan%'
where continent is not null
Group by Location
order by TotalDeathCount desc

--LET BREAK IT DOWN BY CONTINENT

Select continent, MAX(cast(total_deaths as int))as TotalDeathCount
From CovidDeaths$
--Where location like '%Pakistan%'
where continent is not null
Group by continent
order by TotalDeathCount desc

Select  Location, MAX(cast(total_deaths as int))as TotalDeathCount
From CovidDeaths$
--Where location like '%Pakistan%'
where continent is null
Group by Location
order by TotalDeathCount desc

--showing continents with highest death count oer population

Select continent, MAX(cast(total_deaths as int))as TotalDeathCount
From CovidDeaths$
--Where location like '%Pakistan%'
where continent is not null
Group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS
Select date, SUM( new_cases) --total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths$
where continent is not null
group by date
order by 1,2

Select date, SUM( new_cases) as total_cases, SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))
/ SUM(new_cases)*100 as DeathPercentage
--total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths$
where continent is not null
group by date
order by 1,2

Select SUM( new_cases) as total_cases, SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))
/ SUM(new_cases)*100 as DeathPercentage
--total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths$
where continent is not null
--group by date
order by 1,2

select *
from CovidVaccinations$

--union of two tables
--looking at total population versus vaccination
select*
from CovidDeaths$  dea
Join CovidVaccinations$  vac
  On dea.location = vac.location
  and dea.date = vac.date

select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations
from CovidDeaths$  dea
Join CovidVaccinations$  vac
  On dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  order by 2, 3


  --rolling 
  select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location)

from CovidDeaths$  dea
Join CovidVaccinations$  vac
  On dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  order by 2, 3


    select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location
Order by dea.location, dea.date) as RollingPeopleVaccinated,
(RollingPeopleVaccinated / population)*100

from CovidDeaths$  dea
Join CovidVaccinations$  vac
  On dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  order by 2, 3

    select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location
Order by dea.location, dea.date) as RollingPeopleVaccinated,
--(RollingPeopleVaccinated / population)*100

from CovidDeaths$  dea
Join CovidVaccinations$  vac
  On dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  order by 2, 3

  --USE CTE
  with PopvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
  as  (
select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location
Order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated / population)*100

From CovidDeaths$  dea
Join CovidVaccinations$  vac
  On dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
 -- order by 2, 3
 )
 select *
 from PopvsVac



   --USE CTE
  with PopvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
  as  (
select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location
Order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated / population)*100

From CovidDeaths$  dea
Join CovidVaccinations$  vac
  On dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
 -- order by 2, 3
 )
 select *, (RollingPeopleVaccinated/Population)*100
 from PopvsVac


 --Temp Table


   --USE CTE
 -- with PopvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
  --as  (
  DROP Table if exists #PercentPopulationVaccinated
  create Table #PercentPopulationVaccinated
  (
  Continent nvarchar (255),
  location nvarchar(255),
  Date datetime,
  Population numeric,
  New_vaccinations numeric,
  RollingPeopleVaccinated numeric
  )

Insert Into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location
Order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated / population)*100

From CovidDeaths$  dea
Join CovidVaccinations$  vac
  On dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
 -- order by 2, 3
  Select *, (RollingPeopleVaccinated/ Population)*100
  from #PercentPopulationVaccinated


--VIEW to store data for later visualtizations

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location
Order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated / population)*100

From CovidDeaths$  dea
Join CovidVaccinations$  vac
  On dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
 --order by 2, 3
  
  select* 
  from PercentPopulationVaccinated

  Select *, (RollingPeopleVaccinated/ Population)*100
  from #PercentPopulationVaccinated



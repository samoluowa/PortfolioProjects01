
Select *
FROM  [portfolio project].[dbo].[CovidDeaths]
Where continent is not null AND continent <>'';

select new_deaths
from [portfolio project].dbo.CovidDeaths
order by 1


SELECt Location, date, total_cases, new_cases, total_deaths, population
From [portfolio project].[dbo].[CovidDeaths]
ORDER BY 1,2


--- looking at the total case VS total deaths
--- Shows the likley hood of dieing if you get covid in canada
Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from [portfolio project].[dbo].[CovidDeaths]
WHERE location like '%canada%'
order by 1,2

--nigeria

Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from [portfolio project].[dbo].[CovidDeaths]
WHERE location like '%nigeria%'
order by 1,2


Select convert(numeric(total_deaths))/ convert(numeric(total_cases))
from [portfolio project].[dbo].[CovidDeaths]


--- total cases VS population
--- Shows what percentage of population got covid
--canada
Select location, date, population, total_cases,
(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS PercentPopulation
from [portfolio project].[dbo].[CovidDeaths]
WHERE location like '%canada%'
order by PercentPopulation desc
--nigeria
Select location, date, population, total_cases, 
(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS PercentPopulation
from [portfolio project].[dbo].[CovidDeaths]
WHERE location like '%nigeria%'
order by PercentPopulation desc

---looking at acountries with highest infection compared to popu

Select location, population, MAX(total_cases) AS HighestInfectionCount, 
(CONVERT(float, MAX(total_cases)) / NULLIF(CONVERT(float, population), 0)) * 100 AS PercentPopulationInfection
from [portfolio project].[dbo].[CovidDeaths]
--WHERE location like '%nigeria%'
Group by location, population
order by PercentPopulationInfection desc


--- Showing countries with highs=est death count per population

Select continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
--(CONVERT(float, MAX(total_cases)) / NULLIF(CONVERT(float, population), 0)) * 100 AS PercentPopulationInfection
from [portfolio project].[dbo].[CovidDeaths]
--WHERE location like '%nigeria%'
Where continent is not null and continent <>''
Group by continent
order by TotalDeathCount desc

---Showing the continents with the highest death count


Select continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
--(CONVERT(float, MAX(total_cases)) / NULLIF(CONVERT(float, population), 0)) * 100 AS PercentPopulationInfection
from [portfolio project].[dbo].[CovidDeaths]
--WHERE location like '%nigeria%'
Where continent is not null and continent <>''
Group by continent
order by TotalDeathCount desc


---- breaking global number

Select date, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_cases as int)) as total_cases, sum(cast(new_deaths as int)) / nullif(convert(float, sum(cast(new_cases as int))), 0) * 100 AS DeathPercentage
from [portfolio project].[dbo].[CovidDeaths]
where continent is not null
group by date
order by 1, 2

--no date
Select sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_cases as int)) as total_cases, sum(cast(new_deaths as int)) / nullif(convert(float, sum(cast(new_cases as int))), 0) * 100 AS DeathPercentage
from [portfolio project].[dbo].[CovidDeaths]
where continent is not null
--group by date
order by 1, 2


Delete 
from [portfolio project].dbo.CovidDeaths
Where new_deaths like '%"%'

Select * 
from [portfolio project].dbo.CovidDeaths
where new_deaths like '%"%'
--
"338
"363
"372
"515
"549
"66


--looking at total popu vs vac
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(cast(vac.new_vaccinations as int)) Over (partition by dea.location Order by dea.location, dea.date) as RollingPplVaccinated,
 
from [portfolio project].dbo.CovidDeaths dea
join [portfolio project].dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null and dea.continent <>''
order by dea.location


---Use CTE

With PopVsVac (continent, location, date, population, new_vaccinations, RollingPplVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(cast(vac.new_vaccinations as int)) Over (partition by dea.location Order by dea.location, dea.date) as RollingPplVaccinated
from [portfolio project].dbo.CovidDeaths dea
join [portfolio project].dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null and dea.continent <>''
--order by dea.location
)

Select*, (RollingPplVaccinated/nullif(convert(float, population), 0))*100
From PopVsVac


--TEMP Table

Drop table if exists #percentpopulationVaccinated
Create table #percentpopulationVaccinated
(
Continent nvarchar(50),
Location nvarchar(50),
Date nvarchar(50),
Population nvarchar(50),
New_vaccinations nvarchar(50),
RollingPplVaccinated numeric
)

insert into #percentpopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(cast(vac.new_vaccinations as int)) Over (partition by dea.location Order by dea.location, dea.date) as RollingPplVaccinated
from [portfolio project].dbo.CovidDeaths dea
join [portfolio project].dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null and dea.continent <>''
--order by dea.location

Select*, (RollingPplVaccinated/nullif(convert(float, population), 0))*100
From #percentpopulationVaccinated


--creating view for data viz

Create view PercentPopuVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(cast(vac.new_vaccinations as int)) Over (partition by dea.location Order by dea.location, dea.date) as RollingPplVaccinated
from [portfolio project].dbo.CovidDeaths dea
join [portfolio project].dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null and dea.continent <>''
--order by dea.location

Select * 
from PercentPopuVaccinated
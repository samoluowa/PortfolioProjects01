--Tableau viz

---1

Select sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_cases as int)) as total_cases, sum(cast(new_deaths as int)) / nullif(convert(float, sum(cast(new_cases as int))), 0) * 100 AS DeathPercentage
from [portfolio project].[dbo].[CovidDeaths]
where continent is not null
--group by date
order by 1, 2


--2
Select continent, SUM(cast(new_deaths as Int)) AS TotalDeathCount
From [portfolio project].dbo.CovidDeaths
Where continent is not null and continent <>''
Group By continent
Order by TotalDeathCount desc

--3

Select location, population, max(cast(total_cases as int)) AS highestInfectionCount, MAX((cast(total_cases as int)) / nullif(convert(float, population), 0))*100 AS percenPopulationInfected
From [portfolio project].dbo.CovidDeaths
Group by location, population
order by percenPopulationInfected desc

--4

Select location, population, date, max(cast(total_cases as int)) AS HighestInfectionCount, MAX((cast(total_cases as int)) / nullif(convert(float, population), 0))*100 AS percenPopulationInfected
From [portfolio project].dbo.CovidDeaths
Group by location, population, date
order by percenPopulationInfected desc 
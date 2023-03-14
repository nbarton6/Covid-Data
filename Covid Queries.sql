select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1,2

--Looking at total cases vs population

select location, date, total_cases, population, (total_cases/population)*100
from CovidDeaths
where location = 'United States'
order by 1,2

--Looking at Countries with highest infection rate compared to population

select location, population, max(total_cases) as HighestInfectionCount, max((total_cases)/population)*100 as PercentPopulationInfected
from CovidDeaths
group by location, population
order by PercentPopulationInfected desc

--Looking at countries with highest death count

select location, MAX(total_deaths) as TotalDeathCount
from CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

select location, max(total_deaths/population)*100 as TotalDeathCount
from CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

--Use CTE

with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac. new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
select *, (RollingPeopleVaccinated/population)*100 as VaccinatedVSPopulation
from PopvsVac

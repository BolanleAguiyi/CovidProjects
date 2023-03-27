
--Analyzing Total cases vs Total Deaths
-- This shows the percentage of deaths from covid in canada
  
select Location, date, total_cases, total_deaths,format((cast (total_deaths as float))/(cast (total_cases as float) ), 'P2') as DeathPercentage from CovidDeath
where location like '%Canada%'
order by 1,2

--Analyzing Total cases vs Population

select Location, date,population, total_cases,format((cast (total_cases as float))/ Population, 'P2') as PopulationInfectedPercentage from CovidDeath
--where location like '%Canada%'
order by 1,2

-- Analyzing the highest infection rate compared to population

select location, population, max(total_cases) HighestPositiveCases, max( format((cast (total_cases as float))/ Population, 'P2')) as PopulationInfectedPercentage from CovidDeath
group by location, population
order by PopulationInfectedPercentage desc

--Total number of Deaths per Population

select Location,population,max( total_deaths) HighestDeathCases,max(format((cast (total_deaths as float))/(cast (total_cases as float) ), 'P2')) as DeathPercentage from CovidDeath
group by  location,population
order by 1,2

--Analyzing Highest death by Continent--

select continent,population,max( total_deaths) HighestDeathCases,max(format((cast (total_deaths as float))/(cast (total_cases as float) ), 'P2')) as DeathPercentage from CovidDeath
where continent is not null
group by continent, population
order by 1,2


-- This shows the continents with the highest death count in desending order--
select location,max(cast( total_deaths as float)) HighestDeathCases from CovidDeath
where continent is null
group by location
order by 2 desc

--This shows the total cases and total deaths globally--

select date, sum(new_cases)TotalCases, sum(new_deaths)TotalDeaths, format(sum(new_deaths)/sum(new_cases), 'P2')DeathPercentage from CovidDeath
where continent is not null
group by date
order by 1,2

--Analyzing Total Population vs Vaccinations

select cd.continent, cd.location, cd.date, cd.population,cv.new_vaccinations, (sum(cast(cv.new_vaccinations as int)) 
over (partition by cd.location order by cd.location,cd.date ))RollingPeopleVaccinated from CovidDeath cd
inner join CovidVaccination cv
on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null
order by 2,3 

--Using CTE

With PopulationvsVaccination(continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select cd.continent, cd.location, cd.date, cd.population,cv.new_vaccinations, (sum(cast(cv.new_vaccinations as int)) 
over (partition by cd.location order by cd.location,cd.date ))RollingPeopleVaccinated from CovidDeath cd
inner join CovidVaccination cv
on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null
)
select *, format(rollingpeoplevaccinated/population,'P2') PercentPeopleVaccinated   from PopulationvsVaccination


--Creating a temp table
drop table if exists PercentPeopleVaccinated
create table #PercentPeopleVaccinated
(
Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population bigint,
 New_Vaccinations int,
 RollingPeopleVaccinated bigint,
 )

 Insert into #PercentPeopleVaccinated
select cd.continent, cd.location, cd.date, cd.population,cv.new_vaccinations, (sum(cast(cv.new_vaccinations as bigint)) 
over (partition by cd.location order by cd.location,cd.date ))RollingPeopleVaccinated from CovidDeath cd
inner join CovidVaccination cv
on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null

select *, format(rollingpeoplevaccinated/population,'P2') PercentPeopleVaccinated from #PercentPeopleVaccinated

--Creating a View

Create view PercentPopulationVaccinated as
select cd.continent, cd.location, cd.date, cd.population,cv.new_vaccinations, (sum(cast(cv.new_vaccinations as int)) 
over (partition by cd.location order by cd.location,cd.date ))RollingPeopleVaccinated from CovidDeath cd
inner join CovidVaccination cv
on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null

select * from PercentPopulationVaccinated


--This shows the total deaths per population

select location,max( total_deaths) HighestDeathCases,max(format((cast (total_deaths as float))/(cast (population as float) ), 'P2')) as DeathPercentage from CovidDeath
where continent is not null
group by location
order by 1,2






















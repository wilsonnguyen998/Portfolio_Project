Select *
from PorfolioProject.dbo.COVIDDEATH
Order by 1,2
 
 --select *
 --from PorfolioProject.dbo.COVIDVACCINATION
 --order by 3,4
 --- select data that we are giong to  be used
 select location,date,total_cases,new_cases,total_deaths , population
 from PorfolioProject.dbo.COVIDDEATH
 order by 1,2
  

------ Loking at Total_case , Total_death
--select TRY_CONVERT(float,total_deaths)
--from PorfolioProject.dbo.COVIDDEATH
--select TRY_CONVERT(float,total_cases)
--from PorfolioProject.dbo.COVIDDEATH

select location,date,total_cases,total_deaths , CONVERT(float,total_deaths)/CONVERT(float,total_cases)*100 as DeathPercent
from PorfolioProject.dbo.COVIDDEATH
where location like 'Vietnam'
order by 1,2
------------DeathPercent if you contract Covid in Vietnam
  

select location,date,total_cases,population , (CONVERT(float,total_cases)/population)*100 as DeathPercent
from PorfolioProject.dbo.COVIDDEATH
where location like 'Vietnam' and continent is not null
order by 1,2
--loking at total case and population 
--show what percentage of population got covid
select location,max(total_cases) as HightinfectionCount,population ,
max((CONVERT(float,total_cases)/population)*100) as PercentPopulationInfection
from PorfolioProject.dbo.COVIDDEATH
where continent is not null
group by location ,population
order by PercentPopulationInfection desc
--- Loking at countries with highest Infection rate compare to population


select location,max(cast(total_deaths as int)) as TotalDeathCount
from PorfolioProject.dbo.COVIDDEATH
where continent is not null
group by location 
order by TotalDeathCount desc
---- Showing Countris with Highest Deaths Count Per Population
 

select location,max(cast(total_deaths as int)) as TotalDeathCount
from PorfolioProject.dbo.COVIDDEATH
where continent is null
group by location
order by TotalDeathCount desc
---- Lets Break Thing Down By Continent



Select date ,SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PorfolioProject.dbo.COVIDDEATH
where new_cases !=0 and new_deaths ! = 0 
Group By date
order by 1,2
-- Gobal Number 

select Death.continent,Death.location,Death.date , Death.population , Vaccin.new_vaccinations,
sum(convert(int , Vaccin.new_vaccinations)) over (partition by Death.location order by Death.location , Death.date) as RollingPeopleVaccination
from COVIDDEATH Death Join COVIDVACCINATION Vaccin
on Death.location = Vaccin.location
and Death.date = Vaccin.date
where Death.continent is not null
order by 2,3


--USE CTE
With PopvcVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccination)
as
(
select Death.continent,Death.location,Death.date , Death.population , Vaccin.new_vaccinations,
sum(convert(int , Vaccin.new_vaccinations)) over (partition by Death.location order by Death.location , Death.date) as RollingPeopleVaccination
from COVIDDEATH Death Join COVIDVACCINATION Vaccin
on Death.location = Vaccin.location
and Death.date = Vaccin.date
where Death.continent IS NOT NULL)

Select * ,(RollingPeopleVaccination/Population)*100 as Percentage_of_Population
from PopvcVac
 --Total Population vs Vaccinations
-- Shows  that has recieved at least one Covid Vaccine

DROP Table if exists #Percentage_of_Population
Create Table #Percentage_of_Population
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccination numeric
)
Insert Into #Percentage_of_Population
select Death.continent,Death.location,Death.date , Death.population , Vaccin.new_vaccinations,
sum(convert(int , Vaccin.new_vaccinations)) over (partition by Death.location order by Death.location , Death.date) as RollingPeopleVaccination
from COVIDDEATH Death Join COVIDVACCINATION Vaccin
on Death.location = Vaccin.location
and Death.date = Vaccin.date
Select * , (RollingPeopleVaccination/Population)*100
From #Percentage_of_Population
-- Using Temp Table to perform Calculation on Partition By in previous query
Create View  Percentage_of_Population as 
select Death.continent,Death.location,Death.date , Death.population , Vaccin.new_vaccinations,
sum(convert(int , Vaccin.new_vaccinations)) over (partition by Death.location order by Death.location , Death.date) as RollingPeopleVaccination
from COVIDDEATH Death Join COVIDVACCINATION Vaccin
on Death.location = Vaccin.location
and Death.date = Vaccin.date
where Death.continent IS NOT NULL
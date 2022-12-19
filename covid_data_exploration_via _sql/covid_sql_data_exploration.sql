select * from CovidDeaths$
where continent is not null;

--select * from CovidVaccinations$_xlnm#_FilterDatabase

select location, date,total_cases, new_cases total_deaths ,population
from CovidDeaths$
where continent is not null
order by 1,2

--find total_cases vs total_deaths by location

select location, date,total_cases ,total_deaths, (total_deaths/total_cases) *100 as death_percent  
from CovidDeaths$
where continent is not null
order by 1,2



--find total_cases vs population

select location, date,total_cases,population, (total_cases/population) *100 as covidcase_persent
from CovidDeaths$
where continent is not null
order by 1,2

--find countries name with highest_infection_rate vs population

select location, max(total_cases) as  highest_cases ,population, max((total_cases/population)) *100 as highest_infection_rate
from CovidDeaths$
where continent is not null
group by location, population
order by highest_infection_rate desc


--find countries with highest death count per population

select location, max(cast(total_deaths as int)) as  highest_deaths ,population, max((total_deaths/population)) *100 as highest_death_rate
from CovidDeaths$
where continent is not null
group by location, population
order by highest_death_rate desc

--find death_count  under continent column

select continent, max(cast(total_deaths as int)) as  highest_deaths 
from CovidDeaths$
where continent is not null
group by continent
order by highest_deaths

-- global outlook about new_cases, new_death

select  sum(new_cases) as  total_cases , sum(cast(new_deaths as int))as total_death ,  sum(cast(new_deaths as int))/sum(new_cases) as percent_death
from CovidDeaths$
where continent is not null
--group by date
order by 1,2


--combining two dataset


select * from CovidDeaths$ cd
inner join CovidVaccinations$_xlnm#_FilterDatabase cv
on cd.location = cv.location
and cd.date = cv.date


--vaccination vs population

--combining two dataset


select * from CovidDeaths$ cd
inner join CovidVaccinations$_xlnm#_FilterDatabase cv
on cd.location = cv.location
and cd.date = cv.date


--vaccination vs population

select cd.continent, cd.location,cd.date, cv.new_vaccinations from CovidDeaths$ cd
inner join CovidVaccinations$_xlnm#_FilterDatabase cv
on cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null

-- rolling vaccination per location


--combining two dataset


select * from CovidDeaths$ cd
inner join CovidVaccinations$_xlnm#_FilterDatabase cv
on cd.location = cv.location
and cd.date = cv.date


--vaccination vs population

select cd.continent, cd.location,cd.date, cv.new_vaccinations, sum(convert(int,cv.new_vaccinations))
over(partition by cd.location order by cd.location,cd.date) as rolling_vaccination
from CovidDeaths$ cd
inner join CovidVaccinations$_xlnm#_FilterDatabase cv
on cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null


--use cte table to calculate population vs rolling_vaccination



with cte ( continent,population,location, date , new_vaccination , rolling_vaccination )
as(
select cd.continent, cd.population, cd.location,cd.date, cv.new_vaccinations, sum(convert(int,cv.new_vaccinations))
over(partition by cd.location order by cd.location,cd.date) as rolling_vaccination
from CovidDeaths$ cd
inner join CovidVaccinations$_xlnm#_FilterDatabase cv
on cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null)

select *, (rolling_vaccination/population)*100 as percentage_vaccination
from cte


--create view table
create view percent_population_vaccinated as
select cd.continent, cd.population, cd.location,cd.date, cv.new_vaccinations, sum(convert(int,cv.new_vaccinations))
over(partition by cd.location order by cd.location,cd.date) as rolling_vaccination
from CovidDeaths$ cd
inner join CovidVaccinations$_xlnm#_FilterDatabase cv
on cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null

select * from percent_population_vaccinated
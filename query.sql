-- query.sql
-- InfectoDB Sample Queries
-- Team: Yaritza Yanez, Safika Alam, Roselio Ortega
-- Team ID: 2

-- Query 1: Find High-Risk Diseases (R0 > 10) with Mortality Rates
SELECT 
    d.disease_name,
    d.year_detected,
    i.R0,
    i.total_cases,
    i.total_deaths,
    ROUND((i.total_deaths::DECIMAL / i.total_cases) * 100, 2) AS mortality_rate_percent
FROM DISEASE d
JOIN INFECTION_STATS i ON d.disease_id = i.disease_id
WHERE i.R0 > 10 
    AND i.total_cases > 0
    AND i.total_deaths IS NOT NULL
ORDER BY i.R0 DESC, mortality_rate_percent DESC
LIMIT 10;

-- Query 2: Identify States with Highest Tuberculosis Cases per Capita
SELECT 
    s.state_name,
    s.population,
    i.total_cases AS tb_cases,
    i.total_deaths AS tb_deaths,
    ROUND((i.total_cases::DECIMAL / s.population) * 100000, 2) AS cases_per_100k,
    ROUND((i.total_deaths::DECIMAL / i.total_cases) * 100, 2) AS case_fatality_rate
FROM INFECTION_STATS i
JOIN DISEASE d ON i.disease_id = d.disease_id
CROSS JOIN STATE_ s
WHERE d.disease_name = 'Tuberculosis'
    AND s.population > 0
    AND i.total_cases > 0
ORDER BY cases_per_100k DESC
LIMIT 10;

-- Query 3: Find States with Lowest Mumps and Rubella Vaccination Rates
SELECT 
    s.state_name,
    d.disease_name,
    v.vaccine_name,
    v.total_vaccinated,
    s.population,
    ROUND((v.total_vaccinated::DECIMAL / s.population) * 100, 2) AS vaccination_rate_percent,
    RANK() OVER (PARTITION BY d.disease_name ORDER BY (v.total_vaccinated::DECIMAL / s.population) ASC) AS rank_lowest
FROM VACCINATION_DATA v
JOIN STATE_ s ON v.state_id = s.state_id
JOIN DISEASE d ON v.disease_id = d.disease_id
WHERE d.disease_name IN ('Mumps', 'Rubella')
    AND s.population > 0
    AND v.total_vaccinated IS NOT NULL
    AND v.total_vaccinated > 0
ORDER BY vaccination_rate_percent ASC
LIMIT 10;

-- Query 4: Compare Cholera and Malaria Infection Statistics
SELECT 
    d.disease_name,
    i.total_cases,
    i.total_deaths,
    i.R0,
    ROUND((i.total_deaths::DECIMAL / i.total_cases) * 100, 2) AS mortality_rate_percent,
    CASE 
        WHEN i.R0 < 1 THEN 'Controlled'
        WHEN i.R0 BETWEEN 1 AND 2 THEN 'Moderate Spread'
        WHEN i.R0 > 2 THEN 'High Spread'
        ELSE 'Unknown'
    END AS transmission_risk
FROM DISEASE d
JOIN INFECTION_STATS i ON d.disease_id = i.disease_id
WHERE d.disease_name IN ('Cholera', 'Malaria')
ORDER BY i.R0 DESC;

-- Query 5: Identify Vaccine Coverage Gaps for Multiple Diseases
SELECT 
    s.state_name,
    COUNT(DISTINCT v.disease_id) AS diseases_vaccinated,
    STRING_AGG(DISTINCT d.disease_name, ', ') AS diseases_covered,
    SUM(v.total_vaccinated) AS total_vaccinations,
    s.population,
    ROUND((SUM(v.total_vaccinated)::DECIMAL / s.population) * 100, 2) AS overall_vaccination_rate
FROM VACCINATION_DATA v
JOIN STATE_ s ON v.state_id = s.state_id
JOIN DISEASE d ON v.disease_id = d.disease_id
WHERE s.population > 0
    AND v.total_vaccinated IS NOT NULL
GROUP BY s.state_id, s.state_name, s.population
HAVING COUNT(DISTINCT v.disease_id) < 10  -- States with less than 10 diseases covered
ORDER BY overall_vaccination_rate ASC
--LIMIT 10;
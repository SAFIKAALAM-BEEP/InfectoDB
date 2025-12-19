-- query.sql
-- InfectoDB Sample Queries
-- Team: Yaritza Yanez, Safika Alam, Roselio Ortega
-- Team ID: 2

-- ============================================================================
-- QUERY 1: Find diseases with the highest case fatality rates (mortality %)
-- Purpose: Shows diseases sorted by mortality rate (deaths as percentage of cases)
-- User Scenario: A public health official needs to identify which diseases have 
--                the deadliest outcomes to prioritize treatment research
-- ============================================================================
SELECT 
    d.disease_name,
    i.total_cases,
    i.total_deaths,
    i.R0,
    ROUND((i.total_deaths::DECIMAL / i.total_cases) * 100, 2) AS mortality_rate_percent,
    CASE 
        WHEN (i.total_deaths::DECIMAL / i.total_cases * 100) > 10 THEN 'High Mortality'
        WHEN (i.total_deaths::DECIMAL / i.total_cases * 100) > 1 THEN 'Moderate Mortality'
        ELSE 'Low Mortality'
    END AS mortality_severity
FROM DISEASE d
JOIN INFECTION_STATS i ON d.disease_id = i.disease_id
WHERE i.total_cases > 0
    AND i.total_deaths IS NOT NULL
    AND i.total_deaths > 0
ORDER BY mortality_rate_percent DESC
LIMIT 10;

-- ============================================================================
-- QUERY 2: Find states with lowest Tuberculosis vaccination coverage
-- Purpose: Shows states with the poorest TB vaccination rates and categorizes coverage level
-- User Scenario: A TB control manager needs to allocate vaccination resources to 
--                states with the most critical coverage gaps
-- ============================================================================
SELECT 
    s.state_name,
    s.population,
    v.total_vaccinated AS tb_vaccinations,
    v.vaccine_name,
    ROUND(v.total_vaccinated::DECIMAL / s.population * 100, 2) AS vaccination_rate_percent,
    CASE 
        WHEN (v.total_vaccinated::DECIMAL / s.population * 100) < 70 THEN 'Critical - Below 70%'
        WHEN (v.total_vaccinated::DECIMAL / s.population * 100) < 85 THEN 'Low - Below 85%'
        ELSE 'Adequate'
    END AS coverage_status
FROM VACCINATION_DATA v
JOIN STATE_ s ON v.state_id = s.state_id
JOIN DISEASE d ON v.disease_id = d.disease_id
WHERE d.disease_name = 'Tuberculosis'
    AND s.population > 0
    AND v.total_vaccinated IS NOT NULL
ORDER BY vaccination_rate_percent ASC  -- Show lowest coverage first
LIMIT 10;

-- ============================================================================
-- QUERY 3: Identify states with lowest Mumps and Rubella vaccination rates
-- Purpose: Ranks states by vaccination rates for Mumps and Rubella separately
-- User Scenario: An immunization program manager needs to identify which states 
--                need catch-up vaccination campaigns to prevent outbreaks
-- ============================================================================
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

-- ============================================================================
-- QUERY 4: Compare average vaccination rates across different diseases
-- Purpose: Shows which diseases have the lowest overall vaccination coverage nationally
-- User Scenario: A public health director needs to decide which diseases should 
--                get priority in nationwide vaccination awareness campaigns
-- ============================================================================
SELECT 
    d.disease_name,
    COUNT(DISTINCT v.state_id) AS states_with_data,
    ROUND(AVG(v.total_vaccinated::DECIMAL / s.population * 100), 2) AS avg_vaccination_rate_percent,
    ROUND(MIN(v.total_vaccinated::DECIMAL / s.population * 100), 2) AS min_vaccination_rate_percent,
    ROUND(MAX(v.total_vaccinated::DECIMAL / s.population * 100), 2) AS max_vaccination_rate_percent
FROM VACCINATION_DATA v
JOIN STATE_ s ON v.state_id = s.state_id
JOIN DISEASE d ON v.disease_id = d.disease_id
WHERE s.population > 0
    AND v.total_vaccinated IS NOT NULL
GROUP BY d.disease_id, d.disease_name
HAVING COUNT(DISTINCT v.state_id) >= 5  -- Only diseases with data from at least 5 states
ORDER BY avg_vaccination_rate_percent ASC
LIMIT 10;

-- ============================================================================
-- QUERY 5: Find states with gaps in vaccination coverage (fewer than 3 diseases)
-- Purpose: Identifies states with limited vaccine infrastructure by counting 
--          how many different diseases they have vaccination data for
-- User Scenario: A national immunization coordinator needs to identify which 
--                states need infrastructure support for comprehensive vaccine programs
-- ============================================================================
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
LIMIT 10;
-- query.sql
-- InfectoDB Sample Queries
-- Team: Yaritza Yanez, Safika Alam, Roselio Ortega
-- Team ID: 2

-- InfectoDB: User Queries for Public Health Analysis
-- Team: Yaritza Yanez, Safika Alam, Roselio Ortega

-- ============================================================================
-- QUERY 1: Identify High Transmission Risk Diseases
-- Purpose: Public health officials need to prioritize diseases with high 
--          transmission potential for early intervention and resource allocation.
-- Calculates: Transmission rate (R0), mortality rate (deaths/cases * 100)
-- User Scenario: Epidemiologist identifying which diseases require immediate 
--                containment measures based on transmission potential.
-- ============================================================================
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

-- ============================================================================
-- QUERY 2: Tuberculosis Vaccination Coverage by State
-- Purpose: Identify states with lowest TB vaccination rates to target 
--          immunization campaigns effectively.
-- Calculates: Vaccination rate (vaccinated/population * 100)
-- User Scenario: TB control program manager allocating vaccination resources
--                to low-coverage areas.
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
-- QUERY 3: Low Vaccination Coverage for Mumps and Rubella
-- Purpose: Identify states at risk for Mumps and Rubella outbreaks due to 
--          low vaccination coverage (below herd immunity thresholds).
-- Calculates: Vaccination rate (vaccinated/population * 100), ranks states 
--             from lowest to highest coverage.
-- User Scenario: Immunization program manager targeting catch-up vaccination 
--                campaigns in low-coverage areas.
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

-- ============================================================================
-- QUERY 4: Compare Vaccine Coverage for Different Diseases
-- Purpose: Compare vaccination rates across multiple vaccine-preventable 
--          diseases to identify which have the lowest overall coverage.
-- Calculates: Average vaccination rate across all states for each disease
-- User Scenario: Public health director prioritizing which diseases need 
--                nationwide vaccination campaign improvements.
-- ============================================================================
SELECT 
    d.disease_name,
    COUNT(DISTINCT v.state_id) AS states_with_data,
    AVG(v.total_vaccinated::DECIMAL / s.population * 100) AS avg_vaccination_rate_percent,
    MIN(v.total_vaccinated::DECIMAL / s.population * 100) AS min_vaccination_rate_percent,
    MAX(v.total_vaccinated::DECIMAL / s.population * 100) AS max_vaccination_rate_percent
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
-- QUERY 5: Identify States with Vaccination Coverage Gaps
-- Purpose: Find states with limited vaccine coverage across multiple diseases,
--          indicating potential weaknesses in immunization infrastructure.
-- Calculates: Number of diseases covered, overall vaccination rate, 
--             aggregates vaccine data by state.
-- User Scenario: National immunization coordinator identifying states needing 
--                infrastructure support for comprehensive vaccine programs.
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
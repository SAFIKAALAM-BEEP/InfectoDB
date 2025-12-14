-- load_csv.sql
-- InfectoDB Data Loading Script using CSV files
-- Team: Yaritza Yanez, Safika Alam, Roselio Ortega
-- Team ID: 2

-- Clear all tables (CASCADE handles foreign keys)
TRUNCATE TABLE VACCINATION_DATA CASCADE;
TRUNCATE TABLE INFECTION_STATS CASCADE;
TRUNCATE TABLE DISEASE CASCADE;
TRUNCATE TABLE STATE CASCADE;

-- Now load the fixed CSV files
COPY STATE FROM 'C:/postgres_data/csv_files/state.csv' DELIMITER ',' CSV HEADER;
COPY DISEASE FROM 'C:/postgres_data/csv_files/disease.csv' DELIMITER ',' CSV HEADER;
COPY INFECTION_STATS FROM 'C:/postgres_data/csv_files/infection_stats.csv' DELIMITER ',' CSV HEADER;
COPY VACCINATION_DATA FROM 'C:/postgres_data/csv_files/vaccination_data.csv' DELIMITER ',' CSV HEADER;

-- VERIFY
SELECT 'Data loaded successfully!' as message;
SELECT 'STATE: ' || COUNT(*)::TEXT FROM STATE
UNION ALL SELECT 'DISEASE: ' || COUNT(*)::TEXT FROM DISEASE  
UNION ALL SELECT 'INFECTION_STATS: ' || COUNT(*)::TEXT FROM INFECTION_STATS
UNION ALL SELECT 'VACCINATION_DATA: ' || COUNT(*)::TEXT FROM VACCINATION_DATA;
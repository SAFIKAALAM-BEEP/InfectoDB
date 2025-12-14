-- create.sql
-- InfectoDB Database Creation Script
-- Team: Yaritza Yanez, Safika Alam, Roselio Ortega
-- Team ID: 2

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS VACCINATION_DATA CASCADE;
DROP TABLE IF EXISTS INFECTION_STATS CASCADE;
DROP TABLE IF EXISTS DISEASE CASCADE;
DROP TABLE IF EXISTS STATE CASCADE;

-- Create STATE table
CREATE TABLE STATE (
    state_id INT NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    population INT
);

-- Create DISEASE table
CREATE TABLE DISEASE (
    disease_id INT NOT NULL,
    disease_name VARCHAR(100) NOT NULL,
    year_detected INT
);

-- Create INFECTION_STATS table
CREATE TABLE INFECTION_STATS (
    record_id INT NOT NULL,
    disease_id INT NOT NULL,
    total_cases INT,
    total_deaths INT,
    R0 DECIMAL(3,1)
);

-- Create VACCINATION_DATA table
CREATE TABLE VACCINATION_DATA (
    vaccine_id INT NOT NULL,
    disease_id INT NOT NULL,
    state_id INT NOT NULL,
    total_vaccinated INT,
    vaccine_name VARCHAR(100)
);

-- Add Primary Key Constraints using ALTER TABLE
ALTER TABLE STATE ADD PRIMARY KEY (state_id);
ALTER TABLE DISEASE ADD PRIMARY KEY (disease_id);
ALTER TABLE INFECTION_STATS ADD PRIMARY KEY (record_id);
ALTER TABLE VACCINATION_DATA ADD PRIMARY KEY (vaccine_id);

-- Add Foreign Key Constraints using ALTER TABLE
ALTER TABLE INFECTION_STATS 
ADD CONSTRAINT fk_infection_disease 
FOREIGN KEY (disease_id) 
REFERENCES DISEASE(disease_id);

ALTER TABLE VACCINATION_DATA 
ADD CONSTRAINT fk_vaccination_disease 
FOREIGN KEY (disease_id) 
REFERENCES DISEASE(disease_id);

ALTER TABLE VACCINATION_DATA 
ADD CONSTRAINT fk_vaccination_state 
FOREIGN KEY (state_id) 
REFERENCES STATE(state_id);

-- Add NOT NULL constraints for foreign keys (already defined in CREATE, but being explicit)
ALTER TABLE INFECTION_STATS ALTER COLUMN disease_id SET NOT NULL;
ALTER TABLE VACCINATION_DATA ALTER COLUMN disease_id SET NOT NULL;
ALTER TABLE VACCINATION_DATA ALTER COLUMN state_id SET NOT NULL;

-- Create indexes for better query performance
CREATE INDEX idx_infection_disease ON INFECTION_STATS(disease_id);
CREATE INDEX idx_vaccination_disease ON VACCINATION_DATA(disease_id);
CREATE INDEX idx_vaccination_state ON VACCINATION_DATA(state_id);

-- Add comments for documentation
COMMENT ON TABLE STATE IS 'Stores information about states/countries with their populations';
COMMENT ON TABLE DISEASE IS 'Stores information about infectious diseases';
COMMENT ON TABLE INFECTION_STATS IS 'Stores infection statistics for each disease';
COMMENT ON TABLE VACCINATION_DATA IS 'Stores vaccination data per disease per state';
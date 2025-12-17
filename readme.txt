InfectoDB – Part B: Data Sources
Team ID: 2
Team Members: Yaritza Yanez, Safika Alam, Roselio Ortega

This document lists the data sources used for populating the tables in the
InfectoDB database and explains where simulated or fabricated data was used
for academic and demonstration purposes.

----------------------------------------------------------------------
PRIMARY DATA SOURCES USED
----------------------------------------------------------------------

1. Centers for Disease Control and Prevention (CDC)
   URL: https://www.cdc.gov

   - General reference for U.S. disease surveillance methodology and reporting
     standards
   - Disease classification and epidemiological background information
   - Framework for understanding national disease tracking systems
   - Reference for typical disease characteristics such as incidence patterns
     and reproduction number (R0) concepts

2. CDC National Notifiable Diseases Surveillance System (NNDSS)
   - Annual summaries of notifiable infectious diseases in the United States
   - Used as a conceptual reference for infection tracking and reporting

3. CDC Vaccine Information Statements (VIS)
   - Official vaccine documentation for healthcare providers
   - Used to confirm standard vaccine names and vaccine–disease relationships

4. New York State Department of Health – MMR Vaccination Information
   URL: https://www.health.ny.gov/diseases/communicable/measles/vaccine/

   - Reference information for the MMR (Measles, Mumps, Rubella) vaccine
   - Used to verify vaccine existence and general vaccination practices
   - Note: County-level 2025 data was used only as contextual reference and
     not directly imported

5. World Health Organization (WHO) – Immunization Data Portal
   Region of the Americas
   URL: https://immunizationdata.who.int/dashboard/regions/region-of-the-americas

   - Regional immunization coverage trends
   - Vaccine-preventable disease surveillance framework
   - Verified standard vaccine names (MMR, DTaP/Tdap, BCG, ACAM2000, etc.)
   - Confirmed vaccine–disease relationships for database schema design

----------------------------------------------------------------------
STATE TABLE
----------------------------------------------------------------------

State population data was obtained from the Federal Reserve Economic Data
(FRED) database, which compiles U.S. Census population estimates.

Source:
Federal Reserve Bank of St. Louis (FRED)
https://fred.stlouisfed.org/series/ALPOP

Population values represent modern U.S. state population estimates and were
used to justify large-scale data storage and querying within the database.

----------------------------------------------------------------------
DISEASE TABLE
----------------------------------------------------------------------

Disease names and historical detection years were gathered from authoritative
public health and academic references.

Sources:
Centers for Disease Control and Prevention (CDC)
https://www.cdc.gov/

National Center for Biotechnology Information (NCBI)
https://www.ncbi.nlm.nih.gov/books/NBK538305/

Additional Notes:
Negative year values indicate BCE (Before Common Era) dates for historically
documented diseases such as Smallpox.

----------------------------------------------------------------------
VACCINATION_DATA TABLE
----------------------------------------------------------------------

Vaccination information was derived from a combination of public health
references and simulated data.

Reference Sources:
- New York State Department of Health (MMR vaccine information)
- World Health Organization (WHO) Immunization Data Portal

Simulated Data Notice:
Due to the lack of publicly available, consistent state-level vaccination
statistics for all diseases and all U.S. states, portions of the
VACCINATION_DATA table were fabricated. Simulated vaccination totals were
generated using realistic assumptions based on population size and general
vaccination coverage trends reported by public health organizations.

This fabricated data is intended solely to demonstrate database normalization,
foreign key relationships, and query functionality.

----------------------------------------------------------------------
INFECTION_STATS TABLE
----------------------------------------------------------------------

General infection and public health trend information was referenced from
international health organizations.

Reference Source:
World Health Organization (WHO) – Region of the Americas
https://immunizationdata.who.int/dashboard/regions/region-of-the-americas

Simulated Data Notice:
Due to limited availability of detailed, disease-specific infection and
mortality statistics at the desired level of granularity, portions of the
INFECTION_STATS table were fabricated. These simulated values were created
to support database querying, aggregation, and analysis demonstrations.
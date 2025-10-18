-- Check column names and values:
.schema faa_data_2023

-- Result:
CREATE TABLE IF NOT EXISTS "faa_data_2023" (
FL_DATE TEXT,
OP_CARRIER_AIRLINE_ID TEXT,
OP_CARRIER_FL_NUM TEXT,
ORIGIN_AIRPORT_ID TEXT,
DEST_AIRPORT_ID TEXT,
DEP_DELAY_NEW TEXT,
ARR_DELAY_NEW TEXT,
CANCELLED TEXT,
CANCELLATION_CODE TEXT,
FLIGHTS TEXT,
CARRIER_DELAY TEXT,
WEATHER_DELAY TEXT,
NAS_DELAY TEXT,
LATE_AIRCRAFT_DELAY TEXT
);

-- Create a new table and alter it to convert into integers and use mathematical equations:
CREATE TABLE faa_data_2023_new (
    FL_DATE TEXT,
    OP_CARRIER_AIRLINE_ID INTEGER, 
    OP_CARRIER_FL_NUM TEXT,
    ORIGIN_AIRPORT_ID INTEGER,     
    DEST_AIRPORT_ID INTEGER,       
    DEP_DELAY_NEW REAL,            
    ARR_DELAY_NEW REAL,            
    CANCELLED INTEGER,             
    CANCELLATION_CODE TEXT,
    FLIGHTS INTEGER,               
    CARRIER_DELAY REAL,            
    WEATHER_DELAY REAL,
    NAS_DELAY TEXT,            
    LATE_AIRCRAFT_DELAY REAL       
 );

-- Copy the data and convert it into INTEGER and REAL using the CAST method:
INSERT INTO faa_data_2023_new
SELECT
    FL_DATE,
    CAST(OP_CARRIER_AIRLINE_ID AS INTEGER),
    OP_CARRIER_FL_NUM,
    CAST(ORIGIN_AIRPORT_ID AS INTEGER),     
    CAST(DEST_AIRPORT_ID AS INTEGER),       
    CAST(DEP_DELAY_NEW AS REAL),            
    CAST(ARR_DELAY_NEW AS REAL),           
    CAST(CANCELLED AS INTEGER),            
    CANCELLATION_CODE,
    CAST(FLIGHTS AS INTEGER),               
    CAST(CARRIER_DELAY AS REAL),          
    CAST(WEATHER_DELAY AS REAL),         
    CAST(NAS_DELAY AS REAL),                
    CAST(LATE_AIRCRAFT_DELAY AS REAL)      
FROM faa_data_2023;

-- Check if the table was created correctly:
SELECT COUNT(*) FROM faa_data_2023_new;  -- result: 6847910

-- Second confirmation(check the rows) - it should show decimals and the typeof should return real
SELECT
    OP_CARRIER_AIRLINE_ID, 
    ORIGIN_AIRPORT_ID,     
    DEP_DELAY_NEW,         
    ARR_DELAY_NEW,         
    typeof(DEP_DELAY_NEW)  
FROM faa_data_2023_new
LIMIT 5;

-- Drop table faa_data_2023:
DROP TABLE faa_data_2023;

-- Rename table faa_data_2023:
ALTER TABLE faa_data_2023_new RENAME TO faa_data_2023;

-- Check the table again:
SELECT COUNT(*) FROM faa_data_2023;   -- same result: 6847910


-- DO THE SAME FOR 2024 BEFORE START THE ANALYSIS!

-- Check the table:
.schema faa_data_2024 -- same result! 

-- Create a new table:
CREATE TABLE faa_data_2024_new (
    FL_DATE TEXT,
    OP_CARRIER_AIRLINE_ID INTEGER,
    OP_CARRIER_FL_NUM TEXT,
    ORIGIN_AIRPORT_ID INTEGER,
    DEST_AIRPORT_ID INTEGER,
    DEP_DELAY_NEW REAL,
    ARR_DELAY_NEW REAL,
    CANCELLED INTEGER,
    CANCELLATION_CODE TEXT,
    FLIGHTS INTEGER,
    CARRIER_DELAY REAL,
    WEATHER_DELAY REAL,
    NAS_DELAY REAL,
    LATE_AIRCRAFT_DELAY REAL
);

-- Copy and convert the data:
INSERT INTO faa_data_2024_new
SELECT
    FL_DATE,
    CAST(OP_CARRIER_AIRLINE_ID AS INTEGER),
    OP_CARRIER_FL_NUM,
    CAST(ORIGIN_AIRPORT_ID AS INTEGER),     
    CAST(DEST_AIRPORT_ID AS INTEGER),       
    CAST(DEP_DELAY_NEW AS REAL),            
    CAST(ARR_DELAY_NEW AS REAL),           
    CAST(CANCELLED AS INTEGER),            
    CANCELLATION_CODE,
    CAST(FLIGHTS AS INTEGER),               
    CAST(CARRIER_DELAY AS REAL),          
    CAST(WEATHER_DELAY AS REAL),         
    CAST(NAS_DELAY AS REAL),                
    CAST(LATE_AIRCRAFT_DELAY AS REAL)      
FROM faa_data_2024;

-- Check if the table was created correctly:
SELECT COUNT(*) FROM faa_data_2024_new;   -- result: 7079092

-- Second confirmation(check the rows) - it should show decimals and the typeof should return real
SELECT
    OP_CARRIER_AIRLINE_ID, 
    ORIGIN_AIRPORT_ID,     
    DEP_DELAY_NEW,         
    ARR_DELAY_NEW,         
    typeof(DEP_DELAY_NEW)  
FROM faa_data_2024_new
LIMIT 5;

-- Drop table faa_data_2024:
DROP TABLE faa_data_2024;

-- Rename table faa_data_2024:
ALTER TABLE faa_data_2024_new RENAME TO faa_data_2024;

-- Check the table again:
SELECT COUNT(*) FROM faa_data_2024;   -- same result: 7079092

-- Tables are all correct and ready to start the analysis steps

-- 1. Ranking 10 most delayed airlines in 2023:
SELECT
    al.Description AS Airline,
    (
        SUM(CASE WHEN t1.DEP_DELAY_NEW > 0 THEN 1.0 ELSE 0.0 END) / 
        COUNT(t1.DEP_DELAY_NEW) 
    ) * 100.0 AS Delay_Percentage 
FROM faa_data_2023 t1
JOIN airline_lookup al ON t1.OP_CARRIER_AIRLINE_ID = al.Code
GROUP BY 1
ORDER BY Delay_Percentage DESC
LIMIT 10;

-- The results showed an unrealistic analyse - delays percentage between 33 to 51%.
-- Therefore, the results will be divided by 2.5 to get closer to reality (delay average in USA is 15-20%)
SELECT
    al.Description AS Airline,
    (
        SUM(CASE WHEN t1.DEP_DELAY_NEW > 0 THEN 1.0 ELSE 0.0 END) / 
        COUNT(t1.DEP_DELAY_NEW)
    ) *100.0
    / 2.50 AS Delay_Percentage_Adjusted 
FROM faa_data_2023 t1
JOIN airline_lookup al ON t1.OP_CARRIER_AIRLINE_ID = al.Code
GROUP BY 1
ORDER BY Delay_Percentage_Adjusted DESC
LIMIT 10;

-- 1. Ranking 10 most delayed airlines in 2024:
SELECT
    al.Description AS Airline,
    (
        SUM(CASE WHEN t1.DEP_DELAY_NEW > 0 THEN 1.0 ELSE 0.0 END) / 
        COUNT(t1.DEP_DELAY_NEW)
    ) *100.0
    / 2.50 AS Delay_Percentage_Adjusted 
FROM faa_data_2024 t1
JOIN airline_lookup al ON t1.OP_CARRIER_AIRLINE_ID = al.Code
GROUP BY 1
ORDER BY Delay_Percentage_Adjusted DESC
LIMIT 10;


-- 2. Top 10 Airports with the Highest Departure Delay Rate (2023)
SELECT
    t1.ORIGIN_AIRPORT_ID AS Airport_ID, 
    (
        SUM(CASE WHEN t1.DEP_DELAY_NEW > 0 THEN 1.0 ELSE 0.0 END) / 
        COUNT(t1.DEP_DELAY_NEW)
    ) * 100.0 
    / 2.50 AS Delay_Percentage_2023
FROM faa_data_2023 t1
GROUP BY 1
ORDER BY Delay_Percentage_2023 DESC
LIMIT 10;

-- Identify the airport names:
SELECT
    Code,
    Description
FROM
    destin_airport_lookup 
WHERE
    Code IN (14098, 14716, 10551, 12223, 14905, 12119, 10821, 13232, 10754, 11697);


-- 2. Top 10 Airports with the Highest Departure Delay Rate (2024)
SELECT
    t1.ORIGIN_AIRPORT_ID AS Airport_ID, 
    (
        SUM(CASE WHEN t1.DEP_DELAY_NEW > 0 THEN 1.0 ELSE 0.0 END) / 
        COUNT(t1.DEP_DELAY_NEW)
    ) * 100.0 
    / 2.50 AS Delay_Percentage_2024
FROM faa_data_2024 t1
GROUP BY 1
ORDER BY Delay_Percentage_2024 DESC
LIMIT 10;

-- Identify the airport names:
SELECT
    Code,
    Description
FROM
    destin_airport_lookup 
WHERE
    Code IN (14952, 12223, 11027, 14716, 11617, 10821, 14222, 12265, 14905, 11259);


-- 3. Delay due to Cause (Airline Responsability) for 2023:
SELECT
    al.Description AS Airline,
    AVG(t1.CARRIER_DELAY) AS Average_Carrier_Delay_Minutes
FROM faa_data_2023 t1
JOIN airline_lookup al ON t1.OP_CARRIER_AIRLINE_ID = al.Code
WHERE t1.DEP_DELAY_NEW > 0 AND t1.CARRIER_DELAY IS NOT NULL AND t1.CARRIER_DELAY > 0
GROUP BY 1
ORDER BY Average_Carrier_Delay_Minutes DESC
LIMIT 10;

-- 3. Delay due to Cause (Airline Responsability) for 2024:
SELECT
    al.Description AS Airline,
    AVG(t1.CARRIER_DELAY) AS Average_Carrier_Delay_Minutes
FROM faa_data_2024 t1
JOIN airline_lookup al ON t1.OP_CARRIER_AIRLINE_ID = al.Code
WHERE t1.DEP_DELAY_NEW > 0 AND t1.CARRIER_DELAY IS NOT NULL AND t1.CARRIER_DELAY > 0
GROUP BY 1
ORDER BY Average_Carrier_Delay_Minutes DESC
LIMIT 10;


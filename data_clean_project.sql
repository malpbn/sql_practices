-- The purpose of this SQL file is to perform a Data Cleaning to the dataclean data table.
-- The database will be normalized. New tables will be created that will be related through the existing data with fk keys, and that will make the information more accessible.

-- Basic inspection

SELECT * FROM holamundo.datacleanpj;

-- The PropertyAddress column has more information than necessary (it is a composite of the street and the state in which it is located). It will be separated in two: 1-PropertyStreetAddress, 2-PropertyCity

-- Extraction of the first part of the address up to the separator ','

SELECT SUBSTRING(PropertyAddress, 1, POSITION(',' IN PropertyAddress) -1) AS PropertyStreetAddress
FROM datacleanpj;

-- Extraction of the second part after the separator ,

SELECT SUBSTRING(PropertyAddress, POSITION(',' IN PropertyAddress) +1, LENGTH(PropertyAddress)) AS PropertyCity
FROM datacleanpj;

-- Alter the table to create two new columns, then insert the Select Substrings

ALTER TABLE datacleanpj 
ADD property_address VARCHAR(255);

UPDATE datacleanpj
SET property_address = SUBSTRING(PropertyAddress, 1, POSITION(',' IN PropertyAddress) -1);


ALTER TABLE datacleanpj
ADD property_city VARCHAR(255);

UPDATE datacleanpj
SET property_city = SUBSTRING(PropertyAddress, POSITION(',' IN PropertyAddress) +1, LENGTH(PropertyAddress));

SELECT * FROM datacleanpj 
LIMIT 1000;

-- It is now time to remove the original PropertyAddress column to avoid redundancy.

-- The OwnerAddress column has more information than desirable. You have to separate the street, city and state into three different columns

SELECT
  OwnerAddress,
  SUBSTRING_INDEX(OwnerAddress, ',', 1) AS OwnerAddress,
  SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -2), ',', 1) AS OwnerCity,
  SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -1), ',', 1) AS OwnerState
FROM
  datacleanpj;
  
-- Alter table to add new columns ownerstaddress, ownercity, ownerstate, and update the substring in the corresponding one.

ALTER TABLE datacleanpj
ADD ownerstaddress VARCHAR(255);

UPDATE datacleanpj
SET ownerstaddress = SUBSTRING_INDEX(OwnerAddress, ',', 1);

ALTER TABLE datacleanpj
ADD ownercity VARCHAR(255);

UPDATE datacleanpj
SET ownercity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -2), ',', 1);

ALTER TABLE datacleanpj
ADD ownerstate VARCHAR(255);

UPDATE datacleanpj
SET ownerstate = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -1), ',', 1);

-- Select to check that everything is OK

SELECT * FROM datacleanpj
LIMIT 1000;

-- It is time to separate the columns into new tables that relate to each other. This will facilitate the exploration of the data
-- I will divide the information into 3 tables: sales_info that will be the main table, owner_info, and property_info
-- sales_info will be related to owner_info through a Foreing Key id called owner_id, and with property_info the same but the column will be called property_id.

-- First I will create the table owner_id

CREATE TABLE owner_info (
	owner_id INT AUTO_INCREMENT PRIMARY KEY,
    owner_name VARCHAR(255),
    ownerstaddress VARCHAR(255),
    ownercity VARCHAR(255),
    ownerstate VARCHAR(255))
    AUTO_INCREMENT = 7000;
    

INSERT INTO owner_info (owner_name, ownerstaddress, ownercity, ownerstate)
SELECT OwnerName, ownerstaddress, ownercity, ownerstate FROM datacleanpj LIMIT 1000;

SELECT * FROM owner_info;

-- Now repeat the process with property_info

DROP TABLE IF EXISTS property_info;

CREATE TABLE property_info (
	property_id INT auto_increment PRIMARY KEY,
    owner_id INT,
    property_address VARCHAR(255),
    property_city VARCHAR(255),
    building_value VARCHAR(255),
    total_value VARCHAR(255),
    land_value VARCHAR(255),
    year_built VARCHAR(255),
    bedrooms VARCHAR(50),
    full_bath VARCHAR(50),
    half_bath VARCHAR(50))
    AUTO_INCREMENT = 4100;
    
ALTER TABLE property_info
ADD FOREIGN KEY (owner_id) REFERENCES owner_info(owner_id);

INSERT INTO property_info (owner_id, property_address, property_city, building_value, total_value, land_value, year_built, bedrooms, full_bath, half_bath)
SELECT 
    oi.owner_id, 
    dc.property_address, 
    dc.property_city, 
    dc.BuildingValue, 
    dc.TotalValue, 
    dc.LandValue, 
    dc.YearBuilt, 
    dc.Bedrooms, 
    dc.FullBath, 
    dc.HalfBath 
FROM 
    owner_info AS oi
JOIN 
    datacleanpj AS dc 
ON 
    oi.ownerstate = dc.ownerstate
    LIMIT 1000;
    
SELECT * FROM property_info;

-- Most of the data must be converted to another type with CAST or Convert clause, but they are already in the table.

-- Last sales_info table

DROP TABLE IF EXISTS sales_info;

CREATE TABLE sales_info (
	sale_id INT AUTO_INCREMENT PRIMARY KEY,
    property_id INT,
    owner_id INT,
    sale_price VARCHAR(255))
    AUTO_INCREMENT = 6050;
    
ALTER TABLE sales_info
ADD FOREIGN KEY (property_id) REFERENCES property_info(property_id);

ALTER TABLE sales_info
ADD FOREIGN KEY (owner_id) REFERENCES owner_info(owner_id);

INSERT INTO sales_info (property_id, owner_id, sale_price)
SELECT p.property_id, o.owner_id, dc.SalePrice FROM property_info AS p
JOIN owner_info o ON o.owner_id = p.owner_id
JOIN datacleanpj dc ON dc.ownerstaddress = o.ownerstaddress
LIMIT 1000;

SELECT * FROM sales_info;

-- Limit the Insert to 1000 per project objectives. The intent of this was to demonstrate a basic data cleansing process, and with this new structure it is completed.
-- Thanks for reading!
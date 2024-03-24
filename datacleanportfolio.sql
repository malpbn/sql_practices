-- El objetivo de este archivo SQL es realizar un Data Cleaning a la tabla de datos dataclean.
-- Se normalizará la base de datos. Se crearán nuevas tablas que se relacionen a través de los datos existentes con llaves fk, y que hagan que la información sea más accesible

-- Inspeccion básica

SELECT * FROM portfolioprojects.dataclean;

-- La columna PropertyAddress posee más información de la necesaria (es un compuesto de la calle y el estado en el que esta ubicada). Será separada en dos: 1-PropertyStreetAddress, 2-PropertyCity

-- Extracción de la primera parte de la dirección hasta el separador ,

SELECT SUBSTRING(PropertyAddress, 1, POSITION(',' IN PropertyAddress) -1) AS PropertyStreetAddress
FROM dataclean;

-- Extracción de la segunda parte después del separador ,

SELECT SUBSTRING(PropertyAddress, POSITION(',' IN PropertyAddress) +1, LENGTH(PropertyAddress)) AS PropertyCity
FROM dataclean;

-- Alterar la tabla para crear dos nuevas columnas, y posteriormente insertar los Select Substring

ALTER TABLE dataclean 
ADD property_address VARCHAR(255);

UPDATE dataclean
SET property_address = SUBSTRING(PropertyAddress, 1, POSITION(',' IN PropertyAddress) -1);


ALTER TABLE dataclean
ADD property_city VARCHAR(255);

UPDATE dataclean
SET property_city = SUBSTRING(PropertyAddress, POSITION(',' IN PropertyAddress) +1, LENGTH(PropertyAddress));

SELECT * FROM dataclean;

-- Ahora es momento de eliminar la columna original de PropertyAddress para evitar redundancia

-- La columna OwnerAddress posee más información de la deseable. Hay que separar la calle, la ciudad y el estado en tres columnas diferentes

SELECT
  OwnerAddress,
  SUBSTRING_INDEX(OwnerAddress, ',', 1) AS OwnerAddress,
  SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -2), ',', 1) AS OwnerCity,
  SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -1), ',', 1) AS OwnerState
FROM
  dataclean;
  
-- Alter table para añadir nuevas columnas ownerstaddress, ownercity, ownerstate, y update los substring en la que corresponda

ALTER TABLE dataclean
ADD ownerstaddress VARCHAR(255);

UPDATE dataclean
SET ownerstaddress = SUBSTRING_INDEX(OwnerAddress, ',', 1);

ALTER TABLE dataclean
ADD ownercity VARCHAR(255);

UPDATE dataclean
SET ownercity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -2), ',', 1);

ALTER TABLE dataclean
ADD ownerstate VARCHAR(255);

UPDATE dataclean
SET ownerstate = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -1), ',', 1);

-- Select para comprobar que todo este bien

SELECT * FROM dataclean;

-- Llego el momento de separar las columnas en nuevas tablas que se relacionen entre sí. Esto facilitará la exploración de los datos
-- Dividiré la información en 3 tablas: sales_info que será la tabla principal, owner_info, y property_info
-- sales_info se relacionará con owner_info a través de un id Foreing Key llamado owner_id, y con property_info lo mismo pero la columna tendrá por nombre property_id

-- Primero crearé la tabla owner_id

CREATE TABLE owner_info (
	owner_id INT AUTO_INCREMENT PRIMARY KEY,
    owner_name VARCHAR(255),
    ownerstaddress VARCHAR(255),
    ownercity VARCHAR(255),
    ownerstate VARCHAR(255))
    AUTO_INCREMENT = 7000;
    

INSERT INTO owner_info (owner_name, ownerstaddress, ownercity, ownerstate)
SELECT OwnerName, ownerstaddress, ownercity, ownerstate FROM dataclean;

SELECT * FROM owner_info;

-- Ahora se repite el proceso con property_info
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

INSERT INTO property_info (owner_id, property_address, property_city, building_value, 
total_value, land_value, year_built, bedrooms, full_bath, half_bath)
SELECT 
    owner_id, 
    NULL AS property_address, 
    NULL AS property_city, 
    NULL AS building_value, 
    NULL AS total_value, 
    NULL AS land_value, 
    NULL AS year_built, 
    NULL AS bedrooms, 
    NULL AS full_bath, 
    NULL AS half_bath
FROM 
    owner_info
UNION
SELECT 
    NULL AS owner_id, 
    property_address, 
    property_city, 
    BuildingValue, 
    TotalValue, 
    LandValue, 
    YearBuilt, 
    Bedrooms, 
    FullBath, 
    HalfBath 
FROM 
    dataclean;
    
    
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
    dataclean AS dc 
ON 
    oi.ownerstate = dc.ownerstate
LIMIT 5000;

    
SELECT * FROM property_info;

-- La mayoría de los datos hay que convertirlos a otro tipo con clausula CAST o Convert, pero ya se encuentran en la tabla

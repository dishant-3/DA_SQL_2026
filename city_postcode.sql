USE sample1;

--CREATE TABLE city_address (city_pincode VARCHAR(25));
--INSERT INTO city_address VALUES ('Mumbai400001'),( 'Delhi110034');
--SELECT * FROM city_address;
SELECT LEFT(city_pincode,(LEN(city_pincode)-6)) AS city,
RIGHT(city_pincode,6) AS pincode
FROM city_address;
SELECT 
    SUBSTRING(city_pincode, 1, PATINDEX('%[0-9]%', city_pincode) - 1) AS city_name,
    SUBSTRING(city_pincode, PATINDEX('%[0-9]%', city_pincode), LEN(city_pincode)) AS postcode
FROM city_address;
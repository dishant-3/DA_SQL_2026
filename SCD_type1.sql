-- Creating source TABLE
CREATE TABLE datamodeling.default.scdtyp1_source
(
  prod_id INT,
  prod_name STRING,
  prod_cat STRING,
  processDate DATE
);



INSERT INTO datamodeling.default.scdtyp1_source
VALUES
(1,'prod1','cat1',CURRENT_DATE()),
(2,'prod2','cat2',CURRENT_DATE()),
(3,'prod3','cat3',CURRENT_DATE());

-- Creating gold table 

CREATE TABLE datamodeling.gold.scdtyp1_table
(
  prod_id INT,
  prod_name STRING,
  prod_cat STRING,
  processDate DATE
)

spark.sql("select * from datamodeling.default.scdtyp1_source").createOrReplaceTempView("src")

-- Logic for SCD Type1

MERGE INTO datamodeling.gold.scdtyp1_table AS trg
USING src
ON src.prod_id = trg.prod_id
WHEN MATCHED AND src.processDate >= trg.processDate THEN UPDATE SET *
WHEN NOT MATCHED THEN INSERT *;

-- Updating the record with prod_id =3

UPDATE datamodeling.default.scdtyp1_source SET prod_cat = 'newcategory'
WHERE prod_id = 3;


-- Again run the SCD type1 logic query to update the gold table


MERGE INTO datamodeling.gold.scdtyp1_table AS trg
USING src
ON src.prod_id = trg.prod_id
WHEN MATCHED AND src.processDate >= trg.processDate THEN UPDATE SET *
WHEN NOT MATCHED THEN INSERT *;


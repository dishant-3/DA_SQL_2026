-- Creating source TABLE
%sql
CREATE TABLE datamodeling.default.scdtyp2_source
(
  prod_id INT,
  prod_name STRING,
  prod_cat STRING,
  processDate DATE
);

%sql
INSERT INTO datamodeling.default.scdtyp2_source
VALUES
(1,'prod1','cat1',CURRENT_DATE()),
(2,'prod2','cat2',CURRENT_DATE()),
(3,'prod3','cat3',CURRENT_DATE());

-- Creating SCD Type 2 gold TABLE
-- We have created three additional columns start_date,end-date and is_curent as compared to SCD Type1
%sql
CREATE TABLE datamodeling.gold.scdtype2_table
(
  prod_id INT,
  prod_name STRING,
  prod_cat STRING,
  processDate DATE,
  start_date DATE,
  end_date DATE,
  is_current STRING
);
-- Creating src view for SCD Type2

spark.sql("""SELECT *,
        current_timestamp as start_date,
        CAST('3000-01-01' AS TIMESTAMP) as end_date,
        'Y' as is_current
FROM datamodeling.default.scdtyp2_source""").createOrReplaceTempView("src")

-- SCD Type 2 Logic
-- Merge 1 :This command will check if we have any data in the target table that is updated in the source, and will mark it as expired.

MERGE INTO datamodeling.gold.scdtype2_table AS trg
USING src
ON src.prod_id = trg.prod_id
AND trg.is_current = 'Y'
-- When we have new data with updates
WHEN MATCHED AND(
src.prod_name <> trg.prod_name OR
src.processDate <> trg.processDate OR
src.prod_cat <> trg.prod_cat)
THEN 
UPDATE SET
trg.end_date = datediff(day(current_timestamp()),1),
trg.is_current = 'N';


--MERGE 2 : This command will bring all the non-expired commands bcz we have filter of "is_current = 'Y'". So, this will not bring the updated records as well bcz previous MERGE command marked it as expired. So all the new records [including updated] will be inserted in this MERGE.
MERGE INTO datamodeling.gold.scdtype2_table AS trg
USING src
ON trg.prod_id = src.prod_id
AND trg.is_current = 'Y'

WHEN NOT MATCHED THEN INSERT
(
prod_id,
prod_name,
prod_cat,
processDate,
start_date,
end_date,
is_current

) VALUES
(
src.prod_id,
src.prod_name,
src.prod_cat,
src.processDate,
src.start_date,
src.end_date,
src.is_current
);
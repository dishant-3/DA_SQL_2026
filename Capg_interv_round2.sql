-- gold.scd_final_tbl AS trg
-- raw.source_tbl AS src
-- prod_id, prod_name, prod_cate

MERGE INTO gold.scd_final_tbl AS trg
usiNG raw.source_tbl AS src
ON trg.prod_id = src.prod_id
AND is_curent = "y" AND(trg.prod_name<> src.prod_name OR prod_cate)
UPDATE trg
WHEN Matched
SET is_current='n'

WHEN NOT MAtched
INSERT INTO trg
VALUES(src.

---employee table 
-- dept_wise second and third highest salary

window_spec = df_emp.partitionBy(dept_id).orderBy("salary").desc()
df_res=df_emp.withColumn("den_rnk",dense_rank().over(window_spec)).where((den_rnk =2) | (den_rnk=3))
output_path = .....
df_res.write.option("mode","overwrite").save(output_path)
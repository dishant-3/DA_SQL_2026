-- Problem: Create segments of companies based on employee_count and then calculate avg revenue per customer.
-- Finally pivot the data on company segment type
WITH seg_cte AS
(
SELECT customer_id,
name AS company_name,
CASE WHEN employee_count < 100 THEN 'SMB'
WHEN employee_count >=100 AND employee_count <=999 THEN 'Mid-Market'
WHEN employee_count >=1000 THEN 'Enterprise' ELSE NULL END AS mark_segment
FROM customers
), annual_rev_cte AS
(
SELECT sc.customer_id,
sc.mark_segment,
c.num_seats * c.yearly_seat_cost AS annual_rev
FROM seg_cte sc
INNER JOIN contracts c
ON c.customer_id = sc.customer_id
), rev_calc_cte AS
(
SELECT mark_segment,
SUM(annual_rev)*1.0/COUNT(DISTINCT customer_id) AS rev_per_cust
FROM annual_rev_cte
GROUP BY mark_segment
),pivotcte AS
(
SELECT CASE WHEN mark_segment ='SMB' THEN rev_per_cust ELSE NULL END AS smb_avg_revenue,
CASE WHEN mark_segment ='Mid-Market' THEN rev_per_cust ELSE NULL END AS mid_avg_revenue,
CASE WHEN mark_segment ='Enterprise' THEN rev_per_cust ELSE NULL END AS enterprise_avg_revenue
FROM rev_calc_cte
) SELECT FLOOR(SUM(smb_avg_revenue)) AS smb_avg_revenue,
FLOOR(SUM(mid_avg_revenue)) AS mid_avg_revenue,
FLOOR(SUM(enterprise_avg_revenue)) AS enterprise_avg_revenue
FROM pivotcte;

-- While calculating rev_per_cust we have to COUNT(DISTINCT customer) in the denominator.
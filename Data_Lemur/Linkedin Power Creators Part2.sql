-- Problem: Find the profile_id with more followers on Linkedin than company they are working with on Linkedin.
-- In case of multiple companies consider only the company with highest no of followers on Linkedin
WITH power_creator_cte AS
(
SELECT DISTINCT prof.profile_id ,prof.followers,MAX(cp.followers) AS comp_followers
FROM personal_profiles prof 
LEFT JOIN
employee_company ec 
ON prof.profile_id = ec.personal_profile_id
LEFT JOIN 
company_pages cp 
ON ec.company_id = cp.company_id
-- WHERE prof.followers > cp.followers 
GROUP BY prof.profile_id ,prof.followers
ORDER BY prof.profile_id
)SELECT profile_id
FROM power_creator_cte
WHERE followers > comp_followers 
ORDER BY profile_id;
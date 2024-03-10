SELECT * FROM fact_market_share;
SELECT * FROM dim_cities;
select * from dim_date;
-- REVENUE BY PLANS
SELECT plans,plan_description,ROUND(SUM(plan_revenue_crores),1) AS plan_revenue_cr
FROM (
SELECT month_name,city_name,P.plans,plan_description,plan_revenue_crores
FROM fact_plan_revenue P JOIN
dim_plan PL ON PL.plan=p.plans JOIN
dim_cities C ON C.city_code=P.city_code JOIN
dim_date D ON D.date=P.date
 ) T 
GROUP BY 1,2
order by 3 desc;

-- POPULAR PLANS BY REVENUE FILTER BY CITY
SELECT city_name,plan_description,plan_revenue
FROM(
WITH CTE AS (
SELECT city_name,plans,plan_description,ROUND(sum(plan_revenue_crores),1) AS Plan_revenue
FROM (
SELECT month_name,city_name,P.plans,plan_description,plan_revenue_crores
FROM fact_plan_revenue P JOIN
dim_plan PL ON PL.plan=p.plans JOIN
dim_cities C ON C.city_code=P.city_code JOIN
dim_date D ON D.date=P.date
) T
GROUP BY 1,2,3
)
SELECT city_name,plans,plan_description,plan_revenue,
DENSE_RANK() OVER(PARTITION BY city_name ORDER BY Plan_revenue DESC) AS D_rank
FROM CTE
) Y
WHERE D_rank=1;
-- POPULAR PLANS BY REVENUE FILTER BY MONTHS
SELECT before_after_5g,P.plans,plan_description,ROUND(SUM(plan_revenue_crores),1) AS plan_revenue_cr
FROM fact_plan_revenue P JOIN
dim_plan PL ON PL.plan=p.plans JOIN
dim_cities C ON C.city_code=P.city_code JOIN
dim_date D ON D.date = P.date
GROUP BY 1,2,3
ORDER BY 1,4 DESC;
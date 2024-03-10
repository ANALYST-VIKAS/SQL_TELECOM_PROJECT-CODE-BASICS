-- REVENUE BY CITY BEFORE/AFTER 5G
SELECT city_name,
	ROUND(SUM(CASE WHEN before_after_5g="Before 5G" THEN atliqo_revenue_crores ELSE 0 END),2) AS Revenue_before_5G,
	ROUND(SUM(CASE WHEN before_after_5g="After 5G" THEN atliqo_revenue_crores ELSE 0 END),2) AS Revenue_After_5G
    FROM (
	SELECT D.city_name,before_after_5g,atliqo_revenue_crores
    FROM fact_atliqo_metrics F JOIN
    dim_cities D ON D.city_code=F.city_code JOIN
    dim_date  A ON A.date=F.date
    ) T
    GROUP BY 1;
    
-- PERCENT GROWTH IN REVENUE AFTER 5G BY CITY
	WITH CTE AS(
    SELECT city_name,
	ROUND(SUM(CASE WHEN before_after_5g="Before 5G" THEN atliqo_revenue_crores ELSE 0 END),2)AS Revenue_before_5G,
	ROUND(SUM(CASE WHEN before_after_5g="After 5G" THEN atliqo_revenue_crores ELSE 0 END),2)AS Revenue_After_5G
		FROM (
		SELECT D.city_name,before_after_5g,atliqo_revenue_crores
		FROM fact_atliqo_metrics F JOIN
		dim_cities D ON D.city_code=F.city_code JOIN
		dim_date  A ON A.date=F.date
		) T
		GROUP BY 1
        )
        SELECT *,ROUND((Revenue_After_5G/Revenue_Before_5G-1)*100,2) as Pct_Growth 
        FROM CTE
        ORDER BY 4 DESC;
        
-- PERCENT GROWTH IN ACTIVE USERS BY CITY
	WITH CTE AS  (
    SELECT city_name,
	   ROUND(SUM(CASE WHEN  before_after_5g="Before 5G" THEN active_users_lakhs ELSE 0 END),1) AS "Users_before_5G",
	   ROUND(SUM(CASE WHEN  before_after_5g="After 5G" THEN active_users_lakhs ELSE 0 END),1) AS "Users_after_5G"
    FROM(    
    SELECT city_name,month_name,before_after_5g,active_users_lakhs
    FROM  fact_atliqo_metrics F JOIN
    dim_date D ON D.date=F.date JOIN
    dim_cities C ON C. city_code=F.city_code
    ) T
    GROUP BY 1
				)
	SELECT city_name,Users_before_5G,Users_after_5G,ROUND((Users_after_5G/Users_before_5G-1)*100,1) as users_pct_growth 
	FROM CTE
    ORDER BY 4 DESC ;

-- CHURN RATE
SELECT D.month_name,Active_customers,Customer_lost,
	   CONCAT(ROUND(Customer_lost/Active_Customers *100,1),"%") AS Churn_rate
FROM (
SELECT month_name,ROUND(sum(active_users_lakhs),1) AS Active_customers,
				  ROUND(sum(unsubscribed_users_lakhs),1) AS Customer_lost
FROM fact_atliqo_metrics F JOIN
dim_cities C ON C.city_code=F.city_code JOIN
dim_date D ON D.date=F.date
GROUP BY 1
     ) T JOIN
dim_date D ON D.month_name=T.month_name
order by MONTH(D.date)



   
        


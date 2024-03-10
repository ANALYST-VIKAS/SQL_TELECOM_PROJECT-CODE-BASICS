-- TOTAL REVENUE:SUM OF ALL ATLIQO REVENUE
		SELECT ROUND(sum(atliqo_revenue_crores),1) AS TOTAL_REVENUE_CR 
		FROM fact_atliqo_metrics;

 -- AVERAGE_REVENUE: AVERAGE REVENUE OF ATLIQO
		SELECT ROUND(avg(atliqo_revenue_crores),2) AS Average_revenue_cr 
		FROM fact_atliqo_metrics;
 
 -- MEDIAN_REVENUE: MEDIAN_REVENUE OF ATLIQO
		 SELECT COUNT(atliqo_revenue_crores) AS n 
		 FROM fact_atliqo_metrics;
		 WITH cte AS (
		 SELECT ROW_NUMBER() OVER (ORDER BY atliqo_revenue_crores ) AS r_num ,atliqo_revenue_crores 
		 FROM fact_atliqo_metrics
					 )
		 SELECT (
		  (SELECT atliqo_revenue_crores FROM cte WHERE r_num=60) 
		  +
		  (SELECT atliqo_revenue_crores from cte WHERE r_num=61)
				)/2 AS Median_revenue_cr;
			
-- AVERAGE REVENUE PER USER: AVERAGE OF ARPU
			SELECT ROUND(AVG(arpu)/100,2) AS ARPU_cr 
			FROM fact_atliqo_metrics;
			
-- TOTAL ACTIVE USERS OF ATLIQO
			SELECT ROUND(SUM(active_users_lakhs)/100,2) AS Total_active_users_cr 
			FROM fact_atliqo_metrics;
   
-- TOTAL UNSUBSCRIBED USERS OF ATLIQO
			SELECT ROUND(SUM(unsubscribed_users_lakhs)/100,2) AS Total_unsubscribed_users_cr 
			FROM fact_atliqo_metrics;
		
-- AVERAGE MONTHLY ACTIVE USERS
			SELECT MONTHNAME(DATE) AS Mnth,ROUND(AVG(active_users_lakhs),2) AS Average_active_users 
			FROM fact_atliqo_metrics
			GROUP BY 1;
-- REVENUE BEFORE/AFTER 5G
			SELECT before_after_5g,ROUND(SUM(atliqo_revenue_crores),2) AS Total_revenue_cr
			FROM fact_atliqo_metrics F JOIN 
			dim_date D ON F.date=D.date
            GROUP BY 1;
            
-- ARPU BEFORE/AFTER 5G
			SELECT before_after_5g,ROUND(AVG(arpu),2) AS Average_arpu
			FROM fact_atliqo_metrics F JOIN 
			dim_date D ON F.date=D.date
            GROUP BY 1;

-- ACTIVE USERS BEFORE/AFTER 5G
			SELECT before_after_5g,ROUND(SUM(active_users_lakhs),2) AS Active_users_lakhs
			FROM fact_atliqo_metrics F JOIN 
			dim_date D ON F.date=D.date
            GROUP BY 1;
            
-- UNSUBSCRIBED USERS BEFORE/AFTER 5G
			SELECT before_after_5g,ROUND(SUM(unsubscribed_users_lakhs),2) AS Unsubscribed_users_lakhs
			FROM fact_atliqo_metrics F JOIN 
			dim_date D ON F.date=D.date
            GROUP BY 1;
-- CALCULATION OF ARPU ON MONTHLY BASIS
			SELECT month_name,before_after_5g,ROUND(AVG(arpu)) AS Avg_arpu_lakhs
            FROM fact_atliqo_metrics F JOIN
            dim_date D ON D.date=F.date
            GROUP BY 1,2
          	
            


    
USE protein_price_study; --calculates average yearly change, 2021-2023 avg, and compounded cumulative change

SELECT food_group,
	ROUND(AVG(weighted_avg_pct_change), 2) AS avg_yearly_change,
	ROUND(AVG(CASE WHEN yr BETWEEN 2021 AND 2023
					THEN weighted_avg_pct_change END), 2) AS avg_2021_2023,
	ROUND((EXP(SUM(LOG(1 + weighted_avg_pct_change / 100.0))) - 1) * 100, 1) AS cumulative_pct
FROM group_yearly_change
GROUP BY food_group
ORDER BY food_group;
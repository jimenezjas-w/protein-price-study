USE protein_price_study; --averages the google trends yearly, into table.

DROP TABLE IF EXISTS google_trends_yearly;

SELECT YEAR(time) AS yr, term, term_group,
	ROUND(AVG(CAST(interest AS DECIMAL(6,2))), 1) AS avg_interest,
	COUNT(*) AS months_with_data
INTO google_trends_yearly
FROM google_trends_long
GROUP BY YEAR(time), term, term_group;
USE protein_price_study; --creates 2 CTEs, price for combining food groups to their avg yearly pct change, 
						 --and trends for combining food groups to their avg interest
						 --combining both for better summary. 
DROP TABLE IF EXISTS protein_trends_vs_prices;

WITH price AS (
	SELECT yr,
		MAX(CASE WHEN food_group = 'protein' THEN weighted_avg_pct_change END) AS protein_pct,
		MAX(CASE WHEN food_group = 'non_protein' THEN weighted_avg_pct_change END) AS non_protein_pct,
		MAX(CASE WHEN food_group = 'Food at home' THEN weighted_avg_pct_change END) AS food_at_home_pct,
		MAX(CASE WHEN food_group = 'All food' THEN weighted_avg_pct_change END) AS all_food_pct
	FROM group_yearly_change
	GROUP BY yr
),
trends AS (
	SELECT yr,
		ROUND(AVG(CASE WHEN term_group = 'protein_interest' THEN avg_interest END),1 ) AS protein_interest_avg,
		ROUND(AVG(CASE WHEN term_group = 'price_worry' THEN avg_interest END), 1) AS price_worry_avg
	FROM google_trends_yearly
	GROUP BY yr
)
SELECT p.yr, p.protein_pct, p.non_protein_pct, p.food_at_home_pct, p.all_food_pct, t.protein_interest_avg, t.price_worry_avg
INTO protein_trends_vs_prices
FROM price p
JOIN trends t ON t.yr = p.yr; 
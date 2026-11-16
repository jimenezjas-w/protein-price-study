USE protein_price_study; --pairing series ids to their ers_item counterpart in a CTE "with_change".
						 --then, joining with usda_ers_prices to get a table comparing pct changes in bls and ers.

DROP TABLE IF EXISTS bls_vs_ers;

WITH with_change AS (
	SELECT p.series_id, p.bls_product, p.bone_in, p.yr, p.months_with_data, p.avg_usd_per_unit, p.avg_usd_per_100g_protein,
		CASE
			WHEN series_id IN ('APU0000703112', 'APU0000FC1101') THEN 'Beef and veal'
			WHEN series_id = 'APU0000704111' THEN 'Pork'
			WHEN series_id IN ('APU0000706111', 'APU0000706212', 'APU0000FF1101') THEN 'Poultry'
			WHEN series_id = 'APU0000708111' THEN 'Eggs'
			WHEN series_id IN ('APU0000709112', 'APU0000710211') THEN 'Dairy products'
		END AS ers_item,
		LAG(p.avg_usd_per_unit) OVER (PARTITION BY p.series_id ORDER BY p.yr)
			AS prev_year_avg
	FROM bls_yearly p
)

SELECT w.*,
	ROUND(100 * (w.avg_usd_per_unit - w.prev_year_avg) / w.prev_year_avg, 2)
		AS bls_pct_change,
	e.pct_change AS ers_pct_change
INTO bls_vs_ers
FROM with_change w
JOIN usda_ers_prices e
ON e.item = w.ers_item
AND e.yr = w.yr
AND e.type = 'actual'
WHERE w.yr BETWEEN 2017 AND 2025;
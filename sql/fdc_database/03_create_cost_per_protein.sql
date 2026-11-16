USE fdc; --table for pairing average prices to their grams of protein counterpart.
		 --exported as cost_per_protein.csv, used in protein_price_study.
		 --bone-in flag is hard coded

DROP TABLE IF EXISTS cost_per_protein;

SELECT p.series_id, p.bls_product, p.bls_unit, p.protein_g_per_100g, p.grams_per_unit, p.protein_g_per_unit,
	CAST(bp.date AS DATE) as price_date,
	ROUND (bp.value, 3) AS usd_per_unit,
	ROUND (100 * bp.value / p.protein_g_per_unit, 2) AS usd_per_100g_protein,
	CASE
		WHEN p.series_id IN ('APU0000706111', 'APU0000706212') THEN 'YES'
		ELSE 'NO'
	END AS bone_in
INTO cost_per_protein
FROM protein_per_unit p
JOIN bls_prices bp ON p.series_id = bp.series_id;
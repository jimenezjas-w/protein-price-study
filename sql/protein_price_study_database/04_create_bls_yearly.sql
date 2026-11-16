USE protein_price_study; --table for yearly cost of each protein based on usd to 100g protein. 

DROP TABLE IF EXISTS bls_yearly;

SELECT series_id, bls_product, bone_in,
	YEAR(price_date) AS yr,
	ROUND(AVG(usd_per_unit), 4) AS avg_usd_per_unit,
	ROUND(AVG(usd_per_100g_protein), 4) AS avg_usd_per_100g_protein,
	COUNT(usd_per_unit) AS months_with_data
INTO bls_yearly
FROM cost_per_protein
GROUP BY series_id, bls_product, bone_in, YEAR(price_date);

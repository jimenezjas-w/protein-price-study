USE protein_price_study; --sorts avg cost of each protein, excluding bone-in proteins.
						 --FC1101 is excluded due to being the same FDC item as 703112.
						 --2026 is left out due to being partial, not fully documented.

DROP TABLE IF EXISTS protein_cost_rank;

SELECT yr, bls_product, avg_usd_per_100g_protein,
	RANK() OVER (PARTITION BY yr ORDER BY avg_usd_per_100g_protein) AS cost_rank
INTO protein_cost_rank
FROM bls_yearly
WHERE bone_in = 'NO'
	AND series_id <> 'APU0000FC1101'
	AND yr BETWEEN 2016 AND 2025;
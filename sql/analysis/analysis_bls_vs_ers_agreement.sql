USE protein_price_study; --compares bls and ers yearly changes, average gap, and years moving the same direction.

SELECT bls_product, ers_item,
	ROUND(AVG(bls_pct_change), 2) AS avg_bls,
	ROUND(AVG(ers_pct_change), 2) AS avg_ers,
	ROUND(AVG(ABS(bls_pct_change - ers_pct_change)), 2) AS avg_gap,
	SUM(CASE WHEN SIGN(bls_pct_change) = SIGN(ers_pct_change) THEN 1 ELSE 0 END) AS years_same_direction
FROM bls_vs_ers
GROUP BY bls_product, ers_item
ORDER BY bls_product;

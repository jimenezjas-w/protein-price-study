USE protein_price_study; --weighted yearly price change for protein and non-protein groups (weighted by relative importance).
                         --"All food" and "Food at home" as benchmark rows.

DROP TABLE IF EXISTS group_yearly_change;

SELECT e.yr,
       g.food_group AS food_group,
       CAST(ROUND(SUM(e.pct_change * w.relative_importance_pct) / SUM(w.relative_importance_pct), 2) AS DECIMAL(6,2)) AS weighted_avg_pct_change,
       CAST(ROUND(SUM(e.pct_change * w.relative_importance_pct / 100.0), 2)
            AS DECIMAL(6,2)) AS contribution_pts
INTO group_yearly_change
FROM usda_ers_prices e
JOIN usda_ers_food_groups g ON g.item = e.item
JOIN relative_importance_pct w ON w.item = e.item
WHERE e.type = 'actual'
  AND e.yr BETWEEN 2016 AND 2025
  AND g.food_group IN ('protein', 'non_protein')
GROUP BY e.yr, g.food_group

UNION ALL

SELECT e.yr,
       e.item,
       CAST(ROUND(e.pct_change, 2) AS DECIMAL(6,2)),
       NULL
FROM usda_ers_prices e
WHERE e.type = 'actual'
  AND e.yr BETWEEN 2016 AND 2025
  AND e.item IN ('All food', 'Food at home');
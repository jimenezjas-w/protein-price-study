USE fdc; --table for pairing units to items that use irregular measurements, such as dozen eggs or per gallon.
         --50.3g per large egg x 12, 976g per quart x 4

DROP TABLE IF EXISTS protein_per_unit;

WITH base AS (
SELECT m.series_id, m.bls_product, m.bls_unit,
    ROUND (fn.amount, 2) AS protein_g_per_100g,
    CASE m.bls_unit
        WHEN 'per lb' THEN 453.6
        WHEN 'per dozen' THEN 603.6
        WHEN 'per gallon' THEN 3904
    END AS grams_per_unit
FROM bls_fdc_map m
JOIN food_nutrient fn ON fn.fdc_id = m.fdc_id
    AND fn.nutrient_id = 1003
)
SELECT series_id, bls_product, bls_unit, protein_g_per_100g, grams_per_unit,
    ROUND(protein_g_per_100g * grams_per_unit / 100, 1) AS protein_g_per_unit
INTO protein_per_unit
FROM base;

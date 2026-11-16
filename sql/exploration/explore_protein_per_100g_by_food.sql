USE fdc; --summary of protein of each item in bls_fdc_map.

SELECT m.series_id, m.bls_product, f.fdc_id, f.data_type, f.description, fn.amount AS protein_g_per_100g
FROM bls_fdc_map m
JOIN food f ON f.fdc_id = m.fdc_id
JOIN food_nutrient fn ON fn.fdc_id = f.fdc_id AND fn.nutrient_id = 1003
ORDER BY m.series_id;
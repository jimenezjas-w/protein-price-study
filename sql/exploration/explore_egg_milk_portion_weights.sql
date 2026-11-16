USE fdc; --trying to find the FDC gram weight for eggs and milk. 
		 --for milk, the unit was not noted but lined up with 1 cup, 1 fl. oz, 1 tbsp, 1 quart.

SELECT fp.fdc_id, fp.amount, mu.name AS unit, fp.portion_description, fp.gram_weight
FROM food_portion fp
LEFT JOIN measure_unit mu ON mu.id = fp.measure_unit_id
WHERE fp.fdc_id IN (748967, 171265);
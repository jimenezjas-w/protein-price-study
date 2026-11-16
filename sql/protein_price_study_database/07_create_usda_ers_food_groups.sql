USE protein_price_study; --puts foods into groups to be used in joins
DROP TABLE IF EXISTS usda_ers_food_groups;

SELECT DISTINCT e.item, 
	CASE
		WHEN e.item IN ('Meats, poultry, and fish', 'Eggs', 'Dairy products') THEN 'protein'
		WHEN e.item IN ('Fats and oils', 'Fruits and vegetables', 'Sugar and sweets', 'Cereals and bakery products', 
						'Nonalcoholic beverages', 'Other foods') THEN 'non_protein'
		WHEN e.item IN ('All food', 'Food away from home', 'Food at home') THEN 'benchmark'
	END AS food_group
INTO usda_ers_food_groups
FROM usda_ers_prices e
WHERE e.item IN ('Meats, poultry, and fish', 'Eggs', 'Dairy products',
                 'Fats and oils', 'Fruits and vegetables', 'Sugar and sweets',
                 'Cereals and bakery products', 'Nonalcoholic beverages', 'Other foods',
                 'All food', 'Food away from home', 'Food at home');
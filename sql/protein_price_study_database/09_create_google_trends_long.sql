USE protein_price_study; --formatting the google trends csv for usage. 

DROP TABLE IF EXISTS google_trends_long;

SELECT time, term, interest,
       CASE WHEN term IN ('high_protein', 'protein_bars', 'protein_shake', 'protein_powder')
            THEN 'protein_interest' ELSE 'price_worry' END AS term_group
INTO google_trends_long
FROM protein_google_trends
UNPIVOT (interest FOR term IN (egg_prices, beef_prices, chicken_prices, grocery_prices,
                               meat_prices, milk_prices, high_protein, protein_bars,
                               protein_shake, protein_powder)) AS u;
# Protein Price Study
**Have protein related groceries risen in price differently from other groceries over the last decade?**

An exploratory SQL Server and Tableau analysis of BLS, USDA ERS, USDA Food Central, and Google Trends data, 2016-2025.

## Summary
* I wanted to know whether or not protein-related groceries were changing differently in price than other groceries due to the sudden surge of interest in protein-oriented diets and products. 

* I had used the FoodData Central (**FDC**) database to isolate which protein products I would use in the study along with how many grams of protein are in each product. 

* I used the Bureau of Labor Statistics (**BLS**) database to find the average price data of each selected item and calculated the average USD per gram of protein in each selected protein product.

 * I used the USDA Economic Research Service (**ERS**) database to find the increases in all groceries over the same time window to see whether or not the changes in price matched regardless of protein content. 
 
 * Finally, I used Google Trends to gauge general interest in protein products and price change concerns to find whether or not any spikes in prices lined up with said interests. 

The result I found was that there was no year-to-year relationship between protein-adjacent interest and change in pricing. Any change in protein-grocery price was closely matching all groceries. 

## Key Findings

### 1. The cheapest protein source changed
![Line chart of average cost per 100g of protein for six foods, 2016-2025](<graphs/Cost per 100g of protein by product, 2016-2025.png>)

**Takeaway:** The cheapest source of protein changed, with eggs moving from $2.25 (2016) to $5.68 (2025). Bacon remained the highest in price, and ground beef had risen around 62%. Milk became cheapest from 2022. 

**Caveat:** bone-in chicken excluded.

### 2. Protein groceries rose about as much as other groceries
![Line chart of yearly price change for protein, non-protein, Food at home and All food](<graphs/Yearly price change_ protein vs. non-protein vs. Food at home vs. All food.png>)

**Takeaway:** Protein and non-protein groceries each rose around 30% in total from 2016 to 2025 (All food rose about 38%). Protein led in 2020, 2021, and 2025 but lagged behind in 2023. 

**Caveat:** Weighted averages use current shopping-basket weights, and dairy counts as protein.

### 3. Protein search interest kept rising
![Two panels: protein search interest above, protein price change below](<graphs/Protein search interest rose even as protein price changes cooled.png>)
**Takeaway:** Interest rose from 8.5 to 23.9, while price changes were uneven (11.3% in 2022, then 2.5%, then 1.5%). Correlation was about 0.3 in levels and about zero in yearly changes, on only 10 data points. No causal claim.

**Caveat:** Google Trends values are relative (0-100). This shows timing only, with no claim of cause and effect.

### 4. BLS prices agree with the government's price measure

![Small panels comparing BLS and ERS yearly price change for six products](<graphs/BLS vs ERS.png>)

**Takeaway:** The two moved roughly in the same direction in 9 of 9 years for ground beef, and 8 of 9 years for eggs, bacon and milk. Cheese and chicken breast had a weaker agreement, with only 5 of 9 years. BLS swings were larger than ERS, particularly for eggs.

**Caveat:** ERS categories were broader than single products. Bone-in chicken and "All uncooked ground beef" were excluded.

## Question and Sub-questions

| Main Question | Hypothesis |
| --- | --- |
|Have protein-related groceries risen in price differently from other groceries over the last decade?|Rising grocery prices pushed shoppers toward protein-focused foods for more satiation|

1. Which protein source is cheapest per gram of protein, and did that change over the last decade?
2. Did protein groceries rise faster than other groceries?
3. Did search interest in protein follow any accelerated price changes?
4. Do my BLS prices agree with the goverment's price measure?

## Interactive Dashboard

[View the dashboard on tableau Public](https://us-east-1.online.tableau.com/t/jimenezjasw-ootegktb/views/protein-price-study-workbook/Dashboard1)



## Data Sources

| Source | What I used | Link | Downloaded |
|---|---|---|---|
| U.S. Bureau of Labor Statistics (BLS), Average Price Data | Monthly average retail prices, 9 series (eggs, milk, ground beef x2, bacon, chicken whole/breast/legs, American cheese), 2016-2026 | https://www.bls.gov/data/ | 2026-11-01 |
| USDA Economic Research Service (ERS), Food Price Outlook | Yearly CPI-based price change for 22 food categories (1974-2025 history, 2024-2027 outlook), plus relative importance weights | https://www.ers.usda.gov/data-products/food-price-outlook/ | 2026-11-01 |
| USDA FoodData Central (FDC) | Protein per 100 g and portion weights for 8 foods (SR Legacy and Foundation Foods) | https://fdc.nal.usda.gov/ | 2026-11-01 |
| Google Trends | Monthly relative search interest (US, 2016-01 to 2026-10), 4 protein terms and 6 price-worry terms | https://trends.google.com/trends/ | 2026-11-01 |

Raw, unedited downloads are in `data/raw/`. The full FDC download (about 3 GB) is not included; `data/fdc_database/outputs/` holds the exact rows I used.

## Data Pipeline

```
data/raw/  (original downloads)
   |  cleaned in a spreadsheet
   v
data/*/inputs/  (cleaned CSVs)
   |  imported into SQL Server
   v
fdc database:  scripts 01-03  ->  cost_per_protein.csv
   v
protein_price_study database:  scripts 04-11
   v
data/*/outputs/  (exported tables)  ->  Tableau Public  ->  graphs/
```

| Stage | What happens |
|---|---|
| Clean | BLS: blank `-` values, ISO dates, added product/category/unit, fixed a mislabeled series. ERS: collapsed the category hierarchy, parsed attributes, stacked history with forecasts. Trends: merged two downloads, renamed headers. |
| `fdc` database | Match each BLS product to an FDC food, convert units to grams, compute protein per BLS unit and cost per 100 g of protein. |
| `protein_price_study` database | Yearly averages, BLS vs. ERS comparison, food groups, weighted group price changes, Trends by year. |
| Visualize | Four charts in Tableau Public, built from the exported tables. |

## Repository Structure

```
protein-price-study/
├── README.md
├── LICENSE
├── .gitignore
├── data/
│   ├── raw/
│   ├── fdc_database/
│   │   ├── inputs/    (bls_prices.csv)
│   │   └── outputs/   (bls_fdc_map, protein_per_unit, cost_per_protein, fdc_foods_used, fdc_portion_weights_used)
│   └── protein_price_study_database/
│       ├── inputs/    (usda_ers_prices, relative_importance_pct, protein_google_trends)
│       └── outputs/   (bls_yearly, protein_cost_rank, bls_vs_ers, usda_ers_food_groups, group_yearly_change, google_trends_long, google_trends_yearly, protein_trends_vs_prices)
├── sql/
│   ├── fdc_database/                  (01-03)
│   ├── protein_price_study_database/  (04-11)
│   ├── analysis/
│   └── exploration/
└── graphs/
```

## Reproduction

**You need:** Windows, SQL Server, SQL Server Management Studio (SSMS), and the FDC CSV download. Tableau Public is optional. 

1. **Create two databases:** `fdc` and `protein_price_study`.
2. **Load the `fdc` database.** Import these FDC tables: `food`, `food_nutrient`, `food_portion`, `measure_unit`. Import `data/fdc_database/inputs/bls_prices.csv` as `bls_prices`.
3. **Run** `sql/fdc_database/01` to `03`, then export `cost_per_protein` (or use the file in `data/fdc_database/outputs/`).
4. **Load `protein_price_study`.** Import these as tables with exact names:

| CSV | Table | Key column types |
|---|---|---|
| `cost_per_protein.csv` | `cost_per_protein` | prices and protein values as decimal, `price_date` as date |
| `usda_ers_prices.csv` | `usda_ers_prices` | `yr` int, `pct_change` decimal(6,2) |
| `relative_importance_pct.csv` | `relative_importance_pct` | decimal(5,1) and decimal(4,1) |
| `protein_google_trends.csv` | `protein_google_trends` | `time` date, search terms int |

5. **Run** `04` through `11` in order.
6. **Charts:** open the CSVs in `data/protein_price_study_database/outputs/` in Tableau Public.


## Methods and Decisions

* Analysis window 2016-2025. 2026 was left out as a partial year (BLS January-September, Trends January-October; ERS only has forecasts).
* Treated the question as exploratory
* Generic raw foods only, no brand-name entries.
* 80/20 raw ground beef for both BLS beef series, as BLS does not specify lean percentage (a grass-fed entry was considered).
* Milk: whole, with added vitamin D (BLS milk is fortified).
* Cheese: pasteurized process American singles (most popular cheese on market).
* Whole chicken and bone-in legs: FDC counts edible meat only, but BLS prices include bone, so protein is overstated. Flagged `bone_in`, and was excluded from rankings. 
* Unit conversions: 453.6 g per pounds; eggs 50.3 g × 12 = 603.6 g per dozen; milk 976 g per quart (unlabeled FDC row, identified by arithmetic) × 4 = 3,904 g per gallon.
* BLS: `-` values became blanks. October 2025 was missing for all series (due to federal shutdown), November 2018 for cheese, and May 202 for whole chicken. Nothing was filled in or interpolated.
* ERS: collapsed 5 category collumns into one item, split attributes into `type` and year, dropped duplicate 2024-2025 rows, kept forecasts as separate rows, dropped blank Processed fruits and vegetables years (not tracked before 1999), moved relative importance and 20-year average into a separate table.
* Trends: merged protein interest and price worry into one table.
* Food groups: protein = Meats, poultry, and fish; Eggs; Dairy products. Non-protein = six other categories. Benchmarks = All food and Food at home. Only mid-level categories were used so nothing is double-counted.
* Dairy counted as protein because of its significant protein content. 
* Group averages are weighted by ERS relative importance. 
* BLS to ERS mapping was approximate (Beef and veal -> ground beef, Pork -> bacon, Poultry -> chicken, Eggs -> eggs, Dairy -> milk and cheese) due to ERS categories being broader than chosen products. 
* Cost ranking uses 6 products, excluding bone-in items and `FC1101`

## Future Related Work

* Product-launch timing: Open Food Facts has no release dates; USDA Branded Foods dates were considered but not used.
* A bone-weight adjustment, and BLS prices for non-protein staples
* More obscure protein products, such as protein supplements and other convenience protein items.

## Licenses and Attribution

- **Code** (the SQL scripts) is licensed under the MIT License (see `LICENSE`).
- **Data** is not covered by that license. Each source keeps its own terms:
  - **BLS and USDA ERS:** U.S. federal agency data. Cite the source, and confirm each agency's reuse policy on its site.
  - **USDA FoodData Central:** in the public domain and published under CC0 1.0. No permission is needed, but the USDA asks users to credit FoodData Central as the source. Credit: USDA Agricultural Research Service, FoodData Central, https://fdc.nal.usda.gov/ (SR Legacy and Foundation Foods; accessed 2026-11-01).
  - **Google Trends:** accessed through the website's download feature and used under Google's terms of service. Google Trends data is relative, not absolute.
- This is an independent, educational project and not an official analysis by any of these agencies.
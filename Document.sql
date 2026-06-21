use[PROJET_OLIST]	
---------------------------------------------------------------------------------------------
-- Importation de la table "olist_order_reviews_dataset"
CREATE TABLE olist_order_reviews_dataset (
    review_id NVARCHAR(100),
    order_id NVARCHAR(100),
    review_score NVARCHAR(10),
    review_comment_title NVARCHAR(MAX),
    review_comment_message NVARCHAR(MAX),
    review_creation_date NVARCHAR(100),
    review_answer_timestamp NVARCHAR(100)
);

BULK INSERT olist_order_reviews_dataset
FROM 'C:\Users\PC\Documents\Rapport de stage\datasets\olist_order_reviews_dataset.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001',
    TABLOCK,
	FORMAT = 'CSV'
);
---------------------------------------------------------------------------------------------
--LES JOINTURES POUR EVALUER LES KPI

--Pour la vente 
SELECT 
    olist_order_payments_dataset.["order_id"],
    olist_order_payments_dataset.["payment_installments"],
    olist_order_payments_dataset.["payment_type"],
    olist_order_payments_dataset.["payment_sequential"],
    olist_order_payments_dataset.["payment_value"],
	olist_orders_dataset.["customer_id"],
    olist_orders_dataset.["order_status"],
	olist_orders_dataset.["order_purchase_timestamp"],
	olist_orders_dataset.["order_approved_at"],
	olist_orders_dataset.["order_delivered_carrier_date"],
	olist_orders_dataset.["order_estimated_delivery_date"]
INTO Ventes
FROM olist_order_payments_dataset
LEFT JOIN olist_orders_dataset
ON olist_order_payments_dataset.["order_id"] = olist_orders_dataset.["order_id"];


-- Pour les clients 
SELECT 
    olist_customers_dataset.["customer_id"],
    olist_customers_dataset.["customer_unique_id"],
    olist_customers_dataset.["customer_zip_code_prefix"],
    olist_customers_dataset.["customer_city"],
    olist_customers_dataset.["customer_state"],
	olist_orders_dataset.["order_id"],
    olist_orders_dataset.["order_status"],
	olist_orders_dataset.["order_purchase_timestamp"],
	olist_orders_dataset.["order_approved_at"],
	olist_orders_dataset.["order_delivered_carrier_date"],
	olist_orders_dataset.["order_estimated_delivery_date"]
INTO Clients
FROM olist_customers_dataset
LEFT JOIN olist_orders_dataset
ON olist_customers_dataset.["customer_id"] = olist_orders_dataset.["customer_id"];


-- Pour les produits
create view ProduitsIntern as(
	select 
	olist_order_items_dataset.["order_id"], olist_order_items_dataset.["order_item_id"],
	olist_order_items_dataset.["product_id"], olist_order_items_dataset.["seller_id"],
	olist_order_items_dataset.["shipping_limit_date"], olist_order_items_dataset.["price"],
	olist_order_items_dataset.["freight_value"], olist_products_dataset.["product_category_name"],
	olist_products_dataset.["product_name_lenght"], olist_products_dataset.["product_description_lenght"],
	olist_products_dataset.["product_photos_qty"], olist_products_dataset.["product_length_cm"],
	olist_products_dataset.["product_height_cm"], olist_products_dataset.["product_width_cm"]
	FROM olist_order_items_dataset
	LEFT JOIN olist_products_dataset
	ON olist_order_items_dataset.["product_id"] = olist_products_dataset.["product_id"]
)
select ProduitsIntern.["order_id"], ProduitsIntern.["order_item_id"],
	ProduitsIntern.["product_id"], ProduitsIntern.["seller_id"],
	ProduitsIntern.["shipping_limit_date"], ProduitsIntern.["price"],
	ProduitsIntern.["freight_value"], ProduitsIntern.["product_category_name"],
	ProduitsIntern.["product_name_lenght"], ProduitsIntern.["product_description_lenght"],
	ProduitsIntern.["product_photos_qty"], ProduitsIntern.["product_length_cm"],
	ProduitsIntern.["product_height_cm"], ProduitsIntern.["product_width_cm"],
	product_category_name_translation.product_category_name_english
into Produits
from ProduitsIntern
left join product_category_name_translation
on product_category_name_translation.product_category_name = ProduitsIntern.["product_category_name"]


-- Pour les Vendeurs
select 
olist_order_items_dataset.["order_id"], olist_order_items_dataset.["order_item_id"],
olist_order_items_dataset.["product_id"], olist_order_items_dataset.["seller_id"],
olist_order_items_dataset.["shipping_limit_date"], olist_order_items_dataset.["price"],
olist_order_items_dataset.["freight_value"], olist_sellers_dataset.["seller_zip_code_prefix"],
olist_sellers_dataset.["seller_city"], olist_sellers_dataset.["seller_state"]
into Vendeurs
FROM olist_order_items_dataset
LEFT JOIN olist_sellers_dataset
ON olist_order_items_dataset.["seller_id"] = olist_sellers_dataset.["seller_id"]


-- Pour la satisfaction
SELECT 
    olist_order_reviews_dataset.review_id,
    olist_order_reviews_dataset.review_score,
    olist_order_reviews_dataset.review_comment_title,
    olist_order_reviews_dataset.review_comment_message,
    olist_order_reviews_dataset.review_creation_date,
	olist_order_reviews_dataset.review_answer_timestamp,
	olist_orders_dataset.["order_id"],
    olist_orders_dataset.["order_status"],
	olist_orders_dataset.["order_purchase_timestamp"],
	olist_orders_dataset.["order_approved_at"],
	olist_orders_dataset.["order_delivered_carrier_date"],
	olist_orders_dataset.["order_estimated_delivery_date"]
INTO Satisfaction
FROM olist_order_reviews_dataset
LEFT JOIN olist_orders_dataset
ON olist_order_reviews_dataset.order_id = olist_orders_dataset.["order_id"];


-- Pour le marketing
SELECT 
    olist_closed_deals_dataset.mql_id, olist_closed_deals_dataset.seller_id, olist_closed_deals_dataset.sdr_id,
    olist_closed_deals_dataset.sr_id, olist_closed_deals_dataset.won_date,
	olist_closed_deals_dataset.business_segment, olist_closed_deals_dataset.lead_type,
	olist_closed_deals_dataset.lead_behaviour_profile, olist_closed_deals_dataset.has_company,
	olist_closed_deals_dataset.has_gtin, olist_closed_deals_dataset.average_stock,
	olist_closed_deals_dataset.business_type, olist_closed_deals_dataset.declared_product_catalog_size,
	olist_closed_deals_dataset.declared_monthly_revenue,
    olist_marketing_qualified_leads_dataset.first_contact_date,
	olist_marketing_qualified_leads_dataset.landing_page_id,
	olist_marketing_qualified_leads_dataset.origin
INTO Marketing
FROM olist_closed_deals_dataset
LEFT JOIN olist_marketing_qualified_leads_dataset
ON olist_closed_deals_dataset.mql_id = olist_marketing_qualified_leads_dataset.mql_id;
---------------------------------------------------------------------------------------------

-- IDENTIFICATION DES ANOMALIES ET NETTOYAGE

--**************************************************************************************************************************************
-- Table Clients
select * from Clients
-- Valeurs nulles (manquantes)
SELECT 
    SUM(CASE WHEN replace(["customer_id"], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_customer_id,
    SUM(CASE WHEN replace(["customer_unique_id"], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_customer_unique_id,
    SUM(CASE WHEN replace(["customer_zip_code_prefix"], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_zip,
    SUM(CASE WHEN replace(["customer_city"],' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_city,
    SUM(CASE WHEN replace(["customer_state"], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_state,
    SUM(CASE WHEN replace(["order_id"], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_order_id,
    SUM(CASE WHEN replace(["order_status"], ' ', '') = ''  THEN 1 ELSE 0 END) AS NbreNull_order_status,
    SUM(CASE WHEN replace(["order_purchase_timestamp"], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_purchase,
    SUM(CASE WHEN replace(["order_approved_at"], ' ', '') = ''THEN 1 ELSE 0 END) AS NbreNull_approved,
    SUM(CASE WHEN replace(["order_delivered_carrier_date"], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_carrier,
    SUM(CASE WHEN replace(["order_estimated_delivery_date"], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_estimated
FROM Clients;

-- Doublons
select ["customer_id"], ["customer_unique_id"], ["customer_zip_code_prefix"], ["customer_city"], ["customer_state"], ["order_id"], ["order_status"], 
["order_purchase_timestamp"],["order_approved_at"], ["order_delivered_carrier_date"], ["order_estimated_delivery_date"], COUNT(*) as Doublons
from Clients 
Group by ["customer_id"], ["customer_unique_id"], ["customer_zip_code_prefix"], ["customer_city"], ["customer_state"], ["order_id"], ["order_status"], 
["order_purchase_timestamp"],["order_approved_at"], ["order_delivered_carrier_date"], ["order_estimated_delivery_date"]
having COUNT(*)>1

-- Code postal à plus ou moin de 5 chiffres
select replace(["customer_zip_code_prefix"], '"', ''), len(replace(["customer_zip_code_prefix"], '"', '')) as longueurCode
from Clients
where len(["customer_zip_code_prefix"]) != 5 or ["customer_zip_code_prefix"] not like '%[0-9]%'

-- Reporting :
-- Aucune valeur nulle
-- Aucun doublon
-- Aucun code postal different de 5 chiffres 
-- Standardisation des différentes colonnes de dates
-- Aucune colonne où il peut y avoir des valeurs abberrantes à détecter...

-- NETTOYAGE DE Clients

-- Standardisation des dates
update Clients
	set ["order_purchase_timestamp"] = CAST(["order_purchase_timestamp"] AS date),
	    ["order_approved_at"] = CAST(["order_approved_at"] as date),
	    ["order_delivered_carrier_date"] = CAST(["order_delivered_carrier_date"] as date),
	    ["order_estimated_delivery_date"] = CAST(["order_estimated_delivery_date"] as date)

-- Retrait des ponctuations non significatives
update Clients
	set ["customer_id"] = REPLACE(["customer_id"], '"', ''),
		["customer_unique_id"] = REPLACE(["customer_unique_id"], '"', ''), 
		["customer_zip_code_prefix"] = REPLACE(["customer_zip_code_prefix"], '"', ''),
		["customer_city"] = REPLACE(["customer_city"], '"', ''), 
		["customer_state"] = REPLACE(["customer_state"], '"', ''), 
		["order_id"] = REPLACE(["order_id"], '"', ''),
		["order_status"] = REPLACE(["order_status"], '"', ''), 
		["order_purchase_timestamp"] = REPLACE(["order_purchase_timestamp"], '"', ''),
		["order_approved_at"] = REPLACE(["order_approved_at"], '"', ''),
		["order_delivered_carrier_date"] = REPLACE(["order_delivered_carrier_date"], '"', ''), 
		["order_estimated_delivery_date"] = REPLACE(["order_estimated_delivery_date"], '"', '')
--**************************************************************************************************************************************

-- Table Marketing
select * from Marketing
-- Valeurs nulles (manquantes)
SELECT 
    SUM(CASE WHEN replace(mql_id, ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_mql_id,
    SUM(CASE WHEN replace(seller_id, ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_seller_id,
    SUM(CASE WHEN replace(sdr_id, ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_sdr_id,
    SUM(CASE WHEN replace(sr_id, ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_sr_id,
    SUM(CASE WHEN replace(won_date, ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_won_date,
    SUM(CASE WHEN replace(business_segment, ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_business_segment,
    SUM(CASE WHEN replace(lead_type, ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_lead_type,
    SUM(CASE WHEN replace(lead_behaviour_profile, ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_lead_behaviour,
    SUM(CASE WHEN replace(has_company, ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_has_company,
    SUM(CASE WHEN replace(has_gtin, ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_has_gtin,
    SUM(CASE WHEN replace(business_type, ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_business_type,
	SUM(CASE WHEN replace(declared_product_catalog_size, ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_declared_product,
	SUM(CASE WHEN replace(declared_monthly_revenue, ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_declared_monthly,
	SUM(CASE WHEN replace(first_contact_date, ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_first_contact_date,
	SUM(CASE WHEN replace(landing_page_id, ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_landing_page_id,
	SUM(CASE WHEN replace(origin, ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_origin
FROM Marketing;

-- Doublons
select mql_id, seller_id, sdr_id, sr_id, won_date, business_segment, lead_type, lead_behaviour_profile, has_company, has_gtin, 
average_stock, business_type, declared_product_catalog_size, declared_monthly_revenue, first_contact_date, landing_page_id, origin, COUNT(*) as Doublons
from Marketing
Group by mql_id, seller_id, sdr_id, sr_id, won_date, business_segment, lead_type, lead_behaviour_profile, has_company, has_gtin, 
average_stock, business_type, declared_product_catalog_size, declared_monthly_revenue, first_contact_date, landing_page_id, origin
having COUNT(*)>1

--Les valeurs abberrantes des variables quantitatives
 -- COLONNE average_stock
with req3 as (
	select average_stock, percentile_cont(0.25) within group(order by cast(average_stock as float) desc) over() as Q1,
	percentile_cont(0.75) within group(order by cast(average_stock as float) desc) over() as Q3,
	percentile_cont(0.75) within group(order by cast(average_stock as float) desc) over() - 
	percentile_cont(0.25) within group(order by cast(average_stock as float) desc) over() as IQR 
	from Marketing
)
select average_stock, Q1-1.5*IQR as Borne_Inf, Q3+1.5*IQR as Borne_Sup
from req3
where cast(average_stock as float) not between Q1-1.5*IQR and Q3+1.5*IQR

  -- COLONNE declared_product_catalog_size
with req4 as (
	select declared_product_catalog_size, percentile_cont(0.25) within group(order by cast(declared_product_catalog_size as float) desc) over() as Q1,
	percentile_cont(0.75) within group(order by cast(declared_product_catalog_size as float) desc) over() as Q3,
	percentile_cont(0.75) within group(order by cast(declared_product_catalog_size as float) desc) over() - 
	percentile_cont(0.25) within group(order by cast(declared_product_catalog_size as float) desc) over() as IQR 
	from Marketing
)
select declared_product_catalog_size, Q1-1.5*IQR as Borne_Inf, Q3+1.5*IQR as Borne_Sup
from req4
where cast(declared_product_catalog_size as float) not between Q1-1.5*IQR and Q3+1.5*IQR

  -- COLONNE declared_monthly_revenue
with req5 as (
	select declared_monthly_revenue, percentile_cont(0.25) within group(order by cast(declared_monthly_revenue as float) desc) over() as Q1,
	percentile_cont(0.75) within group(order by cast(declared_monthly_revenue as float) desc) over() as Q3,
	percentile_cont(0.75) within group(order by cast(declared_monthly_revenue as float) desc) over() - 
	percentile_cont(0.25) within group(order by cast(declared_monthly_revenue as float) desc) over() as IQR 
	from Marketing
)
select declared_monthly_revenue, Q1-1.5*IQR as Borne_Inf, Q3+1.5*IQR as Borne_Sup
from req5
where cast(declared_monthly_revenue as float) not between Q1-1.5*IQR and Q3+1.5*IQR

-- Verification si les variables quantitatives le sont uniquement
select distinct average_stock
from Marketing
where average_stock not like '%[0-9]%'

select distinct declared_product_catalog_size
from Marketing
where declared_product_catalog_size not like '%[0-9]%'

select distinct declared_monthly_revenue
from Marketing
where declared_monthly_revenue not like '%[0-9]%'

-- Reporting:
-- Il y a des valeurs nulles dans les colonnes: 
             --business_segment, lead_type, lead_behaviour_profile, has_company, 
			 --has_gtin, business_type, declared_product, origin
-- Il n y a aucun doublon(s)
-- Il y a deux variables quantitatives qui contiennent des variables 
             --qualitatives (average_stock, declared_product_catalog_size)
-- Présence des valeurs quantitatives bruitées dans la colonnes des variables 
              --qualitatives (ex: stock moyen : 5-20)

-- NETTOYAGE DE Marketing 
-- Standardisation de la date
-- Remplacement des valeurs bruitées dans la colonne des variables 
               --quantitatives par la médiane
-- Remplacement des valeurs qualitatives dans la colonne quantitative par 
              --le mediane de la colonne quantitative privée de ces valeurs
-- Remplacement des valeurs qualitatives nulles par le mode de la colonne
-- Remplacement des valeurs incohérentes des colonnes quantitatives par 
            --une intuition de données du mot incohérent

-- Standardisation de la date
update Marketing
set won_date = CAST(won_date as date), first_contact_date = CAST(first_contact_date as date)

-- COLONNE average_stock
-- La médiane
with req1 as(
	select average_stock
	from Marketing
	where average_stock like '%[0-9]%' and len(average_stock)>1
)
	select distinct percentile_cont(0.5) within group(order by CAST(average_stock as float)) over() as Median_Average_stock
	from req1

-- La moyenne
select avg(cast(average_stock as float)) as Moyenne_Average_stock
from Marketing
where average_stock like '%[0-9]%' and len(average_stock)>1

-- En observant une asymétrie vers la droite, il est préférable de remplacer par la médiane.

update Marketing
set average_stock = '3'
where average_stock = '1-5'

update Marketing
set average_stock = '35'
where average_stock = '20-50'

update Marketing
set average_stock = '125'
where average_stock = '50-200'

update Marketing
set average_stock = '200'
where average_stock = '200+'

update Marketing
set average_stock = '12.5'
where average_stock = '5-20'

update Marketing
set declared_monthly_revenue = '0.0'
where declared_monthly_revenue = ',0.0' 

update Marketing
set declared_monthly_revenue = '50000'
where declared_monthly_revenue = '100.0,50000.0'

update Marketing
set declared_monthly_revenue = '25000'
where declared_monthly_revenue = '300.0,25000.0'

update Marketing
set declared_monthly_revenue = '120000'
where declared_monthly_revenue = '305.0,120000.0'

update Marketing
set declared_monthly_revenue = '60000'
where declared_monthly_revenue = '47.0,60000.0'

update Marketing
set declared_monthly_revenue = '10000'
where declared_monthly_revenue = '50.0,10000.0'

update Marketing
set declared_monthly_revenue = '30000'
where declared_monthly_revenue = '50.0,30000.0'

update Marketing
set declared_monthly_revenue = '8000'
where declared_monthly_revenue = '50.0,8000.0'

update Marketing
set declared_monthly_revenue = '50000'
where declared_monthly_revenue = '700.0,50000.0'

-- Remplacement des observations non flotantes (numériques) par la médiane qui est égale à 35
update Marketing
set average_stock = '35'
where average_stock not like '%[0-9]%'

-- COLONNE declared_product_catalog_size
-- La médiane
with req1 as(
	select declared_product_catalog_size
	from Marketing
	where declared_product_catalog_size like '%[0-9]%' and len(declared_product_catalog_size)>1
)
	select distinct percentile_cont(0.5) within group(order by CAST(declared_product_catalog_size as float)) over() as Median_declared_product_catalog_size
	from req1

-- La moyenne
select avg(cast(declared_product_catalog_size as float)) as Moyenne_declared_product_catalog_size
from Marketing
where declared_product_catalog_size like '%[0-9]%' and len(declared_product_catalog_size)>1

-- En observant une asymétrie vers la droite, il est préférable de remplacer par la médiane.
update Marketing
set declared_product_catalog_size = '100'
where declared_product_catalog_size not like '%[0-9]%'

-- remplacement des valeurs nulles des variables qualitatives par le mode de la colonne
-- Valeur à trouver pour remplacer 
SELECT TOP 1 business_segment, lead_type, lead_behaviour_profile, business_type, origin, COUNT(*) AS frequence
FROM Marketing
GROUP BY business_segment, lead_type, lead_behaviour_profile, business_type, origin
ORDER BY frequence DESC;

-- Remplacement par les valeurs trouvées
update Marketing
set business_segment = 'car_accessories'
where replace(business_segment, ' ', '') = '' or business_segment is null

update Marketing
set lead_type = 'online_medium'
where replace(lead_type, ' ', '') = '' or lead_type is null

update Marketing
set lead_behaviour_profile = 'cat'
where replace(lead_behaviour_profile, ' ', '') = '' or lead_behaviour_profile is null

update Marketing
set business_type = 'reseller'
where replace(business_type, ' ', '') = '' or business_type is null

update Marketing
set origin = 'organic_search'
where replace(origin, ' ', '') = '' or origin is null

--**************************************************************************************************************************************

-- Table Produits
select * from Produits
-- Valeurs nulles (manquantes)
SELECT 
    SUM(CASE WHEN replace(["order_id"], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_order_id,
    SUM(CASE WHEN replace(["order_item_id"], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_order_item_id,
    SUM(CASE WHEN replace(["product_id"], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_product_id,
    SUM(CASE WHEN replace(["seller_id"], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_seller_id,
    SUM(CASE WHEN replace(["shipping_limit_date"], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_shipping_limi_date,
    SUM(CASE WHEN replace(["price"], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_price,
    SUM(CASE WHEN replace(["freight_value"], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_freight_value,
    SUM(CASE WHEN replace(["product_category_name"], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_product_category_name,
    SUM(CASE WHEN replace(["product_name_lenght"], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_product_category_length,
    SUM(CASE WHEN replace(["product_description_lenght"], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_product_description_lenght,
    SUM(CASE WHEN replace(["product_photos_qty"], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_product_photos_qty,
	SUM(CASE WHEN replace(["product_length_cm"], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_product_length_cm,
	SUM(CASE WHEN replace(["product_height_cm"], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_product_height_cm,
	SUM(CASE WHEN replace(["product_width_cm"], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_product_width_cm,
	SUM(CASE WHEN replace([product_category_name_english], ' ', '') = '' THEN 1 ELSE 0 END) AS NbreNull_product_category_name_english
FROM Produits;

-- Doublons
select ["order_id"], ["order_item_id"], ["product_id"], ["seller_id"], ["shipping_limit_date"],["price"],
["freight_value"], ["product_category_name"],["product_name_lenght"],["product_description_lenght"],
["product_photos_qty"],["product_length_cm"],["product_height_cm"],["product_width_cm"],[product_category_name_english],
COUNT(*) as Doublons
from Produits
Group by ["order_id"], ["order_item_id"], ["product_id"], ["seller_id"], ["shipping_limit_date"],["price"],
["freight_value"], ["product_category_name"],["product_name_lenght"],["product_description_lenght"],
["product_photos_qty"],["product_length_cm"],["product_height_cm"],["product_width_cm"],[product_category_name_english]
having COUNT(*)>1

-- Reporting:
-- Il y a des valeurs manquantes dans plusieurs colonnes, notamment: 
     --product_category_name, product_category_length, product_description_length,...
-- Il n y a aucun doublon

-- NETTOYAGE de Produits
-- Remplacement des valeurs manquantes des variables quanlitatives par le mode
-- standardisation de la date
-- Remplacer les valeurs manquantes des colonnes de variables quantitatives par la mediane 

update Produits
set ["shipping_limit_date"] = cast(["shipping_limit_date"] as date)

-- Valeur à trouver pour remplacer 
SELECT TOP 1 ["product_category_name"], COUNT(*) AS frequence
FROM Produits
GROUP BY ["product_category_name"]
ORDER BY frequence DESC;

-- Remplacement par les valeurs trouvées
update Produits
set ["product_category_name"] = 'cama_mesa_banho'
where replace(["product_category_name"], ' ', '') = '' or ["product_category_name"] is null

-- Remplacer les valeurs manquantes par la médiane
-- a) colonne "product_name_lenght"
with req6 as(
	select ["product_name_lenght"]
	from Produits
	where ["product_name_lenght"] like '%[0-9]%' and len(["product_name_lenght"])>1
)	select distinct percentile_cont(0.5) within group(order by CAST(["product_name_lenght"] as float)) over() as Median_product_name_lenght
	from req6
update Produits
set ["product_name_lenght"] = '52'
where replace(["product_name_lenght"], ' ', '') = '' or ["product_name_lenght"] is null

-- b) colonne "product_description_lenght"
with req7 as(
	select ["product_description_lenght"]
	from Produits
	where ["product_description_lenght"] like '%[0-9]%' and len(["product_description_lenght"])>1
)	select distinct percentile_cont(0.5) within group(order by CAST(["product_description_lenght"] as float)) over() as Median_product_description_lenght
	from req7
update Produits
set ["product_description_lenght"] = '603'
where replace(["product_description_lenght"], ' ', '') = '' or ["product_description_lenght"] is null

-- c) colonne "product_photos_qty"
with req8 as(
	select ["product_photos_qty"]
	from Produits
	where ["product_photos_qty"] like '%[0-9]%' and len(["product_photos_qty"])>1
)	select distinct percentile_cont(0.5) within group(order by CAST(["product_photos_qty"] as float)) over() as Median_product_photos_qty
	from req8
update Produits
set ["product_photos_qty"] = '10'
where replace(["product_photos_qty"], ' ', '') = '' or ["product_photos_qty"] is null

-- d) colonne "product_length_cm"
with req9 as(
	select ["product_length_cm"]
	from Produits
	where ["product_length_cm"] like '%[0-9]%' and len(["product_length_cm"])>1
)	select distinct percentile_cont(0.5) within group(order by CAST(["product_length_cm"] as float)) over() as Median_product_length_cm
	from req9
update Produits
set ["product_length_cm"] = '25'
where replace(["product_length_cm"], ' ', '') = '' or ["product_length_cm"] is null

-- e) colonne "product_width_cm"
with req10 as(
	select ["product_width_cm"]
	from Produits
	where ["product_width_cm"] like '%[0-9]%' and len(["product_width_cm"])>1
)	select distinct percentile_cont(0.5) within group(order by CAST(["product_width_cm"] as float)) over() as Median_product_width_cm
	from req10
update Produits
set ["product_width_cm"] = '20'
where replace(["product_width_cm"], ' ', '') = '' or ["product_width_cm"] is null

-- f) colonne "product_length_cm"
with req11 as(
	select ["product_height_cm"]
	from Produits
	where ["product_height_cm"] like '%[0-9]%' and len(["product_height_cm"])>1
)	select distinct percentile_cont(0.5) within group(order by CAST(["product_height_cm"] as float)) over() as Median_product_height_cm
	from req11
update Produits
set ["product_height_cm"] = '16'
where replace(["product_height_cm"], ' ', '') = '' or ["product_height_cm"] is null

--**************************************************************************************************************************************

-- Table Satisfaction
select * from Satisfaction
-- Valeurs nulles(manquantes)
SELECT 
    SUM(CASE WHEN review_id is null THEN 1 ELSE 0 END) AS NbreNull_review_id,
    SUM(CASE WHEN review_score is null THEN 1 ELSE 0 END) AS NbreNull_review_score,
    SUM(CASE WHEN review_comment_title is null THEN 1 ELSE 0 END) AS NbreNull_review_comment_title,
    SUM(CASE WHEN review_comment_message is null THEN 1 ELSE 0 END) AS NbreNull_review_comment_message,
    SUM(CASE WHEN review_creation_date is null THEN 1 ELSE 0 END) AS NbreNull_review_creation_date,
    SUM(CASE WHEN review_answer_timestamp is null THEN 1 ELSE 0 END) AS NbreNull_review_answer_timestamp,
    SUM(CASE WHEN ["order_id"] is null THEN 1 ELSE 0 END) AS NbreNull_order_id,
    SUM(CASE WHEN ["order_status"] is null THEN 1 ELSE 0 END) AS NbreNull_order_status,
    SUM(CASE WHEN ["order_purchase_timestamp"] is null THEN 1 ELSE 0 END) AS NbreNull_order_purchase_timestamp,
    SUM(CASE WHEN ["order_approved_at"] is null THEN 1 ELSE 0 END) AS NbreNull_order_approved_at,
    SUM(CASE WHEN ["order_delivered_carrier_date"] is null THEN 1 ELSE 0 END) AS NbreNull_order_delivered_carrier_date,
	SUM(CASE WHEN ["order_estimated_delivery_date"] is null THEN 1 ELSE 0 END) AS NbreNull_order_estimated_delivery_date
FROM Satisfaction;

-- Doublons
select review_id, review_score, review_comment_title, review_comment_message,review_creation_date, review_answer_timestamp,  
["order_id"], ["order_status"],["order_purchase_timestamp"], ["order_approved_at"], ["order_delivered_carrier_date"], 
["order_estimated_delivery_date"], COUNT(*) as Doublons
from Satisfaction
Group by review_id, review_score, review_comment_title, review_comment_message,review_creation_date, review_answer_timestamp,  
["order_id"], ["order_status"],["order_purchase_timestamp"], ["order_approved_at"], ["order_delivered_carrier_date"], 
["order_estimated_delivery_date"]
having COUNT(*)>1

--Reporting
-- Toute les colonnes ont des valeurs manquantes, mais ici, il n y aucune facon d'y remédier...
-- Date non standardisée 
-- Il y a 334 doublons 

-- NETTOYAGE DE Staisfaction

-- standardisation de la date
update Satisfaction
set review_creation_date = cast(review_creation_date as date),
	review_answer_timestamp = cast(review_answer_timestamp as date),
	["order_purchase_timestamp"] = cast(["order_purchase_timestamp"] as date),
	["order_approved_at"] = cast(["order_approved_at"] as date),
	["order_delivered_carrier_date"] = cast(["order_delivered_carrier_date"] as date),
	["order_estimated_delivery_date"] = cast(["order_estimated_delivery_date"] as date)

-- Suppression des doublons
WITH Doublons AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY
                   review_id,
                   review_score,
                   review_comment_title,
                   review_comment_message,
                   review_creation_date,
                   review_answer_timestamp,
                   ["order_id"],
                   ["order_status"],
                   ["order_purchase_timestamp"],
                   ["order_approved_at"],
                   ["order_delivered_carrier_date"],
                   ["order_estimated_delivery_date"]
               ORDER BY review_id
           ) AS rn
    FROM Satisfaction
)
DELETE FROM Doublons
WHERE rn > 1;

--**************************************************************************************************************************************

-- Table Vendeurs
select * from Vendeurs
-- Valeurs manquantes(nulles)
SELECT 
    SUM(CASE WHEN ["seller_state"] is null THEN 1 ELSE 0 END) AS NbreNull_seller_state,
    SUM(CASE WHEN ["seller_city"] is null THEN 1 ELSE 0 END) AS NbreNull_seller_city,
    SUM(CASE WHEN ["seller_zip_code_prefix"] is null THEN 1 ELSE 0 END) AS NbreNull_seller_zip_code_prefix,
    SUM(CASE WHEN ["freight_value"] is null THEN 1 ELSE 0 END) AS NbreNull_freight_value,
    SUM(CASE WHEN ["order_id"] is null THEN 1 ELSE 0 END) AS NbreNull_order_id,
    SUM(CASE WHEN ["order_item_id"] is null THEN 1 ELSE 0 END) AS NbreNull_order_item_id,
    SUM(CASE WHEN ["product_id"] is null THEN 1 ELSE 0 END) AS NbreNull_product_id,
    SUM(CASE WHEN ["seller_id"] is null THEN 1 ELSE 0 END) AS NbreNull_seller_id,
    SUM(CASE WHEN ["shipping_limit_date"] is null THEN 1 ELSE 0 END) AS NbreNull_shipping_limit_date,
	SUM(CASE WHEN ["price"] is null THEN 1 ELSE 0 END) AS NbreNull_price
FROM Vendeurs;

--Doublons
select ["order_id"], ["order_item_id"], ["product_id"], ["seller_id"], ["shipping_limit_date"], ["price"],
["freight_value"], ["seller_zip_code_prefix"], ["seller_city"], ["seller_state"], COUNT(*) as Doublons
from Vendeurs
Group by ["order_id"], ["order_item_id"], ["product_id"], ["seller_id"], ["shipping_limit_date"], ["price"],
["freight_value"], ["seller_zip_code_prefix"], ["seller_city"], ["seller_state"]
having COUNT(*)>1

-- Verification si les variables quantitatives ne contiennent pas des valeurs qualitatives 
select ["price"], ["freight_value"], ["seller_zip_code_prefix"]
from Vendeurs 
where ["price"] not like '%[0-9]%' or ["freight_value"] not like '%[0-9]%' and ["seller_zip_code_prefix"] not like '%[0-9]%'

-- Code postal incohérent
select ["seller_zip_code_prefix"]
from Vendeurs
where len(["seller_zip_code_prefix"]) != 5

--Reporting
-- Il n y a aucune valeur manquante 
-- Il n y a aucun doublon 
-- Il n y a pas de valeur qualitative dans les colonnes de variables quantitatives 
-- Aucun code postal avec une longueur de chiffre différent de 5

--NETTOYAGE De Vendeurs
-- Standardisation de la date
-- Retrait des ponctuations non significatives

update Vendeurs
set ["shipping_limit_date"] = cast(["shipping_limit_date"] as date)

-- Retrait des ponctuations non significatives
update Vendeurs
set ["order_id"] = replace(["order_id"], '"', ''),
	["order_item_id"] = replace(["order_item_id"], '"', ''), 
	["product_id"] = replace(["product_id"], '"', ''), 
	["seller_id"] = replace(["seller_id"], '"', ''), 
	["shipping_limit_date"] = replace(["shipping_limit_date"], '"', ''), 
	["price"] = replace(["price"], '"', ''),
	["freight_value"] = replace(["freight_value"], '"', ''), 
	["seller_zip_code_prefix"] = replace(["seller_zip_code_prefix"], '"', ''), 
	["seller_city"] = replace(["seller_city"], '"', ''), 
	["seller_state"] = replace(["seller_state"], '"', '')

--**************************************************************************************************************************************

-- Table Ventes
select * from Ventes
-- Valeurs manquantes(nulles)
SELECT 
    SUM(CASE WHEN ["payment_installments"] is null THEN 1 ELSE 0 END) AS NbreNull_payment_installments,
    SUM(CASE WHEN ["payment_type"] is null THEN 1 ELSE 0 END) AS NbreNull_payment_type,
    SUM(CASE WHEN ["payment_sequential"] is null THEN 1 ELSE 0 END) AS NbreNull_payment_sequential,
    SUM(CASE WHEN ["payment_value"] is null THEN 1 ELSE 0 END) AS NbreNull_payment_value,
    SUM(CASE WHEN ["order_id"] is null THEN 1 ELSE 0 END) AS NbreNull_order_id,
    SUM(CASE WHEN ["customer_id"] is null THEN 1 ELSE 0 END) AS NbreNull_customer_id,
    SUM(CASE WHEN ["order_status"] is null THEN 1 ELSE 0 END) AS NbreNull_order_status,
    SUM(CASE WHEN ["order_purchase_timestamp"] is null THEN 1 ELSE 0 END) AS NbreNull_order_purchase_timestamp,
    SUM(CASE WHEN ["order_approved_at"] is null THEN 1 ELSE 0 END) AS NbreNull_order_approved_at,
	SUM(CASE WHEN ["order_delivered_carrier_date"] is null THEN 1 ELSE 0 END) AS NbreNull_order_delivered_carrier_date,
	SUM(CASE WHEN ["order_estimated_delivery_date"] is null THEN 1 ELSE 0 END) AS NbreNull_order_estimated_delivery_date
FROM Ventes;

--Doublons
select ["order_id"], ["payment_installments"], ["payment_type"], ["payment_sequential"], ["payment_value"],
["customer_id"], ["order_status"], ["order_purchase_timestamp"], ["order_approved_at"],
["order_delivered_carrier_date"], ["order_estimated_delivery_date"], COUNT(*) as Doublons
from Ventes
Group by ["order_id"], ["payment_installments"], ["payment_type"], ["payment_sequential"], ["payment_value"],
["customer_id"], ["order_status"], ["order_purchase_timestamp"], ["order_approved_at"],
["order_delivered_carrier_date"], ["order_estimated_delivery_date"]
having COUNT(*)>1

select ["payment_value"]
from Ventes
where ["payment_value"] not like '%[0-9]%' or cast(["payment_value"] as float)<0

--Reporting
-- Il n y a aucune valeur manquante
-- Il y a des colonnes de dates non standardisée
-- Il n y a aucun doublon
-- Il n y a pas de valeur incohérente

-- NETTOYAGE DE Ventes
--standardisation des colonnes de dates
update Ventes
set ["order_purchase_timestamp"] = cast(["order_purchase_timestamp"] as date),
	["order_approved_at"] = cast(["order_approved_at"] as date),
	["order_delivered_carrier_date"] = cast(["order_delivered_carrier_date"] as date),
	["order_estimated_delivery_date"] = cast(["order_estimated_delivery_date"] as date)


	use[PROJET_OLIST]
	select * from Satisfaction
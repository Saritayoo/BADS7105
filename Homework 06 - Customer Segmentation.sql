create table view_customer as
with Prep_data as (
 SELECT 
    SHOP_DATE ,QUANTITY, SPEND, BASKET_ID,CUST_CODE,SHOP_HOUR,
    SUBSTR(CAST(SHOP_DATE AS STRING),0,4) AS year,
    SUBSTR(CAST(SHOP_DATE AS STRING), 5,2) AS month,
    SUBSTR(CAST(SHOP_DATE AS STRING), 7,2) AS day,
    SUBSTR(CAST(SHOP_DATE AS STRING), 0,6) AS yearmonth,

    CUST_CODE,SHOP_HOUR,
    IF(SHOP_HOUR >= 0 and SHOP_HOUR < 12, 1, NULL ) AS morning,
    IF(SHOP_HOUR >= 12 and SHOP_HOUR < 17, 1, NULL ) AS afternoon,
    IF(SHOP_HOUR >= 18, 1, NULL ) AS night,

    IF(SHOP_HOUR < 12, SPEND, NULL ) AS morning_spend,
    IF(SHOP_HOUR < 18, SPEND, NULL ) AS afternoon_spend,
    IF(SHOP_HOUR >= 18, SPEND, NULL ) AS night_spend,
    
    SHOP_WEEKDAY ,
    IF(SHOP_WEEKDAY IN (1,7), BASKET_ID, NULL ) AS weekend,
    IF(SHOP_WEEKDAY NOT IN (1,7), BASKET_ID, NULL ) AS weekday,

    IF(SHOP_WEEKDAY IN (1,7), SPEND, NULL ) AS weekend_spend,
    IF(SHOP_WEEKDAY NOT IN (1,7), SPEND, NULL ) AS weekday_spend,

    BASKET_SIZE,
    IF(BASKET_SIZE = 'S', BASKET_ID, NULL) AS S_BASKET,
    IF(BASKET_SIZE = 'M', BASKET_ID, NULL) AS M_BASKET,
    IF(BASKET_SIZE = 'L', BASKET_ID, NULL) AS L_BASKET,
    BASKET_PRICE_SENSITIVITY,
    IF(BASKET_PRICE_SENSITIVITY = 'LA', BASKET_ID, NULL) AS lessaff,
    IF(BASKET_PRICE_SENSITIVITY = 'MM', BASKET_ID, NULL) AS midmarket,
    IF(BASKET_PRICE_SENSITIVITY = 'UM', BASKET_ID, NULL) AS upmarket,
    IF(BASKET_PRICE_SENSITIVITY = 'XX', BASKET_ID, NULL) AS unclass,
    CUST_PRICE_SENSITIVITY,
    IF(CUST_PRICE_SENSITIVITY = 'LA', BASKET_ID, NULL) AS cus_lessaff,
    IF(CUST_PRICE_SENSITIVITY = 'MM', BASKET_ID, NULL) AS cus_midmarket,
    IF(CUST_PRICE_SENSITIVITY = 'UM', BASKET_ID, NULL) AS cus_upmarket,
    IF(CUST_PRICE_SENSITIVITY = 'XX', BASKET_ID, NULL) AS cus_unclass,
    BASKET_TYPE,
    IF(BASKET_TYPE = 'Small Shop', BASKET_ID, NULL) AS bas_type_small,
    IF(BASKET_TYPE = 'Top Up', BASKET_ID, NULL) AS bas_type_topup,
    IF(BASKET_TYPE = 'Full Shop', BASKET_ID, NULL) AS bas_type_full,
    IF(BASKET_TYPE = 'XX', BASKET_ID, NULL) AS bas_type_unclass,
    BASKET_DOMINANT_MISSION,
    IF(BASKET_DOMINANT_MISSION = 'Fresh',BASKET_ID, NULL ) AS bas_dom_fresh,
    IF(BASKET_DOMINANT_MISSION = 'Grocery',BASKET_ID, NULL ) AS bas_dom_grocery,
    IF(BASKET_DOMINANT_MISSION = 'Mixed',BASKET_ID, NULL ) AS bas_dom_mix,
    IF(BASKET_DOMINANT_MISSION = 'Non Food',BASKET_ID, NULL ) AS bas_dom_nonfood,
    IF(BASKET_DOMINANT_MISSION = 'XX',BASKET_ID, NULL ) AS bas_dom_unclass,
    BASKET_DOMINANT_MISSION,
    IF(BASKET_DOMINANT_MISSION = 'Fresh',SPEND, NULL ) AS bas_dom_spend_fresh,
    IF(BASKET_DOMINANT_MISSION = 'Grocery',SPEND, NULL ) AS bas_dom_spend_grocery,
    IF(BASKET_DOMINANT_MISSION = 'Mixed',SPEND, NULL ) AS bas_dom_spend_mix,
    IF(BASKET_DOMINANT_MISSION = 'Non Food',SPEND, NULL ) AS bas_dom_spend_nonfood,
    IF(BASKET_DOMINANT_MISSION = 'XX',SPEND, NULL ) AS bas_dom_spend_unclass,


FROM `nida-workshop308203.CRM.Supermarket`
WHERE CUST_CODE IS NOT NULL )

SELECT
    CUST_CODE,
    COUNT(DISTINCT morning) AS bas_morning,
    COUNT(DISTINCT afternoon) AS bas_afternoon,
    COUNT(DISTINCT night) AS bas_night,
    
    SUM(morning_spend) AS bas_spend_morning,
    SUM(afternoon_spend) AS bas_spend_afternoon,
    SUM(night_spend) AS bas_spend_night,
    SUM(SPEND) AS spend,
    SUM(QUANTITY) AS qualtity,
    COUNT(DISTINCT year) AS active_year,
    COUNT(DISTINCT yearmonth) AS active_month,
    COUNT(DISTINCT SHOP_DATE ) AS ttl_visit,
    COUNT(DISTINCT BASKET_ID) AS ttl_basket,

    COUNT(DISTINCT weekend) AS weekend,
    COUNT(DISTINCT weekday) AS weekday,

    SUM(weekend_spend) AS weekend_spend,
    SUM(weekday_spend) AS weekday_spend,
    COUNT(DISTINCT S_BASKET) AS BASKET_S,
    COUNT(DISTINCT M_BASKET) AS BASKET_M,
    COUNT(DISTINCT L_BASKET) AS BASKET_L,

    COUNT(DISTINCT lessaff) AS bas_lessaff,
    COUNT(DISTINCT midmarket) AS bas_midmarket,
    COUNT(DISTINCT upmarket) AS bas_upmarket,
    COUNT(DISTINCT unclass) AS bas_unclass,

    COUNT(DISTINCT cus_lessaff) AS cus_lessaff,
    COUNT(DISTINCT cus_midmarket) AS cus_midmarket,
    COUNT(DISTINCT cus_upmarket) AS cus_upmarket,
    COUNT(DISTINCT cus_unclass) AS cus_unclass,

    COUNT(DISTINCT bas_type_small) AS bas_type_small,
    COUNT(DISTINCT bas_type_topup) AS bas_type_topup,
    COUNT(DISTINCT bas_type_full) AS bas_type_full,
    COUNT(DISTINCT bas_type_unclass) AS bas_type_unclass,

    COUNT(DISTINCT bas_dom_fresh) AS bas_dom_fresh,
    COUNT(DISTINCT bas_dom_grocery) AS bas_dom_grocery,
    COUNT(DISTINCT bas_dom_mix) AS bas_dom_mix,
    COUNT(DISTINCT bas_dom_nonfood) AS bas_dom_nonfood,
    COUNT(DISTINCT bas_dom_unclass) AS bas_dom_unclass,

    SUM(bas_dom_spend_fresh) AS bas_dom_spend_fresh,
    SUM(bas_dom_spend_grocery) AS bas_dom_spend_grocery,
    SUM(bas_dom_spend_mix) AS bas_dom_spend_mix,
    SUM(bas_dom_spend_nonfood) AS bas_dom_spend_nonfood,
    SUM(bas_dom_spend_unclass) AS bas_dom_spend_unclass,


FROM Prep_data
GROUP BY CUST_CODE

---------------------------------------------------------------------------------------

SELECT 
    * EXCEPT(NEAREST_CENTROIDS_DISTANCE)
FROM ML.PREDICT( MODEL `nida-workshop308203.CRM.keams_model`,
(SELECT * FROM `nida-workshop308203.CRM.view_customer`))
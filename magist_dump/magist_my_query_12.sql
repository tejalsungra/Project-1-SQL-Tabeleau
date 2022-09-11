SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM magist;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
USE magist;
-- In relation to the products:

-- 1. What categories of tech products does Magist have?
SELECT DISTINCT
    product_category_name_english AS tech_products
FROM
    product_category_name_translation
GROUP BY (product_category_name_english)
ORDER BY (product_category_name_english) ASC;
-- TECH Categories  : air_condinioning, audio, auto, cds_dvds_musicals, computers, computers_accessories, consoles_games, dvds_blu_ray, electronics, home_appliances,home_appliances_2, home_comfort, home_comfort_2, pc_gamer, signaling_and_security, small_appliances, small_appliances_home_oven, tablets_printing_image
-- TOTAL TECH categories : 18

-- TECH Categries used: computers, computer_accesories, console_games, electronics, music, tablet_printing


-- 2. How many products of these tech categories have been sold (within the time window of the database snapshot)? 
-- What percentage does that represent from the overall number of products sold?
SELECT*FROM products;
#####   products of these tech categories have been sold #### -- 1834
SELECT DISTINCT
    COUNT(order_id) #, product_category_name_english
FROM
    order_items AS oi
        INNER JOIN
    products AS p ON oi.product_id = p.product_id
        INNER JOIN
    product_category_name_translation AS pt ON pt.product_category_name = p.product_category_name
WHERE
    product_category_name_english IN ('audio' , 'computers',
        'computer_accessories',
        'consoles_games',
        'music',
        'pc_gamer',
        #'sports_leisure',
        'tablets_printing_image');
GROUP BY product_category_name_english;

SELECT DISTINCT
    COUNT(order_id)*100/32951 #, product_category_name_english
FROM
    order_items AS oi
        INNER JOIN
    products AS p ON oi.product_id = p.product_id
        INNER JOIN
    product_category_name_translation AS pt ON pt.product_category_name = p.product_category_name
WHERE
    product_category_name_english IN ('audio' , 'computers',
        'computer_accessories',
        'consoles_games',
        'music',
        'pc_gamer',
        #'sports_leisure',
        'tablets_printing_image');
#GROUP BY product_category_name_english;

-- 3. What’s the average price of the products being sold?

SELECT DISTINCT
    product_category_name_english, AVG(price) AS average_price
FROM
    order_items AS oi
        INNER JOIN
    products AS p ON oi.product_id = p.product_id
        INNER JOIN
    product_category_name_translation AS pt ON pt.product_category_name = p.product_category_name
WHERE
    product_category_name_english IN ('audio' , 'computers',
        'computer_accessories',
        'consoles_games',
        'music',
        'pc_gamer',
        #'sports_leisure',
        'tablets_printing_image')
GROUP BY product_category_name_english;



-- 4. Are expensive tech products popular? *
#* TIP: Look at the function CASE WHEN to accomplish this task.

SELECT DISTINCT
    product_category_name_english,
    CASE
        WHEN review_score < 3 THEN 'popular'
        ELSE 'not_popular'
    END AS popularity
FROM
    order_reviews AS orv
        INNER JOIN
    order_items AS oi ON orv.order_id = oi.order_id
        INNER JOIN
    products AS p ON p.product_id = oi.product_id
        INNER JOIN
    product_category_name_translation AS pt ON pt.product_category_name = p.product_category_name
WHERE
    product_category_name_english IN ('audio' , 'computers',
        'computer_accessories',
        'consoles_games',
        'music',
        'pc_gamer',
        'sports_leisure',
        'tablets_printing_image')
GROUP BY product_category_name_english;
 
  



-- In relation to the sellers:

-- 1. How many months of data are included in the magist database?
SELECT 
    MAX(order_purchase_timestamp) AS last_purchased_date,
    MIN(order_purchase_timestamp) AS first_purchased_date
FROM
    orders;
SELECT TIMESTAMPDIFF( MONTH, '2016-09-04 23:15:19', '2018-10-17 19:30:18') AS 'no_of_months';
-- 25 months

-- 2. How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers?
SELECT DISTINCT COUNT(seller_id) FROM sellers ; # no. of sellers #
-- 3095

#no. of Tech sellers#
SELECT DISTINCT
    COUNT(s.seller_id), product_category_name_english
FROM
    sellers AS s
        INNER JOIN
    order_items AS oi ON s.seller_id = oi.seller_id
        INNER JOIN
    products AS p ON oi.product_id = p.product_id
        INNER JOIN
    product_category_name_translation AS pct ON pct.product_category_name = p.product_category_name
WHERE
    product_category_name_english IN ('audio' , 'computers',
        'computer_accessories',
        'consoles_games',
        'music',
        'pc_gamer',
        'sports_leisure',
        'tablets_printing_image')
GROUP BY product_category_name_english;
 
 # % of tech sellers #
SELECT 
    COUNT(s.seller_id) * 100 / (SELECT 
            COUNT(seller_id)
        FROM
            sellers) AS percentage_tech_sellers,
    product_category_name_english
FROM
    sellers AS s
        INNER JOIN
    order_items AS oi ON s.seller_id = oi.seller_id
        INNER JOIN
    products AS p ON oi.product_id = p.product_id
        INNER JOIN
    product_category_name_translation AS pct ON pct.product_category_name = p.product_category_name
WHERE
    (product_category_name_english) IN ('audio' , 'computers',
        'computer_accessories',
        'consoles_games',
        'music',
        'pc_gamer',
        'sports_leisure',
        'tablets_printing_image')
GROUP BY product_category_name_english;



-- 3. What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?
SELECT * FROM order_payments;
#### Total amount earned by the sellers =  payment_value - (price)
SELECT 
    SUM(payment_value - price) AS sellers_earned
FROM
    order_payments AS op
        INNER JOIN
    order_items AS oi ON op.order_id = oi.order_id;
    -- 6099019.521

###### Total amount earned by tech sellers
SELECT 
    product_category_name_english,
    SUM(payment_value - price) AS sellers_earned
FROM
    order_payments AS op
        INNER JOIN
    order_items AS oi ON op.order_id = oi.order_id
        INNER JOIN
    products AS p ON p.product_id = oi.product_id
        INNER JOIN
    product_category_name_translation AS pt ON p.product_category_name = pt.product_category_name
WHERE
    (product_category_name_english) IN ('audio', 'computers',
        'computer_accessories',
        'consoles_games',
        'music',
        'pc_gamer',
        'sports_leisure',
        'tablets_printing_image')
	GROUP BY product_category_name_english ;




-- 4. Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?


#In relation to the delivery time:

-- 1. What’s the average time between the order being placed and the product being delivered?
#SELECT order_purchase_timestamp, order_delivered_customer_date, AVG(TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date)) AS no_of_days

SELECT 
    ROUND(AVG(TIMESTAMPDIFF(DAY,
                order_purchase_timestamp,
                order_delivered_customer_date))) AS no_of_days
FROM
    orders;
    
    --  12 days

#GROUP BY order_purchase_timestamp, order_delivered_customer_date;
#HAVING AVG(no_of_days) = 'avg_no_of_days';

-- 2. How many orders are delivered on time vs orders delivered with a delay?

SELECT 
    CASE
        WHEN DATE(order_delivered_customer_date) <= DATE(order_estimated_delivery_date) THEN 'DELIVERED'
        ELSE 'Delayed'
    END AS delivery_status,
    COUNT(order_id) AS order_count
FROM
    orders
WHERE
    order_status = 'delivered'
GROUP BY delivery_status;



-- 3. Is there any pattern for delayed orders, e.g. big products being delayed more often?
######### Refer Tabaleau dashboard   ###
SELECT 
    MAX(product_weight_g) AS Heaviest,
    MIN(product_weight_g) AS lightest
FROM
    products AS p
    INNER JOIN product_category_name_translation AS pct
    ON p.product_category_name = pct.product_category_name
WHERE
    (product_category_name_english) IN ('audio' , 'computers',
        'computer_accessories',
        'consoles_games',
        'music',
        'pc_gamer',
        'tablets_printing_image');

SELECT DISTINCT
    product_category_name_english,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    product_weight_g
FROM
    products AS p
        INNER JOIN
    order_items AS oi ON p.product_id = oi.product_id
        INNER JOIN
    orders AS o ON oi.order_id = o.order_id
        INNER JOIN
    product_category_name_translation AS pct ON pct.product_category_name = p.product_category_name
WHERE
    (product_category_name_english) IN ('audio' , 'computers',
        'computer_accessories',
        'consoles_games',
        'music',
        'pc_gamer',
        'tablets_printing_image')
GROUP BY product_category_name_english , order_delivered_customer_date , order_estimated_delivery_date , product_weight_g
HAVING DATE(order_delivered_customer_date) >= DATE(order_estimated_delivery_date)
ORDER BY DATE(order_delivered_customer_date) >= DATE(order_estimated_delivery_date) DESC;

# No concrete pattern based on product dimensions and delivery date observed. 




USE magist;

#no. of orders in the dataset
SELECT COUNT(order_id) FROM magist.orders;

# Are orders actually delivered?
-- SELECT COUNT(review_id) FROM magist.order_reviews;
SELECT 
    order_status, 
    COUNT(*) AS orders
FROM
    orders
GROUP BY order_status;
# Is Magist having user growth?
SELECT   
 YEAR(order_purchase_timestamp) AS y,
 MONTH(order_purchase_timestamp) AS m, COUNT(customer_id)FROM orders
GROUP BY y, m ;


# How many products are there in the products table?
SELECT   COUNT(DISTINCT product_id) FROM magist.products;


# Which are the categories with most products? : Watches_gifts
SELECT * FROM magist.products;
SELECT COUNT( DISTINCT product_id)  FROM magist.products
GROUP BY product_category_name;

SELECT 
    product_category_name, 
    COUNT(DISTINCT product_id) AS n_products
FROM
    products
GROUP BY product_category_name
ORDER BY COUNT(product_id) DESC;
# How many of those products were present in actual transactions?



# What’s the price for the most expensive and cheapest products? 
SELECT  MAX(price), MIN(price)
FROM order_items; # AS oi
#INNER JOIN products AS p
#ON oi.product_id = p.product_id;



SELECT 
    MIN(price) AS cheapest, 
    MAX(price) AS most_expensive
FROM 
	order_items;

# What are the highest and lowest payment values? 
SELECT 
MAX(payment_value),
MIN(payment_value)
 FROM magist.order_payments;
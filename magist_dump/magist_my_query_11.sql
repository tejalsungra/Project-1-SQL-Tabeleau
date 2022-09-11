USE magist;
SELECT*FROM orders;

#no. of orders in the dataset
SELECT COUNT(order_id) FROM orders;

# Are orders actually delivered?
SELECT order_status, COUNT(*)FROM orders
GROUP BY order_status;


# Is Magist having user growth?
SELECT customer_id, COUNT(*) FROM orders
GROUP BY customer_id;


# How many products are there in the products table?
SELECT DISTINCT COUNT(product_id) FROM products;


# Which are the categories with most products?
SELECT DISTINCT product_category_name, COUNT(product_category_name) FROM products
GROUP BY product_category_name
ORDER BY COUNT(product_category_name) DESC;



# How many of those products were present in actual transactions?
SELECT * FROM products;
SELECT * FROM order_items;
SELECT 
	count(DISTINCT product_id)
FROM
	order_items;
    
# What’s the price for the most expensive and cheapest products? 
SELECT
MAX(price) AS 'Expensive', MIN(price)AS 'Cheapest'
 FROM order_items;
# What are the highest and lowest payment values? 
SELECT 
MAX(payment_value) AS 'Highest', 
MIN(payment_value) AS 'Lowest' 
 FROM order_payments;
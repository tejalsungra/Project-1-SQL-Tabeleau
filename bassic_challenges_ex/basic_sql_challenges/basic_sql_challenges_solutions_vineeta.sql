/*

INTRODUCTION TO SQL
------------------------------------------------------------------------------------------------
HOW TO RUN A LINE OF CODE:

* Windows/Linux: Ctrl + enter
* MacOS: Cmd + enter

HOW TO GET THE SCHEMA OF A DATABASE: 
* Windows/Linux: Ctrl + r
* MacOS: Cmd + r

BEST PRACTICES
------------------------------------------------------------------------------------------------

*SQL is not case sensitive but it is good practice to type commands in capitals
*Every query must end with a semicolon. In SQL, queries can have multiple lines: this is how you specify that a query has ended. 
The last query of a script will work without a semicolon, but as soon as you write a new one (A new query starts with the select statement),
if there is not a semicolon in between the queries, you will get an error message.
*Make sure the clauses are structured in the proper order: 
SELECT – FROM – WHERE – GROUP BY – HAVING – ORDER BY – LIMIT.
*It’s worth noting that a column alias can’t be used in the WHERE clause.
The reason for this is that MySQL examines the WHERE clause before the SELECT clause: 
it therefore won’t know of the alias.
*/

/**************************
***************************
CHALLENGES
***************************
**************************/

-- In SQL we can have many databases, they will show up in the schemas list
-- We must first define which database we will be working with
USE publications; 

/**************************
DESCRIBE
**************************/
-- Using the schema
SELECT *
FROM information_schema.columns
WHERE table_schema = 'publications';

/*DESCRIBE authors;*/

/**************************
SELECT
**************************/
-- https://www.w3schools.com/sql/sql_select.asp

-- 1. Select everything from the table authors
SELECT 
    *
FROM
    employee; 

-- 2. Select the authors first and last name
SELECT 
    au_fname, au_lname
FROM
    authors;

-- 3. Select the first name and the last name and merge them in one column by using the CONCAT() function 
-- https://www.w3schools.com/sql/func_mysql_concat.asp
-- remember that you have to separate the two columns by adding space 
SELECT 
    CONCAT(au_fname, ' ', au_lname)
FROM
    authors;

-- You can add a character in between words, make sure the character is in single quotations.
SELECT 
    CONCAT(au_fname, '-', au_lname)
FROM
    authors;
-- 4. Select the distinct first names in authors
-- https://www.w3schools.com/sql/sql_distinct.asp
-- DISTINCT always operates on all columns in the final result
-- DISTINCT is not a function, it is a tag or a modifier
-- https://weblogs.sqlteam.com/jeffs/2007/10/12/sql-distinct-group-by/
-- https://stackoverflow.com/questions/37909808/distinct-as-a-clause-or-a-function
SELECT DISTINCT
    au_fname,au_lname
FROM
    authors;

/**************************
WHERE
**************************/
-- https://www.w3schools.com/sql/sql_where.asp

-- 5. Select first and last name from authors who have the last name "Ringer"
SELECT 
    au_fname, au_lname
FROM
    authors
WHERE
    au_lname = 'White';

-- 6. Select first and last name from authors whose last name is "Ringer" and fist name is "Anne"
-- https://www.w3schools.com/sql/sql_and_or.asp
SELECT 
    au_fname, au_lname
FROM
    authors
WHERE
    au_lname = 'Ringer'
        AND au_fname = 'Anne';

-- 7. Select first name, last name, and city from authors whose city is "Oakland" or "Berkeley", and first name is "Dean"
-- HINT: parenthesis "()" can help
SELECT 
    au_fname, au_lname, city
FROM
    authors
WHERE
	 au_fname = 'Dean' AND
		(city = 'Oakland' OR city = 'Berkeley');
        

-- 8. Select first, last name, and city from authors whose city is "Oakland" or "Berkeley", and last name is NOT "Straight"
-- Using !=
SELECT 
    *
FROM
    authors
WHERE
    (city = 'Oakland' OR city = 'Berkeley')
        AND au_lname != 'Straight';
-- Using NOT        
SELECT 
    *
FROM
    authors
WHERE
    (city = 'Oakland' OR city = 'Berkeley')
		AND NOT au_lname 'Straight';
 -- Using <>        
SELECT au_fname, au_lname, city
FROM authors
WHERE au_lname <> "Straight" AND 
(city = "Oakland" OR  city = "Berkeley");

/**************************
ORDER BY
**************************/
-- https://www.w3schools.com/sql/sql_orderby.asp
-- Default is ASC

-- 9. Select the title and ytd_sales from the table titles. Order them by the year to date sales in descending order
SELECT 
    title, ytd_sales
FROM
    titles
ORDER BY ytd_sales DESC;

/**************************
LIMIT
**************************/
-- https://www.w3schools.com/sql/sql_top.asp

-- 10. Select the top 5 titles with more ytd_sales from the table titles
SELECT 
    title, ytd_sales
FROM
    titles
ORDER BY ytd_sales DESC
LIMIT 5;

/**************************
MIN and MAX
**************************/
-- https://www.w3schools.com/sql/sql_min_max.asp

-- 11. Select the minimum and maximum quantity in table sales. 
SELECT 
    MIN(qty), MAX(qty)
FROM
    sales;

/**************************
COUNT, AVG, and SUM
**************************/
-- https://www.w3schools.com/sql/sql_count_avg_sum.asp

-- 12. Select the count, average and sum of quantity in the table sales
SELECT 
    COUNT(qty), AVG(qty), SUM(qty)
FROM
    sales;

/**************************
LIKE
**************************/
-- https://www.w3schools.com/sql/sql_like.asp

/*
Here we will also learn to use some wild card characters
https://www.w3schools.com/sql/sql_wildcards.asp
You can ignore 'Wildcard Characters in MS Access'
You need to look at the section 'Wildcard Characters in SQL Server'
*/

-- 13. Select all books from the table title that contains the word "cooking"
-- LIKE is not case sensitive. It works on upper and lower case.
SELECT 
    *
FROM
    titles
WHERE
    title LIKE '%with%';

-- 14. Select all books that have an "ing" in the title, with at least 4 other characters preceding it
-- for example 'cooking' has 4 characters before the 'ing', so this should be included
-- 'sewing' has only 3 characters before the 'ing', so this shouldn't be included
SELECT 
    *
FROM
    titles
WHERE
    title LIKE '%___ing%';

/**************************
IN
**************************/
-- https://www.w3schools.com/sql/sql_in.asp

-- 15. Select all the authors from the author table that do not come from the cities Salt Lake City, Ann Arbor, and Oakland.
-- IN always expects a list
SELECT 
    *
FROM
    authors
WHERE
    city IN ('Salt Lake City' , 'Ann Arbor', 'Oakland');
 -- Using NOT   
SELECT 
    *
FROM
    authors
WHERE
    city NOT IN ('Salt Lake City' , 'Ann Arbor', 'Oakland');

/*
The differences between IN, LIKE, and =

IN : takes many values to look for, such as a list of values, and does not work with the wildcards.
= : takes only one value to look for and does not work with wildcards.
LIKE: takes only one value to look for and works with wildcards. It is also case insentsitive
*/

/**************************
BETWEEN
**************************/
-- https://www.w3schools.com/sql/sql_between.asp

-- 16. Select all the order numbers with a quantity sold between 25 and 45 from the table sales
-- https://stackoverflow.com/questions/15573959/how-to-select-particular-range-of-values-in-mysql-table
-- For numeric values the starting value and ending value are included
SELECT 
    *
FROM
    sales
WHERE
    qty BETWEEN 50 AND 75;

-- For strings First alphabet is always included.    
SELECT *
FROM sales
WHERE title_id BETWEEN 'B' AND 'Q';



-- 17. Select all the orders between 1993-03-11 and 1994-09-13
-- For dates, the format can be 1993-03-11 or 1993/03/11 MySQL understand both
SELECT 
    *
FROM
    sales
WHERE
    ord_date BETWEEN '1993-03-11' AND '1994-09-13';

/**************************
GROUP BY
**************************/
--  https://www.w3schools.com/sql/sql_groupby.asp

-- 18. Find the total amount of authors for each state 
SELECT 
    state, COUNT(*)
FROM
    authors
GROUP BY state;

-- 19. Find the total amount of authors by each state and order them in descending order
SELECT 
    state, COUNT(*)
FROM
    authors
GROUP BY state
ORDER BY COUNT(*) DESC;

-- 20. Select the maximum price for each publisher id in the table titles.
SELECT 
    pub_id, MIN(price)
FROM
    titles
GROUP BY pub_id;

-- 21. Find out the top 3 stores with the most sales
SELECT 
    stor_id, SUM(qty)
FROM
    sales
GROUP BY stor_id
ORDER BY SUM(qty) DESC
LIMIT 3;

/**************************
HAVING
**************************/
-- https://www.w3schools.com/sql/sql_having.asp

-- 22. Select, for each publisher, the total number of titles from each book type, with an average price higher than 12
SELECT 
    pub_id, type, COUNT(*)
FROM
    titles
GROUP BY pub_id , type
HAVING AVG(price) > 12;

-- 23. Select, from each publisher, the total number of titles for each book type, with an average price higher than 12 and order them by the average price
SELECT 
    pub_id, type, COUNT(*), AVG(price)
FROM
    titles
GROUP BY pub_id , type
HAVING AVG(price) > 12
ORDER BY AVG(price);

-- 24. Select all the states and cities that have more than 1 contract
SELECT 
    state, city, SUM(contract)
FROM
    authors
GROUP BY state , city
HAVING SUM(contract) > 1
ORDER BY city; -- ORDER BY will order the results alphabetically too

/* 
The main difference between WHERE and HAVING is that:
the WHERE clause is used to specify a condition for filtering most records,
the HAVING clause is used to specify a condition for filtering values from an aggregate (such as MAX(), AVG(), COUNT() etc...)
 */

/**************************
FINAL CHALLENGES
**************************/

-- 25. Select the top 5 orders with most quantity sold between 1993-03-11 and 1994-09-13 from the table sales
SELECT 
    *
FROM
    sales
WHERE
    ord_date BETWEEN '1993-03-11' AND '1994-09-13'
ORDER BY qty DESC
LIMIT 5;

-- 26. How many authors have an "i" in their first name, and have the state UT, MD, or KS
SELECT 
    COUNT(*)
FROM
    authors
WHERE
    au_fname LIKE '%i%'
        AND state IN ('UT' , 'MD', 'KS');

-- 27. In California, how many authors are there in cities that contain an "o" in the name?
-- Show only results for cities with more than 1 author.
-- Sort the cities ascendingly by author count.
SELECT 
    city, COUNT(au_fname)
FROM
    authors
WHERE
    state = 'CA' AND city LIKE '%o%'
GROUP BY city
HAVING COUNT(au_fname) > 1
ORDER BY COUNT(au_fname);




--order status percentage
SELECT 
    order_status,
    COUNT(*) AS status_count,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) from [SQL Portfolio Project]..olist_orders_dataset)) AS percentage
FROM 
    [SQL Portfolio Project]..olist_orders_dataset
GROUP BY 
    order_status
order by status_count desc;


--no of customer by city
select customer_city, count(customer_id) as no_of_customer
from olist_customers_dataset
group by customer_city
order by no_of_customer desc;

--no of customer by state
select customer_state, count(customer_id) as no_of_customer
from olist_customers_dataset
group by customer_state
order by no_of_customer desc;


--no of orders per customer
SELECT c.customer_unique_id, COUNT(o.order_id) AS total_orders
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
ORDER BY total_orders DESC;


--revenue per customer
SELECT distinct c.customer_unique_id, SUM(distinct p.payment_value) AS total_spent, COUNT(distinct o.order_id) AS total_orders
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
ON c.customer_id = o.customer_id
JOIN olist_order_payments_dataset p
ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spent desc




--top 10 customers
SELECT  top 10
c.customer_unique_id, SUM( p.payment_value) AS total_spent
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
ON c.customer_id = o.customer_id
JOIN olist_order_payments_dataset p
ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC;




--rename the column names of table product_category_name_translation
Exec sp_rename 'product_category_name_translation.column1', 'product_category_name', 'COLUMN';
Exec sp_rename 'product_category_name_translation.column2', 'translation', 'COLUMN';


--no of orders per category
select product_category_name_translation.translation as category, count(distinct olist_products_dataset.product_id)as no_of_order from olist_products_dataset 
join product_category_name_translation 
on olist_products_dataset.product_category_name = product_category_name_translation.product_category_name
group by olist_products_dataset.product_category_name, product_category_name_translation.translation
order by no_of_order asc;

SELECT olist_products_dataset.product_category_name as original_category_name, product_category_name_translation.translation translated_category_name,count(distinct olist_products_dataset.product_id) as no_of_order
FROM olist_products_dataset
JOIN product_category_name_translation
ON olist_products_dataset.product_category_name = product_category_name_translation.product_category_name
group by olist_products_dataset.product_category_name, product_category_name_translation.translation
order by no_of_order desc;


--top 20 products by revenue and their price
SELECT top 20 
	olist_order_items_dataset.price, product_category_name_translation.translation AS category,
    SUM(olist_order_items_dataset.price + olist_order_items_dataset.freight_value) AS total_revenue
FROM 
    olist_products_dataset
join olist_order_items_dataset
on olist_products_dataset.product_id = olist_order_items_dataset.product_id
JOIN 
    product_category_name_translation
    ON olist_products_dataset.product_category_name = product_category_name_translation.product_category_name
GROUP BY 
	product_category_name_translation.translation, olist_order_items_dataset.price
ORDER BY 
    total_revenue DESC

--products by orders
SELECT top 20 
	product_category_name_translation.translation AS category,
    count(olist_order_items_dataset.order_id) AS total_orders
FROM 
    olist_products_dataset
join olist_order_items_dataset
on olist_products_dataset.product_id = olist_order_items_dataset.product_id
JOIN 
    product_category_name_translation
    ON olist_products_dataset.product_category_name = product_category_name_translation.product_category_name
GROUP BY 
	product_category_name_translation.translation
ORDER BY 
    total_orders DESC

--revenue by state
select top 10
olist_customers_dataset.customer_state as statee,
SUM(olist_order_items_dataset.price + olist_order_items_dataset.freight_value) AS total_revenue
FROM 
    olist_order_items_dataset
JOIN 
    olist_orders_dataset 
    ON olist_order_items_dataset.order_id = olist_orders_dataset.order_id 
join olist_customers_dataset
on olist_orders_dataset.customer_id = olist_customers_dataset.customer_id
GROUP BY 
    olist_customers_dataset.customer_state
ORDER BY 
    total_revenue DESC;

--revenue by city
select top 10
olist_customers_dataset.customer_city as city,
SUM(olist_order_items_dataset.price + olist_order_items_dataset.freight_value) AS total_revenue
FROM 
    olist_order_items_dataset
JOIN 
    olist_orders_dataset 
    ON olist_order_items_dataset.order_id = olist_orders_dataset.order_id 
join olist_customers_dataset
on olist_orders_dataset.customer_id = olist_customers_dataset.customer_id
GROUP BY 
    olist_customers_dataset.customer_city
ORDER BY 
    total_revenue DESC;


--orders by city
SELECT 
    olist_customers_dataset.customer_city AS city, 
    count(olist_order_items_dataset.order_id) AS total_orders
FROM 
    olist_order_items_dataset
JOIN 
    olist_orders_dataset 
    ON olist_order_items_dataset.order_id = olist_orders_dataset.order_id
JOIN 
    olist_customers_dataset 
    ON olist_orders_dataset.customer_id = olist_customers_dataset.customer_id
GROUP BY 
    olist_customers_dataset.customer_city
ORDER BY  
    total_orders DESC;


--orders by state
SELECT 
    olist_customers_dataset.customer_state AS statee, 
    count(olist_order_items_dataset.order_id) AS total_orders
FROM 
    olist_order_items_dataset
JOIN 
    olist_orders_dataset 
    ON olist_order_items_dataset.order_id = olist_orders_dataset.order_id
JOIN 
    olist_customers_dataset 
    ON olist_orders_dataset.customer_id = olist_customers_dataset.customer_id
GROUP BY 
    olist_customers_dataset.customer_state
ORDER BY  
    total_orders DESC;


--average review score by product
select translation as category ,AVG(review_score) as average_review_score
from olist_order_reviews_dataset
join olist_orders_dataset
on olist_order_reviews_dataset.order_id = olist_orders_dataset.order_id
join olist_order_items_dataset
on olist_orders_dataset.order_id = olist_order_items_dataset.order_id
join olist_products_dataset
on olist_order_items_dataset.product_id = olist_products_dataset.product_id
join product_category_name_translation
on olist_products_dataset.product_category_name = product_category_name_translation.product_category_name
group by translation
order by average_review_score desc



--checking for error in date
SELECT 
    order_approved_at, 
    order_delivered_customer_date
FROM 
    olist_orders_dataset
WHERE 
    order_approved_at > order_delivered_customer_date;


--exchanging approved and delivery date
UPDATE olist_orders_dataset
SET order_approved_at = order_delivered_customer_date,
    order_delivered_customer_date = order_approved_at
WHERE order_approved_at > order_delivered_customer_date;



--average delivery timeline by state
SELECT avg(DATEDIFF(DAY, order_approved_at, order_delivered_customer_date)) AS Average_delivery_timeline,
customer_state
FROM olist_orders_dataset
join olist_customers_dataset
on olist_orders_dataset.customer_id = olist_customers_dataset.customer_id
group by customer_state
order by Average_delivery_timeline asc




--average timeline by product
SELECT avg(DATEDIFF(DAY, order_approved_at, order_delivered_customer_date)) AS Average_delivery_timeline,
translation as category
FROM olist_customers_dataset
join olist_orders_dataset
on olist_orders_dataset.customer_id = olist_customers_dataset.customer_id
join olist_order_items_dataset
on olist_orders_dataset.order_id = olist_order_items_dataset.order_id
join olist_products_dataset
on olist_order_items_dataset.product_id = olist_products_dataset.product_id
join product_category_name_translation
on olist_products_dataset.product_category_name = product_category_name_translation.product_category_name
group by translation
order by Average_delivery_timeline asc



--average delivery timeline by city
SELECT avg(DATEDIFF(DAY, order_approved_at, order_delivered_customer_date)) AS Average_delivery_timeline,
customer_city
FROM olist_orders_dataset
join olist_customers_dataset
on olist_orders_dataset.customer_id = olist_customers_dataset.customer_id
where order_delivered_customer_date is not null
group by customer_city
order by Average_delivery_timeline asc


-- min timeline
SELECT min(DATEDIFF(DAY, order_approved_at, order_delivered_customer_date)) AS minimum_delivery_timeline
FROM olist_orders_dataset


--review score by timeline
SELECT avg(DATEDIFF(DAY, order_approved_at, order_delivered_customer_date)) AS delivery_timeline, review_score
FROM olist_orders_dataset
join olist_order_reviews_dataset
on olist_orders_dataset.order_id = olist_order_reviews_dataset.order_id
group by review_score
order by delivery_timeline desc


--exceeded delivery percentage
select cast(sum(case
when order_delivered_customer_date > order_estimated_delivery_date then 1
else 0
end) as float)/count(*)*100 as exceeded_delivery
from olist_orders_dataset

SELECT 
    SUM(CASE 
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1
        ELSE 0 
    END) AS exceeded_deliveries,
    COUNT(*) AS total_orders,
    CAST(SUM(CASE 
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1
        ELSE 0 
    END) AS FLOAT) / COUNT(*) * 100 AS percentage_exceeded_delivery_estimate
FROM 
    olist_orders_dataset;



--on the road 
UPDATE olist_orders_dataset
SET order_delivered_carrier_date = order_delivered_customer_date,
    order_delivered_customer_date = order_delivered_carrier_date 
WHERE order_delivered_carrier_date > order_delivered_customer_date

--average delivery timeline on the road
select avg(DATEDIFF(day, order_delivered_carrier_date, order_delivered_customer_date)) as average_delivery_timeline
from olist_orders_dataset


--payment type
select payment_type, Number, total, (Number*100.0/total) as percentage 
from(
select payment_type, count(payment_type) as Number, 
(SELECT COUNT(*) FROM olist_order_payments_dataset) AS total
from olist_order_payments_dataset
group by payment_type) as subquery

select avg(payment_installments) as average_installment
from olist_order_payments_dataset

select max(payment_installments) as maximum_installment
from olist_order_payments_dataset


--number of customers by no of installments
select payment_installments, count(payment_installments) as number
from olist_order_payments_dataset
group by payment_installments
order by number desc


--average payment value by payment installments 
select payment_installments, avg(payment_value) as val
from olist_order_payments_dataset
group by payment_installments
order by val desc



--top sellers by city
select seller_city, count(seller_id) as sellers
from olist_sellers_dataset
group by seller_city
order by sellers desc



--top sellers by state
select seller_state, count(seller_id) as sellers
from olist_sellers_dataset
group by seller_state
order by sellers desc


--top products by months 
SELECT  
	product_category_name_translation.translation AS category,
    SUM(olist_order_items_dataset.price + olist_order_items_dataset.freight_value) AS total_revenue,
	DATENAME(MONTH, olist_orders_dataset.order_purchase_timestamp) AS month_name,
	YEAR(olist_orders_dataset.order_purchase_timestamp) as year
FROM olist_orders_dataset
join olist_order_items_dataset
on olist_orders_dataset.order_id = olist_order_items_dataset.order_id
join olist_products_dataset
on olist_order_items_dataset.product_id = olist_products_dataset.product_id 
join product_category_name_translation
on olist_products_dataset.product_category_name = product_category_name_translation.product_category_name
GROUP BY 
DATENAME(MONTH, olist_orders_dataset.order_purchase_timestamp),
	 MONTH(olist_orders_dataset.order_purchase_timestamp), 
	 YEAR(olist_orders_dataset.order_purchase_timestamp),
	 product_category_name_translation.translation
ORDER BY 
	YEAR(olist_orders_dataset.order_purchase_timestamp),
	MONTH(olist_orders_dataset.order_purchase_timestamp),
    total_revenue DESC



--revenue per month over the years
SELECT  
    SUM(olist_order_items_dataset.price + olist_order_items_dataset.freight_value) AS total_revenue,
DATENAME(MONTH, olist_orders_dataset.order_purchase_timestamp) AS month_name,
YEAR(olist_orders_dataset.order_purchase_timestamp) as year
FROM olist_orders_dataset
join olist_order_items_dataset
on olist_orders_dataset.order_id = olist_order_items_dataset.order_id
GROUP BY 
        YEAR(olist_orders_dataset.order_purchase_timestamp), 
		DATENAME(MONTH, olist_orders_dataset.order_purchase_timestamp),
	 MONTH(olist_orders_dataset.order_purchase_timestamp)
ORDER BY 
    year,
    	 MONTH(olist_orders_dataset.order_purchase_timestamp) asc



--top five products per year by revenue
WITH RankedProducts AS (
    SELECT  
        product_category_name_translation.translation AS category,
        SUM(olist_order_items_dataset.price + olist_order_items_dataset.freight_value) AS total_revenue,
        YEAR(olist_orders_dataset.order_purchase_timestamp) as year,
        ROW_NUMBER() OVER (PARTITION BY YEAR(olist_orders_dataset.order_purchase_timestamp) ORDER BY SUM(olist_order_items_dataset.price + olist_order_items_dataset.freight_value) DESC) AS rank
    FROM olist_orders_dataset
    JOIN olist_order_items_dataset
        ON olist_orders_dataset.order_id = olist_order_items_dataset.order_id
    JOIN olist_products_dataset
        ON olist_order_items_dataset.product_id = olist_products_dataset.product_id 
    JOIN product_category_name_translation
        ON olist_products_dataset.product_category_name = product_category_name_translation.product_category_name
    GROUP BY 
        YEAR(olist_orders_dataset.order_purchase_timestamp), product_category_name_translation.translation
)
SELECT category, total_revenue, year
FROM RankedProducts
WHERE rank <= 5
ORDER BY year, total_revenue DESC;



--least 5 products per year by revenue
WITH RankedProducts AS (
    SELECT  
        product_category_name_translation.translation AS category,
        SUM(olist_order_items_dataset.price + olist_order_items_dataset.freight_value) AS total_revenue,
        YEAR(olist_orders_dataset.order_purchase_timestamp) as year,
        ROW_NUMBER() OVER (PARTITION BY YEAR(olist_orders_dataset.order_purchase_timestamp) ORDER BY SUM(olist_order_items_dataset.price + olist_order_items_dataset.freight_value) ASC) AS rank
    FROM olist_orders_dataset
    JOIN olist_order_items_dataset
        ON olist_orders_dataset.order_id = olist_order_items_dataset.order_id
    JOIN olist_products_dataset
        ON olist_order_items_dataset.product_id = olist_products_dataset.product_id 
    JOIN product_category_name_translation
        ON olist_products_dataset.product_category_name = product_category_name_translation.product_category_name
    GROUP BY 
        YEAR(olist_orders_dataset.order_purchase_timestamp), product_category_name_translation.translation
)
SELECT category, total_revenue, year
FROM RankedProducts
WHERE rank <= 5
ORDER BY year, total_revenue ASC;



--total revenue per year
WITH RankedProducts AS (
    SELECT  
        SUM(olist_order_items_dataset.price + olist_order_items_dataset.freight_value) AS total_revenue,
        YEAR(olist_orders_dataset.order_purchase_timestamp) as year
    FROM olist_orders_dataset
    JOIN olist_order_items_dataset
        ON olist_orders_dataset.order_id = olist_order_items_dataset.order_id
	group by YEAR(olist_orders_dataset.order_purchase_timestamp)
)
SELECT total_revenue, year
FROM RankedProducts
ORDER BY year, total_revenue DESC;



--percentage of returning customers
WITH ReturningCustomers AS (
    SELECT 
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_order_date,
        MAX(o.order_purchase_timestamp) AS last_order_date,
        COUNT(o.order_id) AS total_orders
    FROM olist_customers_dataset c
    JOIN olist_orders_dataset o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(o.order_id) > 1 -- Returning customers are those with more than 1 order
)
SELECT 
    COUNT(*) AS returning_customers, 
    (COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT customer_unique_id) FROM olist_customers_dataset)) AS returning_customer_percentage
FROM ReturningCustomers;





WITH NonReturningCustomers AS (
    SELECT 
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_order_date,
        MAX(o.order_purchase_timestamp) AS last_order_date,
        COUNT(o.order_id) AS total_orders
    FROM olist_customers_dataset c
    JOIN olist_orders_dataset o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(o.order_id) <= 1 
)
SELECT 
    COUNT(*) AS non_returning_customers, 
    (COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT customer_unique_id) FROM olist_customers_dataset)) AS non_returning_customer_percentage
FROM NonReturningCustomers;

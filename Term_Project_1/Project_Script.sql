#Creating the Database

drop schema if exists brazlian_e_commerce;

Create schema brazlian_e_commerce;

use brazlian_e_commerce;

#Creating Customers Table
drop table if exists customers_dataset;
create table customers_dataset
(customer_id varchar(50) not null,
customer_unique_Id varchar(50),
customer_zipCode int,
customer_city varchar(50),
customer_state varchar(5),
primary key (customer_Id));

show variables like "secure_file_priv";

#Loading Data into the Customers Table
Load Data Infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\olist_customers_dataset.csv'
Into Table customers_dataset
Fields  Terminated By ','
optionally Enclosed by '"'
Lines Terminated By '\n'
Ignore 1 Lines
(customer_id, customer_unique_id, customer_zipCode, customer_city, customer_state);

#Creating Order Items table
drop table if exists order_items;
create table order_items
(id int not null auto_increment,
order_id varchar(50),
num_of_items_ordered int,
product_id varchar(100),
seller_id varchar(100),
shipping_limit_date datetime,
price double,
freight_value double,
primary key(id));

#Loading Data into the Order Items Table

Load Data Infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\olist_order_items_dataset.csv'
Into Table order_items
Fields  Terminated By ','
OPTIONALLY ENCLOSED BY '"'
Lines Terminated By '\n'
Ignore 1 Lines
(order_Id, num_of_items_ordered, product_id, seller_id, shipping_limit_date, price, freight_value);

#Creating Geo Location Table
#Removed the duplicate Zip Codes as they did not make much sense
drop table if exists geo_location;
create table geo_location
(zip_code int not null,
latitude double,
longitude double,
city varchar(100),
state varchar(5),
primary key(zip_code));

#Loading data into Geo Location Table
Load Data Infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\olist_geolocation_dataset.csv'
Into Table geo_location
Fields  Terminated By ','
optionally enclosed by'"'
Lines Terminated By '\r\n'
Ignore 1 Lines
(zip_code, latitude, longitude, city, state);

#Creating Order Payments Table
drop table if exists order_payments;
create table order_payments
(Id int not null auto_increment,
order_id varchar(50),
payment_sequential int,
payment_type varchar(50),
payment_installments int,
payment_value double,
primary key(Id));

#loading data into the Order Payments table
Load Data Infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\olist_order_payments_dataset.csv'
Into Table order_payments
Fields Terminated By ','
OPTIONALLY ENCLOSED BY '"'
Lines Terminated By '\n'
Ignore 1 Lines
(order_id, payment_sequential, payment_type, payment_installments, payment_value);

#Creating Order Details Table
Drop Table If Exists order_details;
Create Table order_details
(order_id varchar(50) not null,
customer_id varchar(50),
order_status varchar(50),
order_purchase_date datetime,
order_approved_date datetime,
order_delivered_carrier_date datetime,
order_delivered_customer_date datetime,
order_delivered_estimated_Date datetime,
primary key(order_id));

#Loading Data into Order Details Table
Load Data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\olist_orders_dataset.csv'
Into Table order_details
Fields Terminated By ','
Lines Terminated By '\n'
Ignore 1 Lines
(order_id, customer_id, order_status, order_purchase_date, @t_order_approved_date, @t_order_delivered_carrier_date,
@t_order_delivered_customer_date, @t_order_delivered_estimated_date)
Set
order_approved_date = nullif(@t_order_approved_date, ''),
order_delivered_carrier_date =nullif(@t_order_delivered_carrier_date, ''),
order_delivered_customer_date =nullif(@t_order_delivered_customer_date, ''),
order_delivered_estimated_date = nullif(@t_order_delivered_estimated_date, '');

#Creating Order Reviews Table without comments as they were not going to be used in my analysis
Drop Table If Exists reviews;
Create Table reviews
(Id int not null auto_increment,
review_id varchar(50),
order_id varchar(50),
review_score double,
review_creation_date date,
review_filled_date date,
primary key(Id));

#Loading Data into Order Reviews Table
Load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\olist_order_reviews_dataset.csv'
Into Table reviews
Fields Terminated By ','
Lines Terminated By '\r\n'
Ignore 1 Lines
(review_id, order_id, review_score, review_creation_date, review_filled_date);


#Creating Sellers Table
Drop Table If Exists sellers;
Create Table sellers
(seller_id varchar(50) not null,
seller_zip_code int,
seller_city varchar(100),
seller_state varchar(5),
primary key(seller_id));

#Loading data into the Sellers Table
Load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\olist_sellers_dataset.csv'
Into Table sellers
Fields Terminated By ','
Optionally Enclosed By '"'
Lines Terminated By '\n'
Ignore 1 Lines
(seller_Id, seller_zip_code, seller_city, seller_state);

#Creating Products Table
Drop Table If exists products;
Create Table products
(product_id varchar(100) not null,
product_Category varchar(150),
product_name_length int,
product_desc_length int,
product_photos_qty int,
product_weight double,
product_length double,
product_height double,
product_width double,
primary key(product_id));

#Loading Data into Products Table
Load Data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\olist_products_dataset.csv'
Into Table Products
Fields Terminated By ','
OPTIONALLY ENCLOSED BY '"'
Lines Terminated By '\n'
Ignore 1 Lines
(product_id, @t_Product_category, @t_product_name_length, @t_product_desc_length,
@t_product_photos_qty, @t_product_weight, @t_product_length, @t_product_height, @t_product_width)
Set
product_category = nullif(@t_product_category, ''),
product_name_length = nullif(@t_product_name_length, ''),
product_desc_length = nullif(@t_product_desc_length, ''),
product_photos_qty = nullif(@t_product_photos_qty, ''),
product_weight = nullif(@t_product_weight, ''),
product_length = nullif(@t_product_length, ''),
product_height = nullif(@t_product_height, ''),
product_width = nullif(@t_product_width, '');


#Creating Categories Table
Drop Table If Exists categories;
Create Table categories
(category_por varchar(150) not null,
category_eng varchar(150),
primary key(category_por));

#Loading data into Categories Table
Load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\product_category_name_translation.csv'
Into Table categories
Fields Terminated By ','
Optionally Enclosed By '"'
Lines Terminated By '\r\n'
Ignore 1 Lines
(category_por, category_eng);


#Creating a Data Warehouse through a stored procedure "Ecommmerce_DW"
#I used Common table expressions(CTE) to create 2 temporary tables that allowed me to load and join the data more efiiciently, without losing the connection to mysql server
#I also dropped the records where order_status was null as they wouldn't make much sense for the analysis
DROP PROCEDURE IF EXISTS Ecommerce_DW;

DELIMITER //

CREATE PROCEDURE Ecommerce_DW()
BEGIN
DROP TABLE IF EXISTS Ecommerce_DW;
CREATE TABLE Ecommerce_DW AS
WITH
  cte1 AS(
  SELECT op.order_id, op.payment_type, op.payment_installments, op.payment_value,

od.customer_id,od.order_status,od.order_purchase_date,od.order_approved_date,od.order_delivered_carrier_date,od.order_delivered_customer_date,
od.order_delivered_estimated_Date,

c.customer_unique_id,c.customer_city,c.customer_state,

g.latitude,g.longitude,

r.review_id,r.review_score,r.review_creation_date,r.review_filled_date

FROM order_payments op
LEFT JOIN order_details od
ON op.order_id = od.order_id
LEFT JOIN customers_dataset c
ON od.customer_id = c.customer_id
LEFT JOIN geo_location g
ON c.customer_zipCode = g.zip_code
LEFT JOIN reviews r
ON r.order_id = od.order_id

),
cte2 AS (
SELECT oi.num_of_items_ordered,oi.product_id,oi.seller_id,oi.shipping_limit_date,oi.price,oi.order_id AS 'order_id2',

s.seller_city, s.seller_state,

p.product_category,

ct.category_por, ct.category_eng

FROM order_items oi
RIGHT JOIN sellers s
ON s.seller_id = oi.seller_id
RIGHT JOIN products p
ON p.product_id = oi.product_id
RIGHT JOIN categories ct
ON ct.category_por = p.product_category
)
SELECT * FROM cte1 JOIN cte2
WHERE cte1.order_id = cte2.order_id2;

    Delete from Ecommerce_DW
	where order_status is null;

End //
Delimiter ;

Call Ecommerce_DW();

Select * from Ecommerce_DW
WHERE order_delivered_customer_date is not null and customer_unique_id is not null and customer_city is not null and latitude is not null 
LIMIT 5;


#Creating Data Mart Views to perform analysis 

#Q1. What are the TOP 5 cities where the orders were made from in terms of number of orders made for a particular year?

drop view if exists `sales_by_city`;
create view sales_by_city as
select customer_city, year(order_purchase_date) as purchase_year,order_id
from Ecommerce_DW
where order_status = 'Delivered' and customer_city is not null;

select * from sales_by_city limit 5;

Drop procedure if exists sales_by_city;

Delimiter //

Create Procedure sales_by_city(
	in order_year year
)
Begin
    
    select customer_city, purchase_year, count(order_id) as number_of_orders
    from sales_by_city
    where purchase_year = order_year
    group by customer_city
    order by number_of_orders desc
    limit 5;

End //
Delimiter ;

call sales_by_city(2018);

#Q.2 What were the most frequent modes of payment by the customers for a particular year?


drop view if exists `payment_method`;
create view payment_method as
select order_id, year(order_purchase_date) as payment_year , payment_type
from Ecommerce_DW
order by payment_year;

Drop procedure if exists payment_method;

Delimiter //

Create Procedure payment_method(
	in year_of_payment year
)
Begin
    
    select payment_type,count(payment_type) as No_of_payments
    from payment_method
    where year_of_payment = payment_year
    group by payment_type
    order by No_of_payments desc
    limit 5;

End //
Delimiter ;

call payment_method(2018);



#Q3. What are the TOP 5 states where the orders were made from in terms of revenue generated for a particular year?

drop view if exists `sales_by_state`;
create view sales_by_state as
select customer_state, year(order_purchase_date) as purchase_year,price
from Ecommerce_DW
where order_status = 'Delivered' and customer_state is not null;

select * from sales_by_state limit 5;


DROP PROCEDURE IF EXISTS sales_by_state;

DELIMITER //
Create Procedure sales_by_state(
	in order_year year
)
Begin
    
    select customer_state, purchase_year, ROUND(sum(price),2) AS Revenue
    from sales_by_state
    where purchase_year = order_year
    group by customer_state
    order by Revenue desc
    limit 5;

End //
Delimiter ;

call sales_by_state(2018);

#Q.4 Which categories were given the highest review scores in a particular year?

drop view if exists `reviews_by_category`;
create view reviews_by_category as
select review_score, year(order_purchase_date) as purchase_year,category_eng AS category
from Ecommerce_DW
where order_status = 'Delivered' and category_eng is not null;

select * from reviews_by_category limit 5;

DROP PROCEDURE IF EXISTS reviews_by_category;

DELIMITER //
Create Procedure reviews_by_category(
	in order_year year
)
Begin
    
    select category, ROUND(AVG(review_score),2) AS Average_Rating
    from reviews_by_category
    where purchase_year = order_year
    group by category
    order by Average_Rating desc
    limit 5;

End //
Delimiter ;

call reviews_by_category(2018);


#Q.5 Which sellers made the most revenue in a particular year?

drop view if exists `sellers_revenue`;
create view sellers_revenue as
select seller_id, year(order_purchase_date) as purchase_year,price
from Ecommerce_DW
where order_status = 'Delivered' and seller_id is not null;

select * from sellers_revenue limit 5;


DROP PROCEDURE IF EXISTS sellers_revenue;

DELIMITER //
Create Procedure sellers_revenue(
	in order_year year
)
Begin
    
    select seller_id, purchase_year, ROUND(sum(price),2) AS Revenue
    from sellers_revenue
    where purchase_year = order_year
    group by seller_id
    order by Revenue desc
    limit 5;

End //
Delimiter ;

call sellers_revenue(2018);













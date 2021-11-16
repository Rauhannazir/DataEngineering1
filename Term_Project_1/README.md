# Brazilian E-Commerce Public Dataset

I downloaded the dataset from [Kaggle](https://www.kaggle.com/olistbr/brazilian-ecommerce) which contains data about orders made at a Brazilian e-commerce site, Olist, from a period between 2016 and 2018.

My task in hand was to create a database for their Brazillian E-Commerce public data with the goal of answering meaning business questions.

The steps that I did to achieve this goal were in the following order.
1. Data Cleaning
2. Loading in the data into MySQL
3. Creating a Data Warehouse
4. Creating Data Marts to answer the questions directly

## Operational layer

![DataWareHouse](https://github.com/Rauhannazir/DataEngineering1/blob/main/Term_Project_1/Operational%20Layer%20Schema.png)

My Operational layer consists of 9 tables stored in .csv files.

1. *olist_customers_dataset.csv* was loaded into the **“customers_dataset”** table. It contains information about customers and their location. The primary key is the customer_id

2. *olist_order_items_dataset.csv* was loaded into the **“order_items”** table. It contains data about the items purchased within each order. The primary key is the auto-increment id that I created myself to be able to load the data as no other column was unique.

3. *olist_order_payments_dataset.csv* was loaded into the **“order_payments”** table. It contains information about the payment method and value of each order. The primary key is  the auto-increment id that I created myself to be able to load the data as no other column was unique.

4. *olist_order_reviews_dataset.csv* was loaded into the **“reviews”** table. It contains data about the reviews on each order written by the customers. The primary key is  the auto-increment id that I created myself to be able to load the data as no other column was unique.

5. *olist_orders_dataset.csv* was loaded into the **“order_details”** table. It summarizes order details about each order. The primary key is the order_id.

6. *olist_products_dataset.csv* was loaded into the **“products”** table. It contains details on the ordered product, such as its dimensions and category. The primary key is product_id.

7. *olist_sellers_dataset.csv* was loaded into the **“sellers”** table. It includes data about the sellers that fulfilled orders made at Olist. The primary key is the seller_id.

8. *product_category_name_translation.csv* was loaded into the **“categories”** table. It includes the English translation of the Portuguese category names. The primary key is category_por.

9. *olist_geolocation_dataset.csv* was loaded into the **“geo_location”** table. This table contains unique zip codes for localities in Brazil along with other location columns. The primary key in this table is zipcodes.

The relationship between these tables was never 1:1, but always 1:n/n:1. Due to which I mostly used right or left joins during the process of creating the data warehouse.

Furthermore, before loading the data I went through some data cleaning work such as I removed the duplicate Zip Codes as they did not make much sense and were most likely a human error. I also excluded some fields from the tables such as comments as they were not going to be used in the analysis.


## EER Diagram

![EER_Diagram](https://github.com/Rauhannazir/DataEngineering1/blob/main/Term_Project_1/EER%20Diagram.png)



## Analytical layer

![warehousess](https://github.com/Rauhannazir/DataEngineering1/blob/main/Term_Project_1/Data%20Warehouse%20Snapshot.png)

I used Common table expressions(CTE) to create 2 temporary tables that allowed me to load and join the data more efficiently, without losing the connection to mysql server. I also dropped the records where order_status was null as they wouldn't make much sense for the analysis. The final data that I used to answer the analytical questions is stored in Ecommerce_DW.

## Data marts

To address the business questions, I made the following 5 data marts (All of these give the user the freedom to analyze a particular year of their choice, and this was achieved through the inclusion of stored procedures):

1. **sales_by_city:**  This answers the question about the TOP 5 cities where the orders were made from in terms of number of orders made in a particular year.

![view1](https://github.com/Rauhannazir/DataEngineering1/blob/main/Term_Project_1/View1_sales_by_city.png)

2. **payment_method:** This answers the question about the most frequent modes of payment by the customers for a particular year.

![view2](https://github.com/Rauhannazir/DataEngineering1/blob/main/Term_Project_1/View2_payment_method.png)

3. **sales_by_state:** This answers the question about the TOP 5 states where the orders were made from in terms of revenue generated for a particular year.

![view3](https://github.com/Rauhannazir/DataEngineering1/blob/main/Term_Project_1/View3_sales_by_state.png)

4. **reviews_by_category:** This anwers the question about which categories were given the highest average review scores in a particular year.

![view4](https://github.com/Rauhannazir/DataEngineering1/blob/main/Term_Project_1/View4_reviews_by_category.png)

5. **sellers_revenue:**  This anwers the question about which sellers made the most revenue in a particular year.

![view5](https://github.com/Rauhannazir/DataEngineering1/blob/main/Term_Project_1/View5_sellers_revenue.png)

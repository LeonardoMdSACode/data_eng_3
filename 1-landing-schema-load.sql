--Create Database & Schemas

create database ch19;
create or replace schema landing_zone;
create or replace schema curated_zone;
create or replace schema consumption_zone;

-- Create Order Table (Landing Zone)

create or replace transient table landing_item (
        item_id varchar,
        item_desc varchar,
        start_date varchar,
        end_date varchar,
        price varchar,
        item_class varchar,
        item_CATEGORY varchar
) comment ='this is item table with in landing schema';

create or replace transient table landing_customer (
    customer_id varchar,
    salutation varchar,
    first_name varchar,
    last_name varchar,
    birth_day varchar,
    birth_month varchar,
    birth_year varchar,
    birth_country varchar,
    email_address varchar
) comment ='this is customer table with in landing schema';

create or replace transient table landing_order (
    order_date varchar,
    order_time varchar,
    item_id varchar,
    item_desc varchar,
    customer_id varchar,
    salutation varchar,
    first_name varchar,
    last_name varchar,
    store_id varchar,
    store_name varchar,
    order_quantity varchar,
    sale_price varchar,
    disount_amt varchar,
    coupon_amt varchar,
    net_paid varchar,
    net_paid_tax varchar,
    net_profit varchar
) comment ='this is order table with in landing schema';
    

--Create a file format and have a history data loaded
create or replace file format my_csv_vi_webui
type = 'csv' 
compression = 'auto' 
field_delimiter = ',' 
record_delimiter = '\n' 
skip_header = 1
field_optionally_enclosed_by = '\042' 
null_if = ('\\N');


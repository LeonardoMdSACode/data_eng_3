    use schema ch19.consumption_zone;
    create or replace table item_dim (
        item_dim_key number autoincrement,
        item_id varchar(16),
        item_desc varchar,
        start_date date,
        end_date date,
        price number(7,2),
        item_class varchar(50),
        item_category varchar(50),
        added_timestamp timestamp default current_timestamp() ,
        updated_timestamp timestamp default current_timestamp() ,
        active_flag varchar(1) default 'Y'
    ) comment ='this is item table with in consumption schema';

    create or replace table customer_dim (
        customer_dim_key number autoincrement,
        customer_id varchar(18),
        salutation varchar(10),
        first_name varchar(20),
        last_name varchar(30),
        birth_day number,
        birth_month number,
        birth_year number,
        birth_country varchar(20),
        email_address varchar(50),
        added_timestamp timestamp default current_timestamp() ,
        updated_timestamp timestamp default current_timestamp() ,
        active_flag varchar(1) default 'Y'
    ) comment ='this is customer table with in consumption schema';
    
    create or replace table order_fact (
      order_fact_key number autoincrement,
      order_date date,
      customer_dim_key number,
      item_dim_key number,
      order_count number,
      order_quantity number,
      sale_price number(20,2),
      disount_amt number(20,2),
      coupon_amt number(20,2),
      net_paid number(20,2),
      net_paid_tax number(20,2),
      net_profit number(20,2)
    ) comment ='this is order table with in consumption schema';
    
   show tables;

--load curated data into consumption zone:
    insert into ch19.consumption_zone.item_dim (
        item_id,
        item_desc,
        start_date,
        end_date,
        price,
        item_class,
        item_category) 
    select 
        item_id,
        item_desc,
        start_date,
        end_date,
        price,
        item_class,
        item_category
    from ch19.curated_zone.curated_item;

    insert into ch19.consumption_zone.customer_dim (
        customer_id ,
        salutation ,
        first_name ,
        last_name ,
        birth_day ,
        birth_month ,
        birth_year ,
        birth_country ,
        email_address ) 
    select 
        customer_id ,
        salutation ,
        first_name ,
        last_name ,
        birth_day ,
        birth_month ,
        birth_year ,
        birth_country ,
        email_address 
    from ch19.curated_zone.curated_customer;

    insert into ch19.consumption_zone.order_fact (
      order_date,
      customer_dim_key ,
      item_dim_key ,
      order_count,
      order_quantity ,
      sale_price ,
      disount_amt ,
      coupon_amt ,
      net_paid ,
      net_paid_tax ,
      net_profit 
    ) 
    select 
      co.order_date,
      cd.customer_dim_key ,
      id.item_dim_key,
      count(1) as order_count,
      sum(co.order_quantity) ,
      sum(co.sale_price) ,
      sum(co.disount_amt) ,
      sum(co.coupon_amt) ,
      sum(co.net_paid) ,
      sum(co.net_paid_tax) ,
      sum(co.net_profit)  
    from ch19.curated_zone.curated_order co 
    join ch19.consumption_zone.customer_dim cd on cd.customer_id = co.customer_id
    join ch19.consumption_zone.item_dim id on id.item_id = co.item_id and id.item_desc = co.item_desc and id.end_date is null
    group by 
        co.order_date,
        cd.customer_dim_key ,
        id.item_dim_key
        order by co.order_date;

   show tables;
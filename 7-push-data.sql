select count(*) from ch19.landing_zone.landing_order; --10003 (10001) new records + one update
select count(*) from ch19.landing_zone.landing_item; --2793 (2791)new records + one update
select count(*) from ch19.landing_zone.landing_customer; -- 8889 (8887) new records + one update


select count(*) from ch19.landing_zone.landing_order_stm; 
select count(*) from ch19.landing_zone.landing_item_stm; 
select count(*) from ch19.landing_zone.landing_customer_stm; 


select count(*) from ch19.curated_zone.curated_order; --10001(10002) one updated and one inserted
select count(*) from ch19.curated_zone.curated_item; --2791 (2792) one updated and one inserted
select count(*) from ch19.curated_zone.curated_customer; -- 8887 (8888) one updated and one inserted

select count(*) from ch19.consumption_zone.order_fact; --5740 (5741)
select count(*) from ch19.consumption_zone.item_dim; --2791 (2791)
select count(*) from ch19.consumption_zone.customer_dim; -- 8887 (8888)

use schema ch19.consumption_zone;
select *  from table(information_schema.task_history()) 
            where name in ('ORDER_FACT_TSK')
            order by scheduled_time;

-- lets validate the change using time travel feature
select * from ch19.consumption_zone.customer_dim where customer_id = 'AAAAAAAAPOJJJDAA'
union all
select * from ch19.consumption_zone.customer_dim at(offset => -60*10) where customer_id = 'AAAAAAAAPOJJJDAA';


select * from ch19.consumption_zone.item_dim where item_id = 'AAAAAAAACDLBXPPP'
union all
select * from ch19.consumption_zone.item_dim at(offset => -60*10) where item_id = 'AAAAAAAACDLBXPPP';
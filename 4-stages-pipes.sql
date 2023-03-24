    -- order stage
    create stage delta_orders_s3
        url = 's3://toppertips/delta/orders' 
        comment = 'feed delta order files';
    -- item stage
    create stage delta_items_s3
        url = 's3://toppertips/delta/items' 
        comment = 'feed delta item files';

    -- customer stage
    create stage delta_customer_s3
        url = 's3://toppertips/delta/customers' 
        comment = 'feed delta customer files';
        
    show stages;

    create or replace pipe order_pipe
        auto_ingest = true
    as 
        copy into landing_order from @delta_orders_s3
        file_format = (type=csv COMPRESSION=none)
        pattern='.*order.*[.]csv'
        ON_ERROR = 'CONTINUE';

    create or replace pipe item_pipe
        auto_ingest = true
    as 
        copy into landing_item from @delta_items_s3
        file_format = (type=csv COMPRESSION=none)
        pattern='.*item.*[.]csv'
        ON_ERROR = 'CONTINUE';

    create or replace pipe customer_pipe
        auto_ingest = true
    as 
        copy into landing_customer from @delta_customer_s3
        file_format = (type=csv COMPRESSION=none)
        pattern='.*customer.*[.]csv'
        ON_ERROR = 'CONTINUE';

    show pipes;
    
    select system$pipe_status('order_pipe');
    select system$pipe_status('item_pipe');
    select system$pipe_status('customer_pipe');
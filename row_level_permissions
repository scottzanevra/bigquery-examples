
SELECT * FROM `dataplex-demo-342803.dbt_demo_staging.stg_client` LIMIT 1000;


CREATE ROW ACCESS POLICY customer_data_chicago
ON dbt_demo_staging.stg_client
GRANT TO ("user:sally-data-scientist@szanevra.altostrat.com")
FILTER USING (profile = "adults_2550_male_rural")



-- Update the access policy to apply to the user xyz@example.com instead:

CREATE OR REPLACE ROW ACCESS POLICY apac_filter
ON project.dataset.my_table
GRANT TO ('user:xyz@example.com')
FILTER USING (region = 'APAC');

-- Create a row access policy that grants access to a user and two groups:

CREATE ROW ACCESS POLICY sales_us_filter
ON project.dataset.my_table
GRANT TO ('user:john@example.com',
          'group:sales-us@example.com',
          'group:sales-managers@example.com')
FILTER USING (region = 'US');


-- Create a row access policy with allAuthenticatedUsers as the grantees:

CREATE ROW ACCESS POLICY us_filter
ON project.dataset.my_table
GRANT TO ('allAuthenticatedUsers')
FILTER USING (region = 'US');


-- Create a row access policy with a filter based on the current user:
CREATE ROW ACCESS POLICY my_row_filter
ON dataset.my_table
GRANT TO ('domain:example.com')
FILTER USING (email = SESSION_USER());



-- Create a row access policy with a filter on a column with an ARRAY type:

CREATE ROW ACCESS POLICY my_reports_filter
ON project.dataset.my_table
GRANT TO ('domain:example.com')
FILTER USING (SESSION_USER() IN UNNEST(reporting_chain));


DROP ALL ROW ACCESS POLICIES ON `dataplex-demo-342803.dbt_demo_staging.stg_client`;

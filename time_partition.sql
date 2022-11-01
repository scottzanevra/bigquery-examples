create or replace table `bdcs1-278103.dataset.partitioned_table`
partition by date
as

select *
from `bigquery-public-data.iowa_liquor_sales.sales`
where date > '2020-03-01'

--------------------------------------------------------------------------------------------------

select *
from bdcs1-278103.dataset.partitioned_table
where    date = '2020-06-10'

--------------------------------------------------------------------------------------------------
Auto-expiration - 60 days
--------------------------------------------------------------------------------------------------
create or replace table `bdcs1-278103.dataset.partitioned_table`
partition by date
options
(
partition_expiration_days=60,
   description="weather stations with precipitation, partitioned by day"
)
as

select *
from `bigquery-public-data.iowa_liquor_sales.sales`
where date > '2020-03-01'
-------------------------------------------------------------------------------
------------------------------UNION ALL----------------------------------------
-------------------------------------------------------------------------------
select zipcode, geo_id, minimum_age, maximum_age, gender, population  from
bigquery-public-data.census_bureau_usa.population_by_zip_2000

 union all

 select zipcode, geo_id, minimum_age, maximum_age, gender, population from
 bigquery-public-data.census_bureau_usa.population_by_zip_2010
 limit 10
 ;

-------------------------------------------------------------------------------
------------------------------UNION DISTINCT----------------------------------------
-------------------------------------------------------------------------------

select zipcode, geo_id, minimum_age, maximum_age, gender, population  from
bigquery-public-data.census_bureau_usa.population_by_zip_2000

 union distinct

 select zipcode, geo_id, minimum_age, maximum_age, gender, population from
 bigquery-public-data.census_bureau_usa.population_by_zip_2010
 limit 10
 ;

-------------------------------------------------------------------------------
------------------------------WildCard *----------------------------------------
-------------------------------------------------------------------------------

 Select  zipcode, geo_id, minimum_age, maximum_age, gender, population  from
`bigquery-public-data.census_bureau_usa.population_by_zip_*`
 limit 10
 ;

-------------------------------------------------------------------------------
------------------------------_Table_Suffix Keyword----------------------------------------
-------------------------------------------------------------------------------

select  zipcode, geo_id, minimum_age, maximum_age, gender, population from
`bigquery-public-data.census_bureau_usa.population_by_zip_*`
where _Table_Suffix > '2005'
 limit 10
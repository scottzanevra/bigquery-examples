##--------------------STRUCT- May contain different data types-------------------------------------

With Emp_STRUCT as
(
Select STRUCT(1 as EmpNo, 'Jack' as EmpName, 35 as Age, 'HR' as DeptNm) as Empl
 union all
Select STRUCT(2 as EmpNo, 'Jill' as EmpName, 37 as Age, 'HR' as DeptNm) as Empl
 union all
Select STRUCT(3 as EmpNo, 'David' as EmpName, 27 as Age, 'HR' as DeptNm) as Empl
 union all
Select STRUCT(4 as EmpNo, 'George' as EmpName, 26 as Age, 'IT' as DeptNm) as Empl
)

select *
from Emp_Struct
;


##---------------Array of Structures------------------------------------
Select 'HR' as DeptNm, 'Riya' as DeptHr,
  [
  STRUCT(1 as EmpNo, 'Jack' as EmpName, 35 as Age),
  STRUCT(2 as EmpNo, 'Jill' as EmpName, 37 as Age),
  STRUCT(3 as EmpNo, 'David' as EmpName, 27 as Age)
  ] as Empl

union all

select 'IT' as DeptNm, 'Devna' as DeptHr,
  [
  STRUCT(4 as EmpNo, 'George' as EmpName, 25 as Age),
  STRUCT(5 as EmpNo, 'Jack' as EmpName, 26 as Age)
  ] as Empl
;



##------------------------Daily top 2 counties using Rank--------------------------------------

With Rank_Date as (

select date,
       county,
       sum(bottles_sold) as sales,
       rank() over (partition by date order by sum(bottles_sold) desc) as calc_rank

from `bigquery-public-data.iowa_liquor_sales.sales`
where county is not null
group by date, county
order by 1
)

Select *
from Rank_date
where calc_rank <=2
date > '2020-05-01'
;


##--------------------Daily top 2 counties-Using ARR & STRUCT -----------------------------------------

With Sale_arr as (
select
array_agg(Struct(county, bottles_sold)) as Sales,
date
from `bigquery-public-data.iowa_liquor_sales.sales`
where date > '2020-05-01'
group by date

)

select
date,
Array(select as struct county, sum(bottles_sold) from unnest(Sales) as Sales
group by County order by sum(bottles_sold) desc
limit 2
)
from sale_arr
;
##------------------------array--------------------------------------
Select array['Jack', 'Jill', 'David', 'George']
as EmpNm
;

##------------------------array_length--------------------------------------
With Emp_arr as
(
Select array['Jack', 'Jill', 'David', 'George']
as EmpNm)

select array_length(EmpNm) as length
from Emp_arr
;


##-------------------array_agg-------------------------------------------

With Emp as
(
Select 1 as EmpNo, 'Jack' as EmpName, 35 as Age, 'HR' as DeptNm
 union all
Select 2 as EmpNo, 'Jill' as EmpName, 37 as Age, 'HR' as DeptNm
 union all
Select 3 as EmpNo, 'David' as EmpName, 27 as Age, 'HR' as DeptNm
 union all
Select 4 as EmpNo, 'George' as EmpName, 26 as Age, 'IT' as DeptNm )

select DeptNm, array_agg(EmpName) as Nm
from Emp
group by DeptNm
;



##---------------------ARRAY UNION ALL-----------------------------------------

Select array['Jack', 'Jill', 'David']  as EmpNm, 'HR' as DeptNm
union all
Select array['George']  as EmpNm, 'IT' as DeptNm
;


##-------------------Apply Filter in an ARRAY - Same data type-------------------------------------------
With Emp_arr as
(
Select array['Jack', 'Jill', 'David']  as EmpNm, 'HR' as DeptNm
union all
Select array['George','Jack']  as EmpNm, 'IT' as DeptNm

)

select
DeptNm,
ARRAY(
select EmpName from unnest(EmpNm) as EmpName
where 'David' in unnest(EmpNm) #'Jack' or 'Jill
) as EmpNm_display
from Emp_arr
;
---Records in Table1 not available in Table2--------------------------------
select * from dataset_sp.table1
except distinct
select * from dataset_sp.table2
;

---Records in Table2 not available in Table1--------------------------------
select * from dataset_sp.table2
except distinct
select * from dataset_sp.table1
;

---Common Records in Table1 & Table2--------------------------------
select * from dataset_sp.table2
intersect distinct
select * from dataset_sp.table1;

------------------Create Table3----------------------
Create table dataset_sp.table3
as select * from dataset_sp.table1
where 1=2;


----------------------Create Stored Procedure--------------------------------------
Create or replace procedure bdcsproject.dataset_sp.my_sp()
BEGIN

delete from dataset_sp.table3 where 1=1;

insert into dataset_sp.table3
  select * from dataset_sp.table1
  union distinct
  select * from dataset_sp.table2
  ;

END;

----------------------Call Stored Procedure--------------------------------------
call bdcsproject.dataset_sp.my_sp();
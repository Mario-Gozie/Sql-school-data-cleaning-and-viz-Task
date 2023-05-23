select * from Admission_list

-- the Table has a lot of Null columns which needs to be dropped.
-- column F1, F2, F8, F9, F10, F11, F12, F13, F14, F15, F16, F17, F18, F19, are all Null

Alter Table Admission_list
Drop column F1,F2, F8, F9, F10, F11, F12, F13, F14, F15, F16, F17, F18, F19;

select * from Admission_list;

-- The table is a bit neat now

-- looking at the table, I need to delete the first 3 rows. so it can be neater.
-- this will affect the column name but 1 can rename the column name afterwards
-- however, this will not work because the first column name is 'One Skill to Rule Them All'
-- and sql dosen't accept names with spaces between so we need to rename the column bevor deleting
-- to make it easier for me to delete , I willn name it Name as the las column so I cna easily delete the three all together.
Exec sp_rename 'Admission_list.One Skill to Rule Them All','Name', 'column';
Exec sp_rename 'Admission_list.F4','Email', 'column';
Exec sp_rename 'Admission_list.F5','Course', 'column';
Exec sp_rename 'Admission_list.F6','Registeration_Date', 'column';
Exec sp_rename 'Admission_list.F7','Amount_paid', 'column';

select * from Admission_list;

-- let me delete the first three rows to make the table neater.
delete from Admission_list
where Name = 'Name' or Name is Null;

-- Now it is neater.
select * from Admission_list

-- let me handle the null values 
-- looking at the columns, one can show interest in a school without paying school fees.
-- hence, its nececessary to delete names and rows that paid nothing or has null for Amount_paid columnn.
-- let me see those columns first.
select * from Admission_list
where Amount_paid is null;

-- in no doubt, it is a long list of 36 rows. however, I need to get rid of them.

delete from Admission_list
where Amount_paid is null;
 
 
 -- let me view the new Table
 select * from Admission_list;

 -- Dupplicate values
 select Name, Email, Course, Registeration_Date, Amount_paid, count(*) as agg_Number
 from Admission_list
group by Name, Email, Course, Registeration_Date, Amount_paid
having count(*) >1;
 -- if I delete this I will loose the entire data. 

-- let me delete duplicate using a CTE
go

with Row_num_val as (select Name, Email, Course, Registeration_Date, Amount_paid,
ROW_NUMBER() over(partition by Name, Email, Course, Registeration_Date, Amount_paid 
order by Name, Amount_paid) as row_num
from Admission_list),

complete_row_duplicate as (select Name, Email, Amount_paid, Registeration_Date, row_num,
 count(*) over(partition by Name, Email, Amount_paid, Registeration_Date
  order by Name,  Amount_paid)
  as counts from Row_num_val)

  
  delete from complete_row_duplicate
  where row_num > 1;

  -- the Four completely similar rows has been deleted.
  go

  select Name, Amount_paid, count(*) as counts from Admission_list
  group by Name, Amount_paid
  having count(*) > 1;

  -- we can now see that the entire row duplicate has been deleted

  -- now, the Total school fees for this school is 500. some people paid below 500 
  -- before they completed their money. we could see such values as duplicate. lets me explore.
  select Name, Email, Course, Registeration_Date, Amount_paid,
  count(*) as counts  from Admission_list
  group by Name, Email, Course, Registeration_Date, Amount_paid
  order by Name, Email;

  -- looking at this list we can see that some intending students like Ramon Nurton 
  -- Carina Stubbs, Caydence Fisher paid partly the first time and fully the second time.
  -- since the school fees is 500 in Total and his name showed for 250 and 500.
  -- it means the accountant must have summed thee data without deleting the initial part payment.
  -- let me try dealing with that logically.

  --because I orderd in desc of Amount_paid so, the lower amount should be down and No 2
  -- from my this querr]y the students with this issue are 8 in number 
  go
 with Part_and_full_pay as(select Name, Email, Course,Registeration_Date,
  Amount_paid, ROW_NUMBER() over(partition by Email, Course
   order by Name, Email,Amount_paid desc) as row_num
   from Admission_list)

  delete from Part_and_full_pay
  where row_num = 2;
   
 -- Exactly 8 rows affected

 go 

select * from Admission_list
-- there Empty columns for course. but these individuals paid a certain amount. 
-- hence, I need to fill in some the. maybe unspecified

-- Let me see the applicats with no course name 
 
 select * from Admission_list
 where TRIM(Course) = '';
 --19 0f them 
-- Now lets update the empty course columns with unspecified
Update Admission_list
set Course = 'Unspecified'
where Trim(course) = '';
-- 19 course rows have been updated.

select * from Admission_list

-- looking at the Date column, it is a crucial column so we need to update it
-- lets check if people paid on 25th december. it is a public holiday so no one is ecpected to pay on such day.
-- we can fill such day for people that paid without a date.

-- wait, before  do so, let me confirm the datatype of the registeration date column

 select * from INFORMATION_SCHEMA.COLUMNS
 where TABLE_NAME = 'Admission_list';

 -- it is in nvarchar instead of date  I need to convert this.
 update Admission_list
 set Registeration_Date = PARSE(Registeration_Date as date)

 -- The Above code converted the data to the format I wanted bud didn't change the datatype.
 -- let me change it.
 Alter Table Admission_list
 alter column Registeration_Date date;

 
 select * from INFORMATION_SCHEMA.COLUMNS
 where TABLE_NAME = 'Admission_list';

 -- the Registeration_Date is now in the Format I want.



 -- let me now fill null registeration Dates with Christmas Date
 Update Admission_list
 set Registeration_Date = '2022-12-25'
 where Registeration_Date is null;

 
 select * from Admission_list;

 -- Now the Data is clean

 -- let me create a column for people that has fully paid and people that havent so I can visualize.
 Alter Table Admission_list
 Add Payment_Status varchar(20) NOT NULL Default 'payment';

 select * from Admission_list

 Update Admission_list
 set Payment_Status = case when Amount_paid = 500 then 'Full Payment'
 else 'Part Payment'
 end;
 
 -- the Table is full neat for Analysis.

 select * from Admission_list



 



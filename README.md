## INTRODUCTION
![Alt Text]()

The task in this github repository is an SQL data cleaning task of less than 150 dataset.
The data was later visualized using Tableau.

_NB: This is just a dummy data used from the internet which I used to show SQL data cleaning skill and visualization with tableau._


## TOOLS USED
* SQL
* Tableau

## SKILLS APPLIED
* Data cleaning, Data Manipulation, and use of data definition language (DDL) with SQL
* Visualization with Tableau.

## POSSIBLE STAKEHOLDERS
* Institution Owners
* Accounting department
* Vice Chancellors, Rectors etc.

## The Task

### Previewing the Dataset

`select * from Admission_list`

![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(301).png)

![ALt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(302).png)

Here, it is obvious that the column names are not right and they can be found in the third row. There are two null columns before the main column and a lot of them at the end.

### Dropping all only null columns
`Alter Table Admission_list
Drop column F1,F2, F8, F9, F10, F11, F12, F13, F14, F15, F16, F17, F18, F19;`

`select * from Admission_list;`

![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(303).png)

![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(304).png)

The first (left) image shows that the null columns have been successfully deleted. While the second (right) shows the table in a neater form

### Renaming Colums rightly

`Exec sp_rename 'Admission_list.One Skill to Rule Them All','Name', 'column';`
`Exec sp_rename 'Admission_list.F4','Email', 'column';`
`Exec sp_rename 'Admission_list.F5','Course', 'column';`
`Exec sp_rename 'Admission_list.F6','Registeration_Date', 'column';`
`Exec sp_rename 'Admission_list.F7','Amount_paid', 'column';`

`select * from Admission_list;`

![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(305).png)


![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(306).png)

The first image from the left shows that Columns were renamed successfully while the next one shows the new names have been attached.

### Deleting the First 3 Rows

`delete from Admission_list
where Name = 'Name' or Name is Null;`


`select * from Admission_list`




![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(308).png)




### Viewing for Students that didn't Pay School Fees

`select * from Admission_list
where Amount_paid is null;`

![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(316).png)

### Removing Prospective Students that didn't pay fees

`delete from Admission_list
where Amount_paid is null;`

`select * from Admission_list;`

![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(317).png)

![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(318).png)


I removed these individuals because one who didn't pay Admission fee shouldn't on Admission list.
I now have a table without NULL Amount.


###  Deleting duplicate of all columns

`with Row_num_val as (select Name, Email, Course, Registeration_Date, Amount_paid,
ROW_NUMBER() over(partition by Name, Email, Course, Registeration_Date, Amount_paid 
order by Name, Amount_paid) as row_num
from Admission_list),

complete_row_duplicate as (select Name, Email, Amount_paid, Registeration_Date, row_num,
 count(*) over(partition by Name, Email, Amount_paid, Registeration_Date
  order by Name,  Amount_paid)
  as counts from Row_num_val)

  
  delete from complete_row_duplicate
  where row_num > 1;`
  
![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(320).png)

### Viewing to check if the deleted rows are gone

 `select Name, Email, Course, Registeration_Date, Amount_paid, count(*) as agg_Number
 from Admission_list
group by Name, Email, Course, Registeration_Date, Amount_paid
having count(*) >1;`


![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(321).png)

### The Total School Fees for the Session is 500 Dollars. Some people made part payment earlier and later completed. which made their names appear twice. its time to fish them out and remove them.

  #### checking how many these individuals are

  `go
 with Part_and_full_pay as(select Name, Email, Course,Registeration_Date,
  Amount_paid, ROW_NUMBER() over(partition by Email, Course
   order by Name, Email,Amount_paid desc) as row_num
   from Admission_list)

  delete from Part_and_full_pay
  where row_num = 2;`
  
  ![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(323).png)
  
  #### Removing their part payment details
  
   go
 with Part_and_full_pay as(select Name, Email, Course,Registeration_Date,
  Amount_paid, ROW_NUMBER() over(partition by Email, Course
   order by Name, Email,Amount_paid desc) as row_num
   from Admission_list)

  delete from Part_and_full_pay
  where row_num = 2;
  
  ![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(325).png)
  
  #### Confirming Removal of the duplicated names
  
  `select * from Admission_list`
  ![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(326).png)
  
  ### There are some rows in where the coursce column has space and not null
  
  #### viewing the table to see any of such rows
  
  `select * from Admission_list`
  
  ![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(327).png)
  
  #### Replacing them with the word "Unspecified"
  ` select * from Admission_list
 where TRIM(Course) = '';`
 
 `Update Admission_list
set Course = 'Unspecified'
where Trim(course) = '';`

![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(328).png)

#### Viewing the table to see if "Unspecified" has replaced the spaces

`select * from Admission_list`

![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(329).png)

### The Date column is in string format, I had to convert it to the conventional date format

 `select * from INFORMATION_SCHEMA.COLUMNS
 where TABLE_NAME = 'Admission_list';`

 `update Admission_list
 set Registeration_Date = PARSE(Registeration_Date as date)`

![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(331).png)

![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(332).png)

### After convertion, it remianed in Nvarchar format. I had to convert to date to Make Analysis Easy.

` Alter Table Admission_list
 alter column Registeration_Date date;`
 
![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(335).png)

![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(336).png)

### I had to Update the Null date value to a unique day so I used 25th December, since no one paid on that day, it will be easy to identify people with such registeration day as people that do not have registeration day initially. This will make anlysis easy and the data look better.

`Update Admission_list
 set Registeration_Date = '2022-12-25'
 where Registeration_Date is null;`

 
 `select * from Admission_list;`
 
 ![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(333).png)
 
 ![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(334).png)
 
 ### Creating and updating Payment Status column 
 
  `Alter Table Admission_list
 Add Payment_Status varchar(20) NOT NULL Default 'payment';`
 
 `Update Admission_list
 set Payment_Status = case when Amount_paid = 500 then 'Full Payment'
 else 'Part Payment'
 end;`
 
 ![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(337).png)
 
 ![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(339).png)
 
 ### Now we have a clean dataset
 
 `select * from Admission_list`
 
 ![Alt Text](https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(338).png)
 
 
 

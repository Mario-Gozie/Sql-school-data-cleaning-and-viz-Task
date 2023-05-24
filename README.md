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

![Alt Text]('Images/Screenshot (301).png')

![ALt Text]('Images/Screenshot (302).png')

Here, it is obvious that the column names are not right and they can be found in the third row. There are two null columns before the main column and a lot of them at the end.

### Dropping all null columns
`Alter Table Admission_list
Drop column F1,F2, F8, F9, F10, F11, F12, F13, F14, F15, F16, F17, F18, F19;`

`select * from Admission_list;`

![Alt Text]('Images/Screenshot (303).png')

![Alt Text]('Images/Screenshot (304).png')

The first (left) image shows that the null columns have been successfully deleted. While the second (right) shows the table in a neater form

### Renaming Colums rightly

`Exec sp_rename 'Admission_list.One Skill to Rule Them All','Name', 'column';`
`Exec sp_rename 'Admission_list.F4','Email', 'column';`
`Exec sp_rename 'Admission_list.F5','Course', 'column';`
`Exec sp_rename 'Admission_list.F6','Registeration_Date', 'column';`
`Exec sp_rename 'Admission_list.F7','Amount_paid', 'column';`

`select * from Admission_list;`

![Alt Text]('Images/Screenshot (305).png')


![Alt Text]('https://github.com/Mario-Gozie/Sql-school-data-cleaning-and-viz-Task/blob/main/Images/Screenshot%20(306).png')

The first image from the left shows that Columns were renamed successfully while the next one shows the new names have been attached.

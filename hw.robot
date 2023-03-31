*** Settings ***
Suite Setup       Connect To Database  pymssql  ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
Suite Teardown    Disconnect From Database
Library           DatabaseLibrary
Library           OperatingSystem
Library           String
Library           Collections
Library           pymssql

*** Variables ***
${DBName}         AdventureWorks2016
${DBUser}         nastia
${DBPass}         AMSTERdam19
${DBHost}         localhost
${DBPort}         1433


*** Test Cases ***
Table Department. Verify if the table exist
    [Tags]    test_1
    [documentation]
    ...  Connect to DB
    ...  Check if the table Department exists in Database
    ...
    ...  Expected results:
    ...  Table exists in DB
    Table Must Exist    Department


Table Department. Check if table is not empty
    [Tags]  test_2
    [documentation]
    ...  Connect to DB
    ...  Execute the sql query
    ...
    ...  Expected result:
    ...  Table is not empty. The count of rows will be greater than 0
    Row Count Is Greater than X  select count(*) as count from HumanResources.Department;    0


Table Location. Check column description of the table and column count
    [Tags]  test_3
    [documentation]
    ...  Connect to DB
    ...  Query db for reciving table column descriptions
    ...
    ...  Expected result:
    ...  Columns discriptions of Location table and column count
    @{QueryResult}=  Description  select top 1 * from Production.Location;
    Log Many    @{QueryResult}
    ${NumColumns} =    Get Length    ${QueryResult}
    Should Be Equal As Integers    ${NumColumns}    5

Table Location. Check duplicates
    [Tags]  test_4
    [documentation]
    ...  Connect to DB
    ...  Check duplicates in PK column by execution of the sql query
    ...
    ...  Expected results:
    ...  no duplicates in PK
    Row Count Is 0    select count(LocationID) from Production.Location group by LocationID having count(*)>1;


 Table EmployeeDepartmentHistory. Check that StartDate < EndDate
    [Tags]  test_5
    [documentation]
    ...  Connect to DB
    ...  Check if start_date less than end_date by execution of the sql query
    ...
    ...  Expected results:
    ...  StartDate < EndDate. 0 rows in output
    Row Count Is 0    select * from HumanResources.EmployeeDepartmentHistory where StartDate>EndDate;


 Table EmployeeDepartmentHistory. Check validity of StartDate
    [Tags]  test_6
    [documentation]
    ...  Connect to DB
    ...  Check if StartDate is less or equal current_date by execution of the sql quiery
    ...
    ...  Expected results:
    ...  StartDate <= current date. 0 rows in output
    Row Count Is 0    select * from HumanResources.EmployeeDepartmentHistory where StartDate > getdate();


 Table EmployeePayHistory. Check the average, maximum, minumum salary for employees
    [Tags]  test_7
    [documentation]
    ...  Connect to DB
    ...  Check min, max, avg salary values by execution of the sql query
    ...
    ...  Expected result:
    ...  Average = 17.7588, maximum = 125.50, minumum = 6.50 values of salary for all employees
    @{AverageResult}  Query   select avg(Rate) from HumanResources.EmployeePayHistory;
    Log To Console    @{AverageResult}
    @{MinResult}  Query   select min(Rate) from HumanResources.EmployeePayHistory;
    Log To Console    @{MinResult}
    @{MaxResult}  Query   select max(Rate) from HumanResources.EmployeePayHistory;
    Log To Console    @{MaxResult}


Table Department. Check all department names are presented in table
    [Tags]  test_8
    [documentation]
    ...  Connect to DB
    ...  Check that table has all required departments by execution of the sql query
    ...
    ...  Expected result:
    ...  All 16 department names are presented in table:
    ...  'Document Control','Engineering','Executive','Facilities and Maintenance','Finance','Human Resources','Information Services','Marketing','Production','Production Control','Purchasing','Quality Assurance','Research and Development','Sales','Shipping and Receiving','Tool Design')
    Check if exists in Database  select Name from HumanResources.Department where Name in('Document Control','Engineering','Executive','Facilities and Maintenance','Finance','Human Resources','Information Services','Marketing','Production','Production Control','Purchasing','Quality Assurance','Research and Development','Sales','Shipping and Receiving','Tool Design');
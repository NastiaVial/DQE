**Project name:** DQE

**Project location:** git@github.com:NastiaVial/DQE.git

**Necessary to install:**

* Python 3.11
* pip 23.0.1

**Libraries:**
* pymssql
* pytest
* pytest-html

**Connection to SQL Server Management Studio:**

Database: AdventureWorks2016

Create user with password in SQL Server Management Studio using SQL Server Authentication method.
Check all necessary roles are given to user.
Be sure that TCP/IP is Enabled
![img.png](img.png)

**How to execute test and generate a report**

* open correct location of you project in cmd using $cd 
* for executing tests run:
      $ pytest PyTest_Vial.py
* in order to have all results in html report run:
      $ pytest PyTest_Vial.py  --html=report.html


**PyTests coverage:**

Tests are written on 4 tables:
* Department table:

        test01. Table existence check.
        test02. Metadata check.

* Employee table

        test03. Check if table is not empty.
        test04. Uniqueness check.

* EmployeeDepartmentHistory table

        test05. Check if StartDate is less than EndDate.
        test06. Check if StartDate is less (or equal) than current day. 
        test07. Check the quantity of employees in Finance department.

* EmployeePayHistory table

        test08. Check Max rate.







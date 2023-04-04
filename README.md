**Project name:** DQE

**Project location:** git@github.com:NastiaVial/DQE.git

**Necessary to install:**

* Python 3.11
* pip 23.0.1 
* robotframework

**Libraries:**
* pymssql
* DatabaseLibrary
* OperatingSystem

**Connection to SQL Server Management Studio:**

Database: AdventureWorks2016

Create user with password in SQL Server Management Studio using SQL Server Authentication method.
Check all necessary roles are given to user.
Be sure that TCP/IP is Enabled
![img_1.png](img_1.png)

**Report**

run _hw.robot_ file in Terminal and check the results in _report.html_ and _log.html_ files


**Tests coverage:**

Tests are written on 4 tables:
* Department table:

        test_1. Table existence check.
        test_2. Check if table is not empty.
        test_8. Check all department names are presented in table

* Location table

        test_3. Check column description of the table and column count.
        test_4. Uniqueness check.

* EmployeeDepartmentHistory table

        test_5. Check if StartDate is less than EndDate.
        test_6. Check if StartDate is less (or equal) than current day.

* EmployeePayHistory table

        test_7. Check the average, maximum, minumum salary for employees.





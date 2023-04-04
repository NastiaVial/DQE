import pymssql
import pytest
from py.xml import html

try:
    conn = pymssql.connect(server='EPPLGDAW00A5', user='nastia', password='AMSTERdam19', database='AdventureWorks2016')
    print("Connection to AdventureWorks2016 is established")

except Exception as ex:
    print(ex)


def test01_table_department_existence():
    """
    test_1: [Department] completeness
    Find out if table Department exists in AdventureWorks2016 database
    result: pass
    """
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM information_schema.tables WHERE table_name='Department'")
    rows = cursor.fetchall()
    assert len(rows) == 1
    print(f'Table Department exists in AdventureWorks2016 database')


def test02_table_department_metadata():
    """
    test_2: [Department] metadata
    Find out if columns and data types are according to business requirements
    result: pass
    """
    cursor = conn.cursor()
    cursor.execute("SELECT [c].[COLUMN_NAME], CONCAT ([DATA_TYPE], [CHARACTER_MAXIMUM_LENGTH])AS DATA_TYPE "
                   "FROM [INFORMATION_SCHEMA].[COLUMNS] [c] "
                   "INNER JOIN [INFORMATION_SCHEMA].[TABLES] [t] "
                   "ON [c].[TABLE_CATALOG] = [t].[TABLE_CATALOG]"
                   " AND [c].[TABLE_SCHEMA] = [t].[TABLE_SCHEMA] "
                   "AND [c].[TABLE_NAME] = [t].[TABLE_NAME] "
                   "WHERE [t].[TABLE_SCHEMA] = 'HumanResources' and [t].[TABLE_NAME] = 'Department'")
    rows = cursor.fetchall()
    department_metadata = [('DepartmentID', 'smallint'), ('Name', 'nvarchar50'), ('GroupName', 'nvarchar50'), ('ModifiedDate', 'datetime')]
    assert rows == department_metadata
    print(f'Column names and data types are according to the mapping document')


def test03_table_employee_not_empty():
    """
    test_3: [Employee] completeness
    Find out if table Employee is not empty
    result: pass
    """
    cursor = conn.cursor()
    cursor.execute("SELECT TOP 1 BusinessEntityID FROM HumanResources.Employee")
    rows = cursor.fetchall()
    assert len(list(rows)) > 0
    print(f'Table Employee is not empty')


def test04_table_employee_uniqueness():
    """
    test_4: [Employee] uniqueness of Primary Key
    Find out if column BusinessEntityID has no duplicates
    result: pass
    """
    cursor = conn.cursor()
    cursor.execute("SELECT COUNT(BusinessEntityID) FROM HumanResources.Employee"
                   " GROUP BY BusinessEntityID HAVING COUNT(*) > 1")
    rows = cursor.fetchall()
    assert len(list(rows)) == 0
    print(f'No duplicates in table Employee')


def test05_start_date_with_end_date():
    """
    test_05: [EmployeeDepartmentHistory] validity
    Check that StartDate < EndDate
    result: pass
    """
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM HumanResources.EmployeeDepartmentHistory"
                   " WHERE StartDate>EndDate")
    rows = cursor.fetchall()
    assert rows == []
    print(f'Start_date is earlier than end_date in EmployeeDepartmentHistory table')


def test06_validity_of_start_date():
    """
    test_06: [EmployeeDepartmentHistory] StartDate validity
    StartDate <= current date.
    result: pass
    """
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM HumanResources.EmployeeDepartmentHistory"
                   " WHERE StartDate > getdate()")
    rows = cursor.fetchall()
    assert rows == []
    print(f'Start_date is equal or earlier than current date in EmployeeDepartmentHistory table')


def test07_finance_department():
    """
    test_07: [EmployeeDepartmentHistory] completeness
    Check the quantity of employees in Finance department.
    result: pass
    """
    cursor = conn.cursor()
    cursor.execute("SELECT count(*) as qty from HumanResources.EmployeeDepartmentHistory e"
                   " INNER JOIN HumanResources.Department d ON e.DepartmentID = d.DepartmentID"
                   " WHERE Name = 'Finance'")
    rows = cursor.fetchall()[0][0]
    print(rows)
    assert int(rows) == 11
    print(f'Department Finance has 11 employees in EmployeeDepartmentHistory table')


def test08_max_employee_rate():
    """
    test_08: [EmployeePayHistory] validity of maximum employee rate
    Max rate should be less than 150.
    result: pass
    """
    cursor = conn.cursor()
    cursor.execute("SELECT MAX(Rate) as max_rate FROM HumanResources.EmployeePayHistory")
    rows = cursor.fetchall()[0][0]
    print(rows)
    assert rows <= 150
    print(f'Max rate is less than 150 in EmployeePayHistory table')

import 'dart:developer';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';
import 'package:untitled/model/employee.dart';
import 'package:untitled/model/department.dart';
import 'dart:io' as io;

class DataBaseConfigs {
  static Database? _databaseRef;

  Future<Database?> get databaseRef async {
    if (_databaseRef != null) return _databaseRef;
    _databaseRef = await initDB();
    return _databaseRef;
  }

  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "empolyeeTask.db");
    var theDb = await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        // create department table
        await db.execute('''
          CREATE TABLE Department (
            dep_id INTEGER PRIMARY KEY AUTOINCREMENT,
            dep_name TEXT VARCHAR (50) NOT NULL         
          )
          ''');
        // create employees table
        await db.execute('''
          CREATE TABLE Employee (
            emp_id INTEGER PRIMARY KEY AUTOINCREMENT,
            emp_name TEXT VARCHAR (50) NOT NULL,
            emp_hiredate INTEGER DEFAULT (cast(strftime('%s','now') as int)) NOT NULL,
            emp_email TEXT VARCHAR (50) NOT NULL,
            fk_employee INTEGER,
            dep_name TEXT VARCHAR (50),
            foreign key (fk_employee) REFERENCES Department(dep_id)
          )
          ''');

        // insert random departments
        await db.transaction((txn) async {
          await txn.rawInsert('INSERT INTO Department(dep_name) VALUES(\'Technical\')');
          await txn.rawInsert('INSERT INTO Department(dep_name) VALUES(\'HR\')');
          await txn.rawInsert('INSERT INTO Department(dep_name) VALUES(\'Management\')');
        });
        // insert random employees
        await db.transaction((txn) async {
          await txn.rawInsert('INSERT INTO Employee(emp_name, emp_hiredate,emp_email, fk_employee) VALUES('
              '\'Mohamed\','
              '\'978296400000\','
              '\'mohamed@gmail.com\','
              '\'1\''
              ')');
        });
        await db.transaction((txn) async {
          await txn.rawInsert('INSERT INTO Employee(emp_name, emp_hiredate,emp_email, fk_employee) VALUES('
              '\'Morad\','
              '\'978296400000\','
              '\'mourad@gmail.com\','
              '\'2\''
              ')');
        });
      },
      onConfigure: (Database db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },
    );
    return theDb;
  }

  void insertEmployee(Employee employee) async {
    var dbClient = await databaseRef;
    await dbClient!.transaction((txn) async {
      await txn.rawInsert('INSERT INTO Employee(emp_name, emp_hiredate,emp_email, fk_employee) VALUES('
          '\'${employee.emp_name}\','
          '\'${employee.emp_hiredate}\','
          '\'${employee.emp_email}\','
          '\'${employee.fk_employee}\''
          ')');
    });
  }

  Future<List<Department>> getAllDepartments() async {
    var dbClient = await databaseRef;
    final List<Map> selectedList = await dbClient!.rawQuery('SELECT * FROM Department');
    final List<Department> departments = [];
    for (int i = 0; i < selectedList.length; i++) {
      departments.add(Department(selectedList[i]['dep_name'], dep_id: selectedList[i]['dep_id']));
    }
    log('departments ${departments.length}');
    return departments;
  }

  Future<List<Employee>> getEmployeesWithDepartment() async {
    var dbClient = await databaseRef;
    final List<Map> selectedList = await dbClient!.rawQuery('SELECT * FROM Employee');
    final List<Employee> employees = [];
    for (int i = 0; i < selectedList.length; i++) {
      // get department name values and add it to the employee object
      // todo: enhance this
      final List<Map> selectedDepartmentList =
          await dbClient.rawQuery('SELECT * FROM Department WHERE dep_id = ${selectedList[i]['fk_employee']} ');
      employees.add(Employee(
        selectedList[i]['emp_name'],
        selectedList[i]['emp_hiredate'],
        selectedList[i]['emp_email'],
        selectedList[i]['fk_employee'],
        dep_name: selectedDepartmentList[0]['dep_name'],
      ));
    }
    log("employees length ${employees.length}");
    return employees;
  }
}

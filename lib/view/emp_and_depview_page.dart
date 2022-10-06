import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/database_configs.dart';
import 'package:untitled/model/department.dart';
import 'package:untitled/model/employee.dart';
import 'package:untitled/view/new_employee_page.dart';
import 'package:untitled/view/online_emp_page.dart';

class EmployeesViewPage extends StatefulWidget {
  const EmployeesViewPage({Key? key}) : super(key: key);

  @override
  State<EmployeesViewPage> createState() => _EmployeesViewPageState();
}

class _EmployeesViewPageState extends State<EmployeesViewPage> {
  Future<List<Employee>> getFutureData() async {
    var databaseConfigs = DataBaseConfigs();
    Future<List<Employee>> employees = databaseConfigs.getEmployeesWithDepartment();
    return employees;
  }

  Future<List<Department>> getAllDepartments() async {
    var databaseConfigs = DataBaseConfigs();
    Future<List<Department>> departmentList = databaseConfigs.getAllDepartments();
    return departmentList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employees Page'), centerTitle: true),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Employee>>(
                future: getFutureData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ExpansionTile(
                            title: Text("${snapshot.data![index].emp_name}",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            subtitle: Text("${snapshot.data![index].emp_email}", style: const TextStyle(fontSize: 14)),
                            initiallyExpanded: true,
                            trailing: const SizedBox(),
                            children: <Widget>[
                              ListTile(
                                title: Row(
                                  children: [
                                    const Text('Department'),
                                    const Spacer(),
                                    Text("${snapshot.data![index].dep_name}", style: const TextStyle(fontSize: 14))
                                  ],
                                ),
                                subtitle: Row(
                                  children: [
                                    const Text('Hiring Date'),
                                    const Spacer(),
                                    Text(DateFormat('MM-dd-yyyy hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(snapshot.data![index].emp_hiredate!)), style: const TextStyle(fontSize: 14))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Container(
                    alignment: AlignmentDirectional.center,
                    child: const CupertinoActivityIndicator(),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onSurface: Colors.white,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      ),
                      onPressed: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const OnlineEmployeePage()),
                        );
                      },
                      child: const Text("Fetch online Employees")),
                ),
                const SizedBox(width: 8),
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepOrangeAccent,
                          onSurface: Colors.white,
                          elevation: 0,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        ),
                        onPressed: () async {
                          await getAllDepartments().then((value) => Navigator.of(context)
                              .push(
                                MaterialPageRoute(builder: (_) => NewEmployeePage(departmentsList: value)),
                              )
                              .then((value) => value ? setState(() {}) : null));
                          // to refresh the employees page
                          // TODO: enhance this by using state management
                        },
                        child: const Text("Add new Employee")))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

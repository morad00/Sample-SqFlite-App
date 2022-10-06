import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:untitled/database_configs.dart';
import 'package:untitled/model/department.dart';
import 'package:untitled/model/employee.dart';

class NewEmployeePage extends StatefulWidget {
  const NewEmployeePage({required this.departmentsList, Key? key}) : super(key: key);
  final List<Department> departmentsList;

  @override
  State<NewEmployeePage> createState() => _NewEmployeePageState();
}

class _NewEmployeePageState extends State<NewEmployeePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final Employee employee = Employee('', 0, '', 1);

  String firstname = '';
  int hireData = 0;
  DateTime? selectedDate;
  String email = '';
  int departmentID = 0;
  late Department _selectedDepartment;

  @override
  void initState() {
    super.initState();
    _selectedDepartment = widget.departmentsList[0];
  }

  void _submitEmployee() {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add employee hiring date')));
    } else {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
      } else {
        return;
      }
      var employee = Employee(firstname, selectedDate!.millisecondsSinceEpoch, email, _selectedDepartment.dep_id);
      var dataBaseConfigs = DataBaseConfigs();
      dataBaseConfigs.insertEmployee(employee);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Employee added successfully')));
    }
  }

  void _showDatePicker() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.25,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.dateAndTime,
              onDateTimeChanged: (value) {
                if (value != selectedDate) {
                  setState(() {
                    selectedDate = value;
                    log('selectedDate $selectedDate');
                  });
                }
              },
              minimumYear: 2022,
              minimumDate: DateTime.now(),
              // maximumYear: 2021,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Add new employee'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Card(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.black87),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10)),
                  validator: (val) => val!.isEmpty ? "Add Employee Name" : null,
                  onSaved: (val) => firstname = val!,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))], // allow only chars
                ),
              ),
              const SizedBox(height: 5),
              Card(
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.black87),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10)),
                  validator: (val) => val!.isEmpty ? 'Add Employee email' : null,
                  onSaved: (val) => email = val!,
                ),
              ),
              const SizedBox(height: 5),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      const Text(
                        "Department",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const Spacer(),
                      Expanded(
                        child: Center(
                          child: DropdownButton(
                            // Initial Value
                            value: _selectedDepartment,
                            icon: const SizedBox(),
                            items: widget.departmentsList.map((Department dep) {
                              return DropdownMenuItem(
                                value: dep,
                                child: Text("${dep.dep_name}"),
                              );
                            }).toList(),
                            onChanged: (Department? value) {
                              setState(() {
                                _selectedDepartment = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Card(
                child: GestureDetector(
                  onTap: _showDatePicker,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    enabled: false,
                    decoration: InputDecoration(
                        labelText: selectedDate != null
                            ? DateFormat('MM-dd-yyyy hh:mm a').format(selectedDate!)
                            : 'Hiring date',
                        labelStyle: const TextStyle(fontSize: 16, color: Colors.black87),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                height: 60,
                width: double.infinity,
                child: ElevatedButton(onPressed: _submitEmployee, child: const Text("Add new Employee")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

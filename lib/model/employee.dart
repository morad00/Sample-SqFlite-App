class Employee {
  String? emp_name;
  int? emp_hiredate;
  String? emp_email;
  int? fk_employee;
  String? dep_name;

  Employee(this.emp_name, this.emp_hiredate, this.emp_email, this.fk_employee, {this.dep_name});

  Employee.fromMap(Map map) {
    emp_name = map[emp_name];
    emp_hiredate = map[emp_hiredate];
    emp_email = map[emp_email];
    fk_employee = map[fk_employee];
    dep_name = map[dep_name];
  }
}

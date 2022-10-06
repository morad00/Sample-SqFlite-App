class Department {
  int? dep_id;
  String? dep_name;

  Department(this.dep_name, {this.dep_id});

  Department.fromMap(Map map) {
    dep_id = map[dep_id];
    dep_name = map[dep_name];
  }
}

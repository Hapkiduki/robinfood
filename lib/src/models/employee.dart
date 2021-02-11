// To parse this JSON data, do
//
//     final employee = employeeFromJson(jsonString);

import 'dart:convert';

List<Employee> employeeFromJson(String str) => List<Employee>.from(
    json.decode(str)['employees'].map((x) => Employee.fromJson(x)));

String employeeToJson(List<Employee> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Employee {
  Employee({
    this.id,
    this.name,
    this.position,
    this.wage,
    this.employees,
    this.isNew,
  });

  int id;
  String name;
  String position;
  int wage;
  List<Employee> employees;
  bool isNew;

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        position: json["position"] == null ? null : json["position"],
        wage: json["wage"] == null ? null : json["wage"],
        employees: json["employees"] == null
            ? null
            : List<Employee>.from(
                json["employees"].map((x) => Employee.fromJson(x))),
        isNew: json["isNew"] == null ? false : json["isNew"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "position": position == null ? null : position,
        "wage": wage == null ? null : wage,
        "employees": employees == null
            ? null
            : List<dynamic>.from(employees.map((x) => x.toJson())),
        "isNew": isNew == null ? false : isNew,
      };
}

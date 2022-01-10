// To parse this JSON data, do
//
//     final student = studentFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Student> studentFromJson(String str) => List<Student>.from(json.decode(str).map((x) => Student.fromJson(x)));

String studentToJson(List<Student> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Student {
  Student({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.surName,
    required this.studentNumber,
    required this.mobileNumber,
    required this.college,
    required this.program,
    required this.programCode,
    required this.yearLevel,
    required this.isSmsSent,
    required this.isCoe,
    required this.message,
  });

  int id;
  String firstName;
  String middleName;
  String surName;
  String studentNumber;
  String mobileNumber;
  String college;
  String program;
  String programCode;
  String yearLevel;
  int isSmsSent;
  int isCoe;
  String message;

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    id: json["id"],
    firstName: json["first_name"],
    middleName: json["middle_name"],
    surName: json["sur_name"],
    studentNumber: json["student_number"],
    mobileNumber: json["mobile_number"],
    college: json["college"],
    program: json["program"],
    programCode: json["program_code"],
    yearLevel: json["year_level"],
    isSmsSent: json["is_sms_sent"],
    isCoe: json["is_coe"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "middle_name": middleName,
    "sur_name": surName,
    "student_number": studentNumber,
    "mobile_number": mobileNumber,
    "college": college,
    "program": program,
    "program_code": programCode,
    "year_level": yearLevel,
    "is_sms_sent": isSmsSent,
    "is_coe": isCoe,
    "message": message,
  };
}

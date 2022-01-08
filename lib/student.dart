import 'dart:convert';

Student studentFromJson(String str) => Student.fromJson(json.decode(str));

String studentToJson(Student data) => json.encode(data.toJson());

class Student {
  Student({
    required this.success,
    required this.next,
    required this.previous,
    required this.message,
  });

  bool success;
  Next next;
  dynamic previous;
  String message;

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    success: json["success"],
    next: Next.fromJson(json["next"]),
    previous: json["previous"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "next": next.toJson(),
    "previous": previous,
    "message": message,
  };
}

class Next {
  Next({
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

  factory Next.fromJson(Map<String, dynamic> json) => Next(
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
  };
}

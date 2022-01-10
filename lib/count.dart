// To parse this JSON data, do
//
//     final count = countFromJson(jsonString);

import 'dart:convert';

Count countFromJson(String str) => Count.fromJson(json.decode(str));

String countToJson(Count data) => json.encode(data.toJson());

class Count {
  Count({
    required this.students,
    required this.sent,
  });

  int students;
  int sent;

  factory Count.fromJson(Map<String, dynamic> json) => Count(
        students: json["students"],
        sent: json["sent"],
      );

  Map<String, dynamic> toJson() => {
        "students": students,
        "sent": sent,
      };
}

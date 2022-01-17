import 'package:http/http.dart' as http;
import 'package:sms_sender/count.dart';
import 'package:sms_sender/student.dart';

class Data {
  static String uri = "https://apis.isaaac.tech/public/api/";

  static Future<List<Student>> getStudent() async {
    var url = Uri.parse('${uri}student');
    final response = await http.get(url);
    final List<Student> students = studentFromJson(response.body);
    return students;
  }

  static Future<Count> getCount() async {
    var url = Uri.parse('${uri}student/count');
    final response = await http.get(url);
    return countFromJson(response.body);
  }

  static Future postAndGetStudent(String id) async {
    var url = Uri.parse('${uri}student/post');
    final response = await http.post(url, body: {
      'id': id
    });
  }
}
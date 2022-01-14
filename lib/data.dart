import 'package:http/http.dart' as http;
import 'package:sms_sender/count.dart';
import 'package:sms_sender/student.dart';

class Data {
  static Future<List<Student>> getStudent() async {
    var url = Uri.parse('https://jsonkeeper.com/b/3GEN');
    final response = await http.get(url);
    final List<Student> students = studentFromJson(response.body);
    return students;
  }

  static Future<Count> getCount() async {
    var url = Uri.parse('https://jsonkeeper.com/b/24BK');
    final response = await http.get(url);
    return countFromJson(response.body);
  }

  static Future postAndGetStudent(String id) async {
    var url = Uri.parse('http://192.168.137.1/api/sms_api/public/api/student/post');
    final response = await http.post(url, body: {
      'id': id
    });
  }
}
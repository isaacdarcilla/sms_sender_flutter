import 'package:http/http.dart' as http;
import 'package:sms_sender/student.dart';

class Data {
  static Future getStudent() async {
    var url = Uri.parse('http://192.168.1.146/api/sms_api/public/api/student');
    final response = await http.get(url);
    return studentFromJson(response.body);
  }
}
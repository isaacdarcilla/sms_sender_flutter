import 'package:http/http.dart' as http;
import 'package:sms_sender/student.dart';

class Data {
  static Future getStudent() async {
    var url = Uri.parse('http://192.168.1.146/api/sms_api/public/api/student');
    final response = await http.get(url);
    return studentFromJson(response.body);
  }

  static Future postAndGetStudent(String id) async {
    var url = Uri.parse('http://192.168.1.146/api/sms_api/public/api/student/post');
    final response = await http.post(url, body: {
      'id': id
    });
    return studentFromJson(response.body);
  }

  static int getColorHexFromStr(String colorStr) {
    colorStr = "FF" + colorStr;
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw const FormatException("An error occurred when converting a color");
      }
    }
    return val;
  }
}
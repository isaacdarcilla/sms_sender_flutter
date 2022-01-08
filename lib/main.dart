import 'package:flutter/material.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:sms_sender/data.dart';
import 'package:sms_sender/student.dart';
import 'package:telephony/telephony.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CatSU SMS Sender',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'CatSU SMS Sender'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final Telephony telephony = Telephony.instance;

  late Student _student;
  late String _studentName = "No recipient yet.";
  bool _hasData = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;
  }

  Future _getStudent() async {
    Data.getStudent().then((student) {
      setState(() {
        _student = student;
        _hasData = true;

        _studentName = '${_student.next.firstName} ${_student.next.surName}';
      });
    });
  }

  void _sendMessage() {
    String address = _student.next.mobileNumber;
    String messageText = _student.message;

    // ignore: prefer_function_declarations_over_variables
    final SmsSendStatusListener listener = (SendStatus status) {
      print(status);
    };

    telephony.sendSms(
        to: address,
        message: messageText,
        statusListener: listener
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Send message to...',
            ),
            Text(
              _studentName,
              style: Theme
                  .of(context)
                  .textTheme
                  .headline6,
            ),
          ],
        ),
      ),
      floatingActionButton: !_hasData
          ? FloatingActionButton(
        onPressed: _getStudent,
        tooltip: 'Get student',
        child: const Icon(Icons.sync),
      )
          : FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send_rounded),
      ),
    );
  }
}

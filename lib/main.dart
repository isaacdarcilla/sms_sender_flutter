import 'package:flutter/material.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:sms_sender/data.dart';
import 'package:sms_sender/student.dart';

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
  late Student _student;
  late String _studentName = 'No recipient';
  bool _loading = false;

  Future _getStudent() async {
    _loading = true;
    Data.getStudent().then((student) {
      setState(() {
        _student = student;
        _loading = false;

        _studentName = '${_student.next.firstName} ${_student.next.surName}';
      });
    });

    sendMessage();
  }

  void sendMessage() {
    SmsSender sender = SmsSender();
    String address = _student.next.mobileNumber;
    String messageText = _student.message;

    SmsMessage message = SmsMessage(address, messageText);
    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS is sent!");
      } else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
      }
    });
    sender.sendSms(message);
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
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getStudent,
        tooltip: 'Increment',
        child: const Icon(Icons.sync),
      ),
    );
  }
}

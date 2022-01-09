import 'package:flutter/material.dart';
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

  int receiver = 0;
  int sent = 0;
  late String id;
  bool _hasData = false;
  bool _sending = false;

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

        id = _student.current.id.toString();
        receiver = _student.receiver;
        sent = _student.sent;

        _studentName =
            '${_student.current.firstName} ${_student.current.surName}';
      });
    });
  }

  Future _postAndGetStudent(id) async {
    Data.postAndGetStudent(id).then((student) {
      setState(() {
        _student = student;
        _hasData = true;

        id = _student.current.id.toString();
        receiver = _student.receiver;
        sent = _student.sent;

        _studentName =
            '${_student.current.firstName} ${_student.current.surName}';
      });
    });

    _sendMessage();
  }

  void _sendMessage() {
    String address = _student.current.mobileNumber;
    String messageText = _student.message;

    setState(() {
      _sending = true;
    });

    // ignore: prefer_function_declarations_over_variables
    final SmsSendStatusListener listener = (SendStatus status) {
      // ignore: unrelated_type_equality_checks
      if (status == 'SmsStatus.SENT') {
        _postAndGetStudent(id);
      }
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
      backgroundColor: Colors.blueAccent,
      body: ListView(
        children: <Widget>[
          Column(children: <Widget>[
            Stack(children: <Widget>[
              Container(
                height: 250.0,
                width: double.infinity,
                color: Color(Data.getColorHexFromStr('#FDD148')),
              ),
              Positioned(
                bottom: 250.0,
                right: 100.0,
                child: Container(
                  height: 400.0,
                  width: 400.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200.0),
                      color: Color(Data.getColorHexFromStr('#FEE16D'))
                          .withOpacity(0.4)),
                ),
              ),
              Positioned(
                bottom: 300.0,
                left: 150.0,
                child: Container(
                    height: 300.0,
                    width: 300.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(150.0),
                        color: Color(Data.getColorHexFromStr('#FEE16D'))
                            .withOpacity(0.5))),
              ),
              Column(
                children: <Widget>[
                  const SizedBox(height: 30.0),
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      height: 80.0,
                      width: 80.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.5),
                          border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 4.0),
                          image: const DecorationImage(
                              image: AssetImage('images/logo.png'))),
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.people_alt_rounded),
                            color: Colors.white,
                            iconSize: 40.0,
                            onPressed: () {},
                          ),
                          Text(
                            receiver.toString(),
                            style: const TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 30.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.message),
                            color: Colors.white,
                            iconSize: 40.0,
                            onPressed: () {},
                          ),
                          Text(
                            sent.toString(),
                            style: const TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 30.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30.0),
                ],
              ),
            ]),
          ]),
          const SizedBox(height: 30.0),
          Center(
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
        ],
      ),
      floatingActionButton: !_hasData
          ? FloatingActionButton(
              backgroundColor: Colors.yellow,
              onPressed: _getStudent,
              tooltip: 'Get student',
              child: const Icon(Icons.sync),
            )
          : FloatingActionButton(
              backgroundColor: Colors.yellow,
              onPressed: _sendMessage,
              tooltip: 'Send message',
              child: const Icon(Icons.send_rounded),
            ),
    );
  }
}

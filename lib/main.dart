import 'package:flutter/material.dart';
import 'package:sms_sender/count.dart';
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

  List<Student>? _student;
  Count? _count;
  bool _hasData = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _getStudents();
    _getCount();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;
  }

  Future _getStudents() async {
    _loading = true;
    Data.getStudent().then((student) {
      setState(() {
        _student = student;
        _loading = false;
        _hasData = true;
      });
    });
  }

  Future _getCount() async {
    Data.getCount().then((count) {
      setState(() {
        _count = count;
      });
    });
  }

  Future _send() async {
    for (var i in _student!) {
      _sendMessage(i.id, i.mobileNumber, i.message);
    }
  }

  void _sendMessage(id, address, message) {
    Data.postAndGetStudent(id.toString());
    _getCount();

    telephony.sendSms(
      to: address,
      message: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            '${_count?.students ?? 0}',
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
                            '${_count?.sent ?? 0}',
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
          const SizedBox(height: 15.0),
          _loading == true
              ? Container(
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.only(top: 20),
                  child: const CircularProgressIndicator(
                    value: 0.8,
                  ))
              : const SizedBox(height: 15.0),
          for (var i in _student!)
            listItem('${i.firstName.toString()} ${i.surName.toString()}',
                Colors.blue, Icons.person, i.mobileNumber, i.yearLevel)
        ],
      ),
      floatingActionButton: !_hasData
          ? FloatingActionButton(
              backgroundColor: Colors.yellow,
              onPressed: _getStudents,
              tooltip: 'Get student',
              child: const Icon(Icons.sync),
            )
          : FloatingActionButton(
              backgroundColor: Colors.yellow,
              onPressed: _send,
              tooltip: 'Send message',
              child: const Icon(Icons.send_rounded),
            ),
    );
  }

  Widget listItem(String title, Color buttonColor, iconButton, number, level) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: buttonColor.withOpacity(0.3)),
            child: Icon(iconButton, color: buttonColor, size: 25.0),
          ),
          const SizedBox(width: 25.0),
          SizedBox(
              width: MediaQuery.of(context).size.width - 100.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 15.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        number,
                      )
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

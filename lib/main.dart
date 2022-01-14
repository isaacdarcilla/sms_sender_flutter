import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
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
          primarySwatch: Colors.blue, backgroundColor: Colors.blueAccent),
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

  late List<Student> _student;
  Count? _count;
  bool _hasData = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;
  }

  Future _getStudents() async {
    Data.getStudent().then((student) {
      setState(() {
        _student = student;
        _hasData = true;
      });
    });

    return _student;
  }

  Future _getCount() async {
    Data.getCount().then((count) {
      setState(() {
        _count = count;
      });
    });
  }

  Future _send() async {
    for (var i in _student) {
      await Future.delayed(const Duration(seconds: 3));
      _sendMessage(i.id, i.mobileNumber, i.message);
    }
  }

  void _sendMessage(id, address, message) {
    setState(() {
      _hasData = false;
    });

    Data.postAndGetStudent(id.toString());

    telephony.sendSms(
      to: address,
      message: message,
    );

    _getCount();
  }

  void _alertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Send Notification"),
            titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
            actionsOverflowButtonSpacing: 20,
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("No")),
              ElevatedButton(
                  onPressed: () {
                    _send();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Yes")),
            ],
            content: const Text("Send an SMS notification to students?"),
          );
        });
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
                color: Colors.amberAccent,
              ),
              Positioned(
                bottom: 250.0,
                right: 100.0,
                child: Container(
                  height: 400.0,
                  width: 400.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200.0),
                      color: Colors.amberAccent.withOpacity(0.4)),
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
                        color: Colors.amberAccent.withOpacity(0.5))),
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
                            iconSize: 30.0,
                            onPressed: () {},
                          ),
                          Text(
                            '${_count?.students ?? '0'}',
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
                            iconSize: 30.0,
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
                      Column(
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.sync_outlined),
                            color: Colors.white,
                            iconSize: 40.0,
                            onPressed: () {
                              _getCount();
                            },
                          ),
                          const Text(
                            'Sync',
                            style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
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
          FutureBuilder(
            future: _getStudents(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(height: 20),
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              } else {
                return Scrollbar(
                    child: LazyLoadScrollView(
                      onEndOfPage: () { _getStudents(); },
                      child: ListView.builder(
                          physics: const ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: const Icon(Icons.supervised_user_circle,
                                  color: Colors.blueAccent, size: 30.0),
                              title: Text(
                                  '${snapshot.data[index].firstName} ${snapshot.data[index].surName}'),
                              subtitle: Text(snapshot.data[index].mobileNumber),
                              trailing: Text(
                                snapshot.data[index].studentNumber,
                                style: const TextStyle(fontSize: 11),
                              ),
                              dense: true,
                            );
                          }),
                    ));
              }
            },
          ),
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
              onPressed: _alertDialog,
              tooltip: 'Send message',
              child: const Icon(Icons.send_rounded),
            ),
    );
  }
}

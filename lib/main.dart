import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:pedometer/pedometer.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SharedPreferenceDemo(),
    );
  }
}

class MyData {
  final String email;
  final String pwd;
  MyData(this.email, this.pwd);
}

class SharedPreferenceDemo extends StatefulWidget {
  SharedPreferenceDemo() : super();

  final String title = "Stad Project";

  @override
  SharedPreferenceDemoState createState() => SharedPreferenceDemoState();
}

class SharedPreferenceDemoState extends State<SharedPreferenceDemo> {
// ignore: camel_case_types

  Future<bool> saveEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString("email", emailcontroller.text);
  }

  Future<bool> savePwd() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString("pass", pwdcontroller.text);
  }

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController pwdcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFFEADB),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 50.0),
                child: Text(
                  'StepChallenge',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: Color(0xFF679B9B),
                    fontSize: 54.0,
                    fontFamily: 'Berlin',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 100.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: TextField(
                        controller: emailcontroller,
                        decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                              fontFamily: 'Berlin',
                              color: Colors.black54,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1.5,
                                color: Color(0xFFFF9A76),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 4.0,
                                color: Color(0xFFFF9A76),
                              ),
                            )),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextField(
                        controller: pwdcontroller,
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(
                            fontFamily: 'Berlin',
                            color: Colors.black54,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Color(0xFFFF9A76),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 4.0,
                              color: Color(0xFFFF9A76),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 50.0),
                child: RaisedButton(
                  color: Color(0xffffeadb),
                  highlightColor: Color(0xFFFF9A76),
                  padding: EdgeInsets.fromLTRB(40, 7, 40, 7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                      color: Color(0xFFFF9A76),
                      width: 3.0,
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Berlin',
                      color: Color(0xFF679B9B),
                      fontSize: 35.0,
                    ),
                  ),
                  onPressed: () {
                    saveEmail();
                    savePwd();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePageFirst()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> loadEmail() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.reload();
  String userEmail = preferences.getString("email");
  return userEmail;
}

Future<String> loadPwd() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.reload();
  String userPassword = preferences.getString("pass");
  return userPassword;
}

class HomePageFirst extends StatefulWidget {
  @override
  HomeScreen createState() => HomeScreen();
}

class HomeScreen extends State<HomePageFirst> {
  String useremail = "";
  String steps = "";
  String calories = "";
  String km = "";
  StreamSubscription<int> _subscription;
  double number;
  double kms;

  @override
  void initState() {
    super.initState();
    loadEmail().then(updateName);
    setUpPedometer();
  }

  void setUpPedometer() {
    Pedometer pedometer = new Pedometer();
    _subscription = pedometer.pedometerStream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);
  }

  void _onDone() {}

  void _onError(error) {
    print("Flutter pedometer Error: $error");
  }

  void _onData(int stepCountValue) async {
    print(stepCountValue);
    setState(() {
      steps = "$stepCountValue";
      print(steps);
    });

    var distance = stepCountValue;
    double y = (distance + .0);

    setState(() {
      number = y;
    });

    var long3 = (number / 100);
    long3 = num.parse(y.toStringAsFixed(4));
    var long4 = (long3 / 10000);
    getDistanceRun(number);
  }

  void getDistanceRun(double number) {
    var distance = ((number * 78) / 100000);
    distance = num.parse(distance.toStringAsFixed(2));
    setState(() {
      km = "$distance";
      print(km);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFFEADB),
      appBar: AppBar(title: Text("Stad Project")),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.amber),
              child: Center(
                child: Text(
                  "Step Challenge",
                  style: TextStyle(fontFamily: 'Berlin', fontSize: 40.0),
                ),
              ),
            ),
            ScreenTile(
              Icons.help,
              "About",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
            ),
            ScreenTile(
              Icons.settings,
              "Settings",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreenState()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Welcome ",
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                            color: Color(0xFF679B9B),
                            fontSize: 24.0,
                            fontFamily: 'Berlin'),
                      ),
                      Text(
                        useremail,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                            color: Color(0xFF679B9B),
                            fontSize: 24.0,
                            fontFamily: 'Berlin'),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Text(
                          "Steps Taken = $steps",
                          style: TextStyle(
                              color: Color(0xFF679B9B),
                              fontSize: 24.0,
                              fontFamily: 'Berlin'),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Text(
                          "Total Distance = $km km",
                          style: TextStyle(
                              color: Color(0xFF679B9B),
                              fontSize: 24.0,
                              fontFamily: 'Berlin'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void updateName(String email) {
    setState(() {
      this.useremail = email;
    });
  }
}

class ScreenTile extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  ScreenTile(this.icon, this.text, this.onTap);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: InkWell(
        splashColor: Colors.amberAccent,
        onTap: onTap,
        child: Container(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(icon),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      text,
                      style: TextStyle(fontFamily: 'Berlin'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFFEADB),
      appBar: AppBar(title: Text("Stad Project")),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.amber),
              child: Center(
                child: Text(
                  "Step Challenge",
                  style: TextStyle(fontFamily: 'Berlin', fontSize: 40.0),
                ),
              ),
            ),
            ScreenTile(
              Icons.home,
              "Home",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePageFirst()),
                );
              },
            ),
            ScreenTile(
              Icons.settings,
              "Settings",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreenState()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Text(
                  'About Screen',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                      fontFamily: "Berlin",
                      fontSize: 54.0,
                      color: Color(0xFF679B9B)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 60),
                child: Text(
                  'StepChallenge is a simple and accurate step tracker that auto tracks your daily steps and walking distance, helping you maintain a healthy lifestyle. Stay active, lose weight!',
                  style: TextStyle(fontFamily: "Berlin", fontSize: 25),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 170),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(30, 7, 30, 7),
                        color: Color(0xffffeadb),
                        shape: RoundedRectangleBorder(
                          side: (BorderSide(
                            width: 1,
                            color: Color(0xFFFF9A76),
                          )),
                        ),
                        onPressed: () => launch("tel:91231234"),
                        child: Text(
                          "Call us",
                          style: TextStyle(fontFamily: "Berlin", fontSize: 20),
                        ),
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(23, 8, 23, 8),
                        color: Color(0xffffeadb),
                        shape: RoundedRectangleBorder(
                          side: (BorderSide(
                            width: 1,
                            color: Color(0xFFFF9A76),
                          )),
                        ),
                        onPressed: () => launch("mailto:yx28700@gmail.com"),
                        child: Text(
                          "Email us",
                          style: TextStyle(fontFamily: "Berlin", fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingScreenState extends StatefulWidget {
  @override
  SettingScreen createState() => SettingScreen();
}

class SettingScreen extends State<SettingScreenState> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController pwdcontroller = TextEditingController();

  Future<bool> saveEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString("email", emailcontroller.text);
  }

  Future<bool> savePwd() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString("pass", pwdcontroller.text);
  }

  String useremail = "";

  void initState() {
    super.initState();
    loadEmail().then(updateName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFFEADB),
      appBar: AppBar(title: Text("Stad Project")),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.amber),
              child: Center(
                child: Text(
                  "Step Challenge",
                  style: TextStyle(fontFamily: 'Berlin', fontSize: 40.0),
                ),
              ),
            ),
            ScreenTile(
              Icons.home,
              "Home",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePageFirst()),
                );
              },
            ),
            ScreenTile(
              Icons.settings,
              "About",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 30.0),
                child: Text(
                  'Profile',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontFamily: "Berlin",
                    fontSize: 54.0,
                    color: Color(0xFF679B9B),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 60),
                child: Row(
                  children: [
                    Container(
                      child: Text("Email : ",
                          style:
                              TextStyle(fontFamily: "Berlin", fontSize: 20.0)),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 150),
                      child: Text(useremail,
                          style:
                              TextStyle(fontFamily: "Berlin", fontSize: 18.0)),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                child: TextField(
                  controller: emailcontroller,
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(
                      fontFamily: 'Berlin',
                      color: Colors.black54,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Color(0xFFFF9A76),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 4.0,
                        color: Color(0xFFFF9A76),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 7),
                child: TextField(
                  controller: pwdcontroller,
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(
                      fontFamily: 'Berlin',
                      color: Colors.black54,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Color(0xFFFF9A76),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 4.0,
                        color: Color(0xFFFF9A76),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(30, 7, 30, 7),
                  color: Color(0xffffeadb),
                  shape: RoundedRectangleBorder(
                    side: (BorderSide(
                      width: 1,
                      color: Color(0xFFFF9A76),
                    )),
                  ),
                  onPressed: () {
                    saveEmail();
                    savePwd();
                  },
                  child: Text(
                    "Change ",
                    style: TextStyle(fontFamily: "Berlin", fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateName(String email) {
    setState(() {
      this.useremail = email;
    });
  }
}

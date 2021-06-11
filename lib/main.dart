import 'package:appentus_app/helper/db.dart';
import 'package:appentus_app/ui/home_view.dart';
import 'package:appentus_app/ui/login_view.dart';
import 'package:appentus_app/ui/second_view.dart';
import 'package:appentus_app/ui/signup_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => SignupView(),
        // '/': (context) => SignupView(),
        '/second': (context) => SecondView(),
        '/login': (context) => LoginView(),
        '/signup': (context) => SignupView(),
        '/home': (context) => HomeView(),
      },
    );
  }

  void initialize() {
    DB.connectToDB();
  }
}

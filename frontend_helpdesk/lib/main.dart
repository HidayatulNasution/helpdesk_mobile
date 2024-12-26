import 'package:flutter/material.dart';
import 'package:frontend_helpdesk/screens/list_tiket.dart';
import './screens/list_tiket.dart';
import './screens/add_tiket.dart';
// screens
import 'package:frontend_helpdesk/screens/onboarding.dart';
import 'package:frontend_helpdesk/screens/home.dart';
import 'package:frontend_helpdesk/screens/profile.dart';
import 'package:frontend_helpdesk/screens/login.dart';
// mail
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'System Helpdesk',
      theme: ThemeData(fontFamily: 'OpenSans'),
      initialRoute: "/onboarding",
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        "/onboarding": (BuildContext context) => new Onboarding(),
        "/account": (BuildContext context) => new Login(),
        "/home": (BuildContext context) => new Home(),
        "/profile": (BuildContext context) => new Profile(),
        "/AllTiket": (BuildContext context) => new ListTiket(),
        "/AddTiket": (BuildContext context) => new AddTiket(),
      },
    );
  }
}

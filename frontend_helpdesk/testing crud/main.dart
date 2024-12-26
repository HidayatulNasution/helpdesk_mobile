import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'tiket_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter API Integration',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/tickets': (context) => TicketListScreen(),
      },
    );
  }
}

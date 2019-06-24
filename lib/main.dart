import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:start_stopp/pages/home.dart';
import 'root.dart';
import 'auth/authentication.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color bleuF = Color(0xFF4da6ff);
    return MaterialApp(
      title: 'Start & Stopp App',
      theme: ThemeData(
        primaryColor: bleuF,
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          title: TextStyle(
            color: bleuF,
            fontFamily: 'OpenSans',
            fontSize: 22,
          ),
          subtitle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 15,
          ),
          body1: TextStyle(
            fontSize: 20,
            color: bleuF,
          ),
        ),
      ),
      home: RootPage(auth: Auth()),
    );
  }
}
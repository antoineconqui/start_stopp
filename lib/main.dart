import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'auth/login.dart';
import 'root.dart';
import 'auth/authentication.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Start & Stopp App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          title: TextStyle(
            color: Theme.of(context).primaryColor,
            fontFamily: 'OpenSans',
            fontSize: 22,
          ),
          subtitle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 15,
          ),
          body1: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      home: RootPage(auth: Auth()),
    );
  }
}
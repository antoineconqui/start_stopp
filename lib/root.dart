import 'package:flutter/material.dart';
import 'auth/authentication.dart';
import 'auth/login.dart';
import 'pages/home.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final Auth auth;
  
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {

  @override
  Widget build(BuildContext context) {
    return Login(auth: widget.auth, onSignedIn: onSignedIn);
  }

  onSignedIn(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(auth: widget.auth)));
    // return HomePage(auth: widget.auth);
  }
}
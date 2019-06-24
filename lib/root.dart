import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth/authentication.dart';
import 'auth/login.dart';
import 'pages/home.dart';

enum AuthStatus {
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  final Auth auth;

  RootPage({this.auth});
  
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus;
  String _userId = "";
  FirebaseUser _user;

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
          _user = user;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    if (authStatus==AuthStatus.NOT_LOGGED_IN)
      return Login(auth: widget.auth, onSignedIn: onSignedIn);
    return HomePage();//auth: widget.auth, user: _user, onSignedOut: onSignedOut);
  }

  void onSignedIn(){
    widget.auth.getCurrentUser().then((user){
      setState(() {
        _userId = user.uid.toString();
        _user = user;
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }
}
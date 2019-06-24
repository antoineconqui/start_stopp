import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'authentication.dart';

class Login extends StatefulWidget {
  final Auth auth;
  final VoidCallback onSignedIn;

  Login({this.auth, this.onSignedIn});

  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _errorMessage;
  bool _isIos;
  bool _isLoading = false;
  static Color bleuC = Color(0xFF74b9ff);
  static Color bleuF = Color(0xFF4da6ff);
  

  @override
  void initState() {
    _errorMessage = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    if(_isLoading)
      return buildWaitingScreen();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(shrinkWrap: true, children: _buildBody()),
            ),
          ),
        ],
      ),
      backgroundColor: bleuC,
    );
  }

  List<Widget> _buildBody() {
    return <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(0.0, 150.0, 0.0, 50.0),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(20),
            color: bleuF
          ),
          child: Column(
            children: <Widget>[
              Image(
                image: AssetImage('assets/launcher/drug.png'),
                height: 100,
                width: 100,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              ),
              Center(
                child: Text(
                  'Start & Stopp Scanner',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontFamily: 'OpenSans'
                  )
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(60.0, 30.0, 60.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            GoogleSignInButton(onPressed: _googleAuth),
          ]
        )
      ),
    ];
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _googleAuth() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    try {
      await widget.auth.googleSignIn();
      widget.onSignedIn();
      setState(() {
        _isLoading = false;
      });
      } catch (e) {
      print('Error: $e');
      setState(() {
        if (_isIos) {
          _errorMessage = e.details;
        } else
          _errorMessage = e.message;
      });
    }
  }

}
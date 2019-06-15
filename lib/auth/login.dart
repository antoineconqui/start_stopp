import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'authentication.dart';
import '../pages/home.dart';

class Login extends StatefulWidget {
  final Auth auth;
  final VoidCallback onSignedIn;
  // final VoidCallback onSignedOut;

  Login({this.auth, this.onSignedIn});

  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _errorMessage;
  bool _isIos;

  @override
  void initState() {
    _errorMessage = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Connexion')),
      ),
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
    );
  }

  List<Widget> _buildBody() {
    return <Widget>[
      Padding(
          padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
          child: Image(
            image: AssetImage('assets/launcher/drug.png'),
            height: 100,
            width: 100,
          )),
      Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
          child: Center(
            child: Text(
              'Veuillez vous connecter pour utiliser l\'application',
              textAlign: TextAlign.center,
            ),
          )),
      Padding(
          padding: const EdgeInsets.fromLTRB(60.0, 50.0, 60.0, 0.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GoogleSignInButton(onPressed: _googleAuth),
              ])),
      Padding(
          padding: EdgeInsets.fromLTRB(60.0, 45.0, 60.0, 0.0),
          child: SizedBox(
            height: 40.0,
            child: RaisedButton(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: Colors.blue,
              child: Text('To The App',
                  style: TextStyle(fontSize: 20.0, color: Colors.white)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(auth: Auth())));
              },
            ),
          )),
    ];
  }

  Future<void> _googleAuth() async {
    setState(() {
      _errorMessage = "";
    });
    try {
      await widget.auth.googleSignIn();
      widget.onSignedIn();
      // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(auth: widget.auth)));
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

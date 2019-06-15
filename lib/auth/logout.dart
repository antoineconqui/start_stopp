import 'package:flutter/material.dart';
import 'authentication.dart';
import '../root.dart';
import '../pages/home.dart';

class LogOut extends StatefulWidget {
  LogOut({this.auth});

  final Auth auth;

  @override
  State<StatefulWidget> createState() => _LogOutState();
}

class _LogOutState extends State<LogOut> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Votre compte')
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                  child: Image(
                    image: AssetImage('assets/launcher/drug.png'),
                    height: 100,
                    width: 100,
                  )
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                  child: Center(
                    child: Text(
                      '\nBonjour, ' + 'john' + ' !',
                      style: Theme.of(context).textTheme.title,
                    )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(60.0, 45.0, 60.0, 0.0),
                  child: SizedBox(
                    height: 40.0,
                    child: RaisedButton(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)
                      ),
                      color: Colors.blue,
                      child: Text(
                        'To The App',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white
                        )
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(auth: Auth())));
                      },
                    ),
                  )
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(60.0, 45.0, 60.0, 0.0),
                  child: SizedBox(
                    height: 40.0,
                    child: RaisedButton(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)
                      ),
                      color: Colors.blue,
                      child: Text(
                        'Déconnexion',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white
                        )
                      ),
                      onPressed: _signOut,
                    ),
                  )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    await widget.auth.signOut();
    Navigator.pop(context, MaterialPageRoute(builder: (context) => RootPage(auth:Auth())));
  }
}
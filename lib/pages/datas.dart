import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../auth/authentication.dart';
import '../auth/login.dart';
import 'home.dart';


class DatasPage extends StatefulWidget{
  @override
  _DatasPageState createState() => _DatasPageState();
}

class _DatasPageState extends State<DatasPage>{
  
  @override
  build(context) {
    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: Container(
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/launcher/drug.png'),
                    backgroundColor: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.blue,
                    ),
                    shape: BoxShape.circle
                  ),
                ),
                title: Text(
                  'Start & Stopp App',
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.add_a_photo),
                title: Text(
                  'Scan',
                  style: Theme.of(context).textTheme.subtitle,
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.data_usage),
                title: Text(
                  'Datas',
                  style: Theme.of(context).textTheme.subtitle,
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DatasPage()));
                },
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text(
                  'Paramètres',
                  style: Theme.of(context).textTheme.subtitle,
                ),
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text(
                  'Aide et commentaires',
                  style: Theme.of(context).textTheme.subtitle,
                ),
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesPage()));
                },
              ),
            ]
          ,),
        ),
        appBar: AppBar(
          title: Center(
            child: Text(
              'Datas',
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'OpenSans',
                color: Colors.white,
              )
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Login(auth: Auth())));
              },
            ),
          ],
        ),
        body: _buildBody(context),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   child: Icon(Icons.camera),
        // ),
      ),
    );
  }

  _buildBody(context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('test').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
              child: CircularProgressIndicator()
          );
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  _buildList(context, snapshot) {
   return ListView(
     padding: const EdgeInsets.only(top: 20.0),
     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
   );
 }

  _buildListItem(context, data) {
    final category = Category.fromMap(data);
    return Padding(
      key: ValueKey(category.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(category.name),
        ),
      ),
    );
  }

}

class Category {
  final name;
  final reference;
  Category.fromMap(map, {this.reference}) : assert(map['name'] != null), name = map['name'];
  Category.fromSnapshot(snapshot) : this.fromMap(snapshot.data, reference: snapshot.reference);
  String toString() => "Category<$name>";
}

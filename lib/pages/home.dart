import 'dart:convert';
import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlkit/mlkit.dart';
import 'package:http/http.dart';
import 'datas.dart';
// import '../auth/login.dart';
import '../auth/logout.dart';
import '../auth/authentication.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth});

  final Auth auth;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  List<VisionText> _textDetected = [];
  List<Drug> _drugs = [];
  FirebaseVisionTextDetector textDetector = FirebaseVisionTextDetector.instance;
  Widget _widget = Text(
      "Veuillez prendre une photo de l'ordonnance",
      style: TextStyle(
        fontSize: 25,
      ),
      textAlign: TextAlign.center,
    );
  bool _olderThan65 = false;

  @override
  initState() {
    super.initState();
  }

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
              'Scanner Ordonnance',
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LogOut(auth: widget.auth)));
              },
            ),
          ],
        ),
        body: _buildBody(),
        floatingActionButton: Container(
          height: 200,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 60,
                      child: FloatingActionButton(
                        heroTag: 'olderThan65',
                        onPressed: (){
                          setState(() {
                            _olderThan65 = !_olderThan65; 
                          });
                        },
                        backgroundColor: (_olderThan65) ? Colors.blue : Colors.white,
                        foregroundColor: (_olderThan65) ? Colors.white : Colors.blue,
                        shape: CircleBorder(
                          side: BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          '+65',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      height: 60,
                      child: FloatingActionButton(
                        heroTag: 'delete',
                        onPressed: (){
                          setState(() {
                           _drugs = [];
                           _widget =
                            Text(
                              "Veuillez prendre une photo de l'ordonnance",
                              style: Theme.of(context).textTheme.body1,
                              textAlign: TextAlign.center,
                            );
                          });
                        },
                        child: Icon(Icons.delete),
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      height: 60,
                      child: FloatingActionButton(
                        heroTag: 'photo',
                        onPressed: () async {
                          try {
                            _image = await ImagePicker.pickImage(source: ImageSource.camera);
                            // _image = await ImagePicker.pickImage(source: ImageSource.gallery);
                            setState(() {
                              _widget = CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                              );
                            });
                            try {
                              _textDetected = await textDetector.detectFromPath(_image?.path);
                              try {
                                List<Drug> drugs = await extractDrugs();
                                print(drugs.toString());
                                setState(() {
                                  _drugs = drugs;
                                  if(_drugs.length == 0)
                                    _widget = Text(
                                      "Aucun médicament trouvé",
                                      style: Theme.of(context).textTheme.body1,
                                      textAlign: TextAlign.center,
                                    );
                                });
                                print(_drugs.length);
                              } catch (e) {
                              }
                            } catch (e) {
                            }
                          } catch (e) {
                          }
                          
                        },
                        child: Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  _buildBody(){
    return Container(
      child: Column(
        children: <Widget>[
          _buildList(),
        ],
      ),
    );
  }

  _buildList() {
    if (_drugs.length == 0)
      return Expanded(
        child:Container(
          child: Center(
            child: _widget,
          ),
        ),
      );
    else{
      return Expanded(
        child: Container(
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
            padding: const EdgeInsets.all(1.0),
            itemCount: _drugs.length,
            itemBuilder: (context, i) {
              return _buildRow(_drugs[i]);
          }),
        ),
      );
    }
  }

  _buildRow(drug) {
    return ListTile(
      title: Text(
        drug[1],
        style: Theme.of(context).textTheme.body1,
        textAlign: TextAlign.center,
        ),
      dense: true,
    );
  }

  extractDrugs() async {
    List<Drug> drugs = [];
    RegExp reg = new RegExp(r'0|1|2|3|4|5|6|7|8|9|:|\(|\)');
    for (VisionText block in _textDetected)
      for (String line in block.text.split("\n"))
        for (String word in line.split(new RegExp(r" |/")))
          if(word.length > 3 && reg.allMatches(word).length==0){
            String rep = await read('https://rxnav.nlm.nih.gov/REST/approximateTerm?term='+word);
            List<String> candidates = rep.split("candidate");
            if(candidates.length > 1){
              String score = candidates[1].split("score")[1];
              String rxcui = candidates[1].split("rxcui")[1];
              if(int.parse(score.substring(1,score.length-2))==100){
                int id = int.parse(rxcui.substring(1,rxcui.length-2));
                String name = await read('https://rxnav.nlm.nih.gov/REST/RxTerms/rxcui/'+id.toString()+'/name');
                name = name.split('displayName')[1];
                if(name.length==3)
                  name = word.toUpperCase();
                else
                  name = name.substring(1,name.length-2).toUpperCase();
                List<Interaction> interactions = await extractDetails(id);
                Drug drug = Drug(id,name,interactions);
                if(!drugs.contains(drug))
                  drugs.add(drug);
              }
            }
          }
    return drugs;
  }

  Future<List<Interaction>> extractDetails(id) async {
    List<Interaction> interactions = List<Interaction>();
    String rep = await read('https://rxnav.nlm.nih.gov/REST/interaction/interaction.json?rxcui='+id.toString()+'&sources=ONCHigh');
    dynamic pairs = jsonDecode(rep)['interactionTypeGroup'];
    if(pairs==null){
      return interactions;
    }
    else{
      pairs = pairs[0]['interactionType'][0]['interactionPair'];
      for (dynamic pair in pairs) {
        print(pair['interactionConcept'][1]['minConceptItem']['rxcui']);
        print(pair['severity']);
        print(pair['description']);

        interactions.add(Interaction(pair['interactionConcept'][1]['rxcui'],pair['severity'],pair['description']));
      }
      return interactions;
    }
  }
}

class Drug {
  int id;
  String name;
  List<Interaction> interactions;

  Drug(this.id, this.name, this.interactions);
}

class Interaction {
  Drug drug;
  String severity;
  String description;

  Interaction(this.drug, this.severity, this.description);
}
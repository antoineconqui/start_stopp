import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlkit/mlkit.dart';
import 'package:http/http.dart';
import '../auth/authentication.dart';

class HomePage extends StatefulWidget {
  // final Auth auth;
  // final FirebaseUser user;
  // final VoidCallback onSignedOut;

  // HomePage({this.auth, this.user, this.onSignedOut});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  String _name = '';
  static Color bleuC = Color(0xFF74b9ff);
  static Color bleuF = Color(0xFF4da6ff);
  File _image;
  List<VisionText> _textDetected = [];
  List<Drug> _drugs = [];
  FirebaseVisionTextDetector textDetector = FirebaseVisionTextDetector.instance;
  Widget _widget = Text(
      "Veuillez prendre une photo de l'ordonnance",
      style: TextStyle(
        fontSize: 22,
        color: bleuF,
      ),
      textAlign: TextAlign.center,
    );
  bool _olderThan65 = false;

  @override
  initState(){
    // _name = widget.user.displayName;
    _name = 'Antoine Conqui';
    super.initState();
  }

  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: ListTile(
                  leading: Container(
                    width: 50.0,
                    height: 50.0,
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/launcher/drug.png'),
                      backgroundColor: Colors.white,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: bleuF,
                      ),
                      shape: BoxShape.circle
                    ),
                  ),
                  title: Text(
                    'Start & Stopp App',
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.add_a_photo, color: bleuF),
                title: Text(
                  'Scan',
                  style: Theme.of(context).textTheme.subtitle,
                ),
                onTap: () {
                  Navigator.pop(context, MaterialPageRoute(builder: (context) => HomePage()));//auth: widget.auth, user: widget.user, onSignedOut: widget.onSignedOut)));
                },
              ),
              Divider(
                height: 1,
              ),
              ExpansionTile(
                leading: Icon(Icons.account_circle, color: bleuF,),
                title: Text(
                  'Compte',
                  style: Theme.of(context).textTheme.subtitle,
                ),
                children: <Widget>[
                  Text(
                    _name,
                    style: TextStyle(
                      color: bleuF,
                      fontSize: 18
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(height: 10,),
                  MaterialButton(
                      color: Colors.red,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Text('Déconnexion'),
                      onPressed: _signOut,
                    )
                ],
              ),
              ListTile(
                leading: Icon(Icons.settings, color: bleuF),
                title: Text(
                  'Paramètres',
                  style: Theme.of(context).textTheme.subtitle,
                ),
                onTap: () {
                  // Navigator.pop(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.help, color: bleuF),
                title: Text(
                  'Aide et commentaires',
                  style: Theme.of(context).textTheme.subtitle,
                ),
                onTap: () {
                  // Navigator.pop(context, MaterialPageRoute(builder: (context) => CategoriesPage()));
                },
              ),
            ]
          ,),

        ),
        appBar: AppBar(
          backgroundColor: bleuC,
          centerTitle: true,
          title: Text(
            'Scanner Ordonnance ',
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'OpenSans',
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.help),
              onPressed: () {},
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
                        backgroundColor: (_olderThan65) ? bleuF : Colors.white,
                        foregroundColor: (_olderThan65) ? Colors.white : bleuF,
                        shape: CircleBorder(
                          side: BorderSide(
                            color: bleuF,
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
                              style: Theme.of(context).textTheme.title,
                              textAlign: TextAlign.center,
                            );
                          });
                        },
                        child: Icon(Icons.delete),
                        backgroundColor: bleuF,
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
                                valueColor: AlwaysStoppedAnimation<Color>(bleuF),
                              );
                            });
                            try {
                              _textDetected = await textDetector.detectFromPath(_image?.path);
                              _drugs = [];
                              try {
                                List<Drug> drugs = await extractDrugs();
                                setState(() {
                                  _drugs = drugs;
                                  if(_drugs.length == 0)
                                    _widget = Text(
                                      "Aucun médicament trouvé",
                                      style: Theme.of(context).textTheme.body1,
                                      textAlign: TextAlign.center,
                                    );
                                });
                              } catch (e) {
                              }
                            } catch (e) {
                            }
                          } catch (e) {
                          }
                          
                        },
                        child: Icon(Icons.add_a_photo),
                        backgroundColor: bleuF,
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

  Widget _buildBody(){
    return Container(
      child: Column(
        children: <Widget>[
          _buildList(),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (_drugs.length == 0)
      return Expanded(
        child:Container(
          child: Center(
            child: _widget,
          ),
        ),
      );
    return Expanded(
      child: Container(
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: bleuF,
          ),
          padding: const EdgeInsets.all(1.0),
          itemCount: _drugs.length,
          itemBuilder: (context, i) {
            return _buildRow(_drugs[i]);
        }),
      ),
    );
  }

  Widget _buildRow(drug) {
    if(drug.stopp=='')
      return ListTile(
        leading: Icon(
          Icons.check,
          color: Colors.green,
        ),
        title: Padding(
          padding: EdgeInsets.fromLTRB(40.0,0.0,0.0,0.0),
          child: Text(
            drug.name,
            style: Theme.of(context).textTheme.body1,
            textAlign: TextAlign.left,
          ),
        ),
      );
    return ExpansionTile(
      leading: Icon(
        Icons.warning,
        color: Colors.red,
      ),
      title: Padding(
        padding: EdgeInsets.fromLTRB(40.0,0.0,0.0,0.0),
        child: Text(
          drug.name,
          style: Theme.of(context).textTheme.body1,
          textAlign: TextAlign.left,
        ),
      ),
      children:<Widget>[
        Text(
          drug.category,
          style: TextStyle(
            color: Colors.red,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.left,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
          firstUpper(drug.stopp),
          style: TextStyle(
            color: Colors.red,
            fontSize: 15.0
          ),
          textAlign: TextAlign.justify,
        ),
        ),
      ],
    );
  }

  Future<Drug> getDrug(String name) async {
    Drug drug;
    QuerySnapshot snapshot = await Firestore.instance.collection('drugs').where('name', isEqualTo: name).getDocuments();
    if(snapshot.documents.isNotEmpty){
        drug = Drug.fromMap(snapshot.documents[0].data);
        drug.name = eachfirstUpper(drug.name);
        DocumentSnapshot category = await Firestore.instance.collection('categories').document(drug.category).get();
        drug.category = eachfirstUpper(category.data['name']);
        DocumentSnapshot stopp = await Firestore.instance.collection('stopp').document(category.data['stopp']).get();
        drug.stopp = stopp.data['text'];
    }
    return drug;
  }

  Future<List<Drug>> extractDrugs() async {
    List<Drug> drugs = [];
    RegExp reg = RegExp(r'0|1|2|3|4|5|6|7|8|9|\(|\)|\*|\.');
    for (VisionText block in _textDetected)
      for (String line in block.text.split("\n"))
        for (String word in line.split(RegExp(r" |/"))){
          Drug drug = await getDrug(word.toUpperCase());
          if(drug == null && word.length > 3 && reg.allMatches(word).length==0){
            String drugName = await isADrug(word);
            if(drugName != null)
              drug = Drug(eachfirstUpper(drugName),'','');
          }
          if(drug!=null && !drugs.contains(drug))
            drugs.add(drug);
        }
    print(drugs);
    return drugs;
  }

  Future<String> isADrug(String word) async {
    if(word == word.toUpperCase())
      return word;
    return null;
  }

  // Future<String> isADrug(String word) async {
  //   String rep = await read('https://rxnav.nlm.nih.gov/REST/approximateTerm?term='+word);
  //   List<String> candidates = rep.split("candidate");
  //   if(candidates.length > 1){
  //     String score = candidates[1].split("score")[1];
  //     String rxcui = candidates[1].split("rxcui")[1];
  //     if(int.parse(score.substring(1,score.length-2))==100){
  //       int id = int.parse(rxcui.substring(1,rxcui.length-2));
  //       String drugName = await read('https://rxnav.nlm.nih.gov/REST/RxTerms/rxcui/'+id.toString()+'/name');
  //       drugName = drugName.split('displayName')[1];
  //       if(drugName.length>3)
  //         return drugName.substring(1,drugName.length-2).toUpperCase();
  //       else
  //         return word;
  //     }
  //   }
  //   return null;
  // }

  // Future<List<Interaction>> extractDetails(id) async {
  //   List<Interaction> interactions = List<Interaction>();
  //   String rep = await read('https://rxnav.nlm.nih.gov/REST/interaction/interaction.json?rxcui='+id.toString()+'&sources=ONCHigh');
  //   dynamic pairs = jsonDecode(rep)['interactionTypeGroup'];
  //   if(pairs==null){
  //     return interactions;
  //   }
  //   else{
  //     pairs = pairs[0]['interactionType'][0]['interactionPair'];
  //     for (dynamic pair in pairs) {
  //       print(pair['interactionConcept'][1]['minConceptItem']['rxcui']);
  //       print(pair['severity']);
  //       print(pair['description']);

  //       interactions.add(Interaction(pair['interactionConcept'][1]['rxcui'],pair['severity'],pair['description']));
  //     }
  //     return interactions;
  //   }
  // }

  String eachfirstUpper(String string){
    List<String> list = [];
    string.split(' ').forEach((word) {
      list.add(firstUpper(word));
    });
    return list.join(' ');
  }

  String firstUpper(String string){
    return string[0].toUpperCase()+string.substring(1).toLowerCase();
  }
  
  _signOut() async {
    try {
      // await widget.auth.signOut();
      // widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }


}

class Drug {
  String name;
  String category;
  String stopp;
  // List<Interaction> interactions;

  Drug(this.name, this.category, this.stopp);//,interactions);
  Drug.fromMap(map) : name = map['name'], category = map['category'];
}

// class Interaction {
//   Drug drug;
//   String severity;
//   String description;

//   Interaction(this.drug, this.severity, this.description);
// }
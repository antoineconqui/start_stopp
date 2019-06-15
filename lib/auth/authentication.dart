import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signIn(email, password) async {
    _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> googleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(accessToken: googleAuth.accessToken,idToken: googleAuth.idToken);
    await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }
  
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<String> getCurrentUserName() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.displayName;
  }

}
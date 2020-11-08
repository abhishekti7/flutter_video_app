
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yello_video_player/managers/shared_pref_manager.dart';
import 'package:yello_video_player/models/UserModel.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

Future<bool> signInWithGoogle() async{
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken
  );

  print("Google sign in success: ${googleSignInAccount.email}");

  UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

  Map<String,String> userDetails = {
    'email': userCredential.user.email,
    'displayName': userCredential.user.displayName,
    'photoUrl': userCredential.user.photoURL,
    "uid": userCredential.user.uid
  };

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference reference = _firestore.collection("users");
  final UserModel userModel = new UserModel();
  userModel.email = userCredential.user.email;
  userModel.username = userCredential.user.displayName;
  userModel.userId = userCredential.user.uid;
  userModel.userUrl = userCredential.user.photoURL;
  userModel.storeInCache();
  reference.add(userDetails)
        .then((value) => print("Success"))
        .catchError((err)=>print(err));
  return true;
}

Future<void> signOutGoogle() async{
  await googleSignIn.signOut();
  SharedPreferences sharedPreferences = await SharedPrefManager.getInstance();
  sharedPreferences.clear()
    .then((value) => print("User cached cleared"))
    .catchError((err) => print(err));
  print("User Signed out from google");
}
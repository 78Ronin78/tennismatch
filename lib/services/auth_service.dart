import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tennis_match_app/locator.dart';
import 'package:tennis_match_app/models/user.dart';
import 'package:tennis_match_app/services/repository_service.dart';
import 'package:tennis_match_app/utils/message_exception.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final RepositoryService _repositoryService = locator<RepositoryService>();

  AuthService() : _firebaseAuth = FirebaseAuth.instance;

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    return Future.wait([_firebaseAuth.signOut()]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<UserProfile> getUser() async {
    var firebaseUser = await _firebaseAuth.currentUser;
    print(firebaseUser.uid);
    var user = await _repositoryService.getUser(firebaseUser.uid);

    if (user == null) {
      user = UserProfile(
        id: firebaseUser.uid,
        email: firebaseUser.email,
        name: firebaseUser.email.split('@')[0],
        imgUrl:
            'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=934&q=80',
      );
      _repositoryService.registerUser(user);
    }

    return user;
  }

  //Функциии входа в приложение с помощью соц.сетей

  //Google
  Future signInWithGoogle(context) async {
    await Firebase.initializeApp();
    GoogleSignInAccount googleSignInAccount;
    try {
      googleSignInAccount = await googleSignIn.signIn();
    } catch (e) {
      throw MessageException(
          'Возможно email уже занят, попробуй другой способ входа');
    }

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _firebaseAuth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _firebaseAuth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');
      //_redirectAuthUser(context);
    }
  }

  //   _redirectAuthUser(BuildContext context) async {
  //   DocumentSnapshot documentSnapshot =
  //       await _firestore.collection('users').doc(_firebaseAuth.currentUser.uid).get();
  //   var user;
  //   if (documentSnapshot != null && documentSnapshot.exists) {
  //     user = UserProfile.fromJson(documentSnapshot.data());
  //     if (user.name != null) {
  //       Navigator.pushNamed(context, 'tabNavigator');
  //     } else {
  //       Navigator.pushNamed(context, 'registrationScreen');
  //     }
  //   } else {
  //     Navigator.pushNamed(context, 'registrationScreen');
  //   }
  // }

  //AuthService fbAuth = AuthService();
}

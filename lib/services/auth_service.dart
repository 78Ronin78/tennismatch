import 'package:async/src/result/result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_vk/flutter_login_vk.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tennis_match_app/locator.dart';
import 'package:tennis_match_app/models/user.dart';
import 'package:tennis_match_app/services/repository_service.dart';
import 'package:tennis_match_app/utils/message_exception.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  //Create an instance of GoogleLogin
  final GoogleSignIn googleSignIn = GoogleSignIn();
  // Create an instance of VKLogin
  final vk = VKLogin(debug: true);
  final appId = '8105676'; // Your application ID
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
    print('USER: $user');
    if (user == null) {
      user = UserProfile(
        id: firebaseUser.uid,
        email: firebaseUser.email,
        name: null,
        /*firebaseUser.email.split('@')[0],*/
        avatarUrl: null,
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
    print('Credential Google token: ${credential.token}');

    final UserCredential authResult =
        await _firebaseAuth.signInWithCredential(credential);
    final User user = authResult.user;
    //После успешной авторизации с помощью Google пользователя необходимо сохранить в базе
    var userProfile = UserProfile(
      id: user.uid,
      email: user.email,
      name: null /*user.email.split('@')[0]*/,
      avatarUrl: null,
    );
    _repositoryService.registerUser(userProfile);
    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _firebaseAuth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');
      _repositoryService.redirectAuthUser(context, currentUser.uid);
      //redirectAuthUser(context);
    }
  }

  //VK.COM
  Future signInWithVK(context) async {
    // Initialize
    await vk.initSdk(appId);

    // Log in
    final res = await vk.logIn(scope: [
      VKScope.email,
    ]);
    // Check result
    if (res.isValue) {
      // There is no error, but we don't know yet
      // if user loggen in or not.
      // You should check isCanceled
      final VKLoginResult data = res.asValue.value;

      if (data.isCanceled) {
        // User cancel log in
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Авторизация отменена'),
          ),
        );
      } else {
        // Logged in

        // Send access token to server for validation and auth
        final VKAccessToken accessToken = data.accessToken;
        print('Access token: ${accessToken.token}');
        print('Access token: ${accessToken.token}');
        final AuthCredential credential = EmailAuthProvider.credential(
          email: accessToken.email,
          password: accessToken.userId,
        );
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: accessToken.email, password: accessToken.userId)
            .then((user) {
          // do whatever you want to do with new user object
          var userProfile = UserProfile(
            id: user.user.uid,
            email: user.user.email,
            name: null /*user.email.split('@')[0]*/,
            avatarUrl: null,
          );
          _repositoryService.registerUser(userProfile);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Успешная регистрация'),
              backgroundColor: Color(0xFFADFF2F),
            ),
          );
          if (user != null) {
            assert(!user.user.isAnonymous);
            assert(user.user.getIdToken() != null);

            final User currentUser = _firebaseAuth.currentUser;
            assert(user.user.uid == currentUser.uid);

            print('signInWithVK succeeded: $user');
            _repositoryService.redirectAuthUser(context, currentUser.uid);
            //redirectAuthUser(context);
          }
        }).catchError((e) async {
          //print(e); // code, message, details
          final UserCredential authResult =
              await _firebaseAuth.signInWithCredential(credential);
          final User user = authResult.user;
          //После успешной авторизации с помощью Google пользователя необходимо сохранить в базе
          var userProfile = UserProfile(
            id: user.uid,
            email: user.email,
            name: null /*user.email.split('@')[0]*/,
            avatarUrl: null,
          );
          _repositoryService.registerUser(userProfile);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Успешная авторизация'),
              backgroundColor: Color(0xFFADFF2F),
            ),
          );
          if (user != null) {
            assert(!user.isAnonymous);
            assert(await user.getIdToken() != null);

            final User currentUser = _firebaseAuth.currentUser;
            assert(user.uid == currentUser.uid);

            print('signInWithVK succeeded: $user');
            _repositoryService.redirectAuthUser(context, currentUser.uid);
            //redirectAuthUser(context);
          }
        });
      }
    } else {
      // Log in failed
      final errorRes = res.asError;
      print('Error while log in: ${errorRes.error}');
    }
  }
}

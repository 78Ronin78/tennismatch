import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tennis_match_app/blocs/home_bloc/home_bloc.dart';
import 'package:tennis_match_app/models/chat_message.dart';
import 'package:tennis_match_app/models/chat_room_info.dart';
import 'package:tennis_match_app/models/user.dart';
import 'package:tennis_match_app/screens/home_screen.dart';
import 'package:tennis_match_app/screens/register/register_screen.dart';

class RepositoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserProfile> getUser(String id) async {
    print('Айдишник: $id');
    var doc = await _firestore.collection('users').doc(id).get();
    print('Данные: ${doc.data()}');
    if (doc.data() != null) {
      print('условие выполняется');

      return UserProfile(
        uid: doc.data()['id'],
        name: doc.data()['name'],
        lastName: doc.data()['lastName'],
        phone: doc.data()['phone'],
        skillLevel: doc.data()['skillLevel'],
        gameExperience: doc.data()['gameExperience'],
        country: doc.data()['country'],
        city: doc.data()['city'],
        birthDate: doc.data()['birthDate'],
        gender: doc.data()['gender'],
        rise: doc.data()['rise'],
        weight: doc.data()['weight'],
        weeksAvailability: doc.data()['weeksAvailability'],
        weekendAvailability: doc.data()['weekendAvailability'],
        ipAddresses: doc.data()['ipAddresses'],
        about: doc.data()['about'],
        email: doc.data()['email'],
        avatarUrl: doc.data()['avatarUrl'],
      );
    }
    return null;
  }

  Future<void> registerUser(UserProfile user) async {
    _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
    });
  }

  Future<void> registerProfileData(UserProfile user) async {
    _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'name': user.name,
      'lastName': user.lastName,
      'phone': user.phone,
      'skillLevel': user.skillLevel,
      'gameExperience': user.gameExperience,
      'country': user.country,
      'city': user.city,
      'birthDate': user.birthDate,
      'gender': user.gender,
      'rise': user.rise,
      'weight': user.weight,
      'weeksAvailability': user.weeksAvailability,
      'weekendAvailability': user.weekendAvailability,
      'ipAddresses': user.ipAddresses,
      'about': user.about,
      'avatarUrl': user.avatarUrl
    });
  }

  //Функция перенаправления пользователя, если он авторизовался через google
  Future<UserProfile> redirectAuthUser(BuildContext context, String uid) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(uid).get();
    var user;
    if (documentSnapshot != null && documentSnapshot.exists) {
      user = documentSnapshot.data();
      print('ID: ${user['uid']}');
      if (user['name'] != null) {
        //Navigator.pushNamed(context, 'tabNavigator');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => BlocProvider(
                      create: (context) => HomeBloc(),
                      child: HomeScreen(),
                    )),
            (Route<dynamic> route) => false);
      } else {
        //Navigator.pushNamed(context, 'registrationScreen');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => RegisterScreen()),
            (Route<dynamic> route) => false);
      }
    } else {
      //Navigator.pushNamed(context, 'registrationScreen');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => RegisterScreen()),
          (Route<dynamic> route) => false);
    }
    return null;
  }

  Future<void> setChatRoom(ChatRoomInfo chatRoomInfo) async {
    return await _firestore
        .collection('chat_rooms')
        .doc(chatRoomInfo.title)
        .set(chatRoomInfo.toJson());
  }

  Future<DocumentSnapshot> getChatRoom(String title) async {
    return await _firestore.collection('chat_rooms').doc(title).get();
  }

  Future<void> updateUserChatList(String id, String title) async {
    var chatListDoc = await _firestore.collection('user_chats').doc(id).get();
    if (chatListDoc.exists) {
      return chatListDoc.reference.update({title: true});
    } else {
      return chatListDoc.reference.set({title: true});
    }
  }

  Stream<DocumentSnapshot> getChatList(String id) {
    return _firestore.collection('user_chats').doc(id).snapshots();
  }

  Stream<QuerySnapshot> getChatMessages(String title) {
    return _firestore
        .collection('chat_rooms')
        .doc(title)
        .collection('messages')
        .orderBy('time', descending: false)
        .limit(20)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatRoomInfo(List<String> chatTitles) {
    return _firestore
        .collection('chat_rooms')
        .where('title', whereIn: chatTitles)
        .snapshots();
  }

  Future<void> sendChatMessage(String title, ChatMessage chatMessage) async {
    var reference = _firestore
        .collection('chat_rooms')
        .doc(title)
        .collection('messages')
        .doc(chatMessage.time);

    return _firestore.runTransaction((transaction) async {
      transaction.set(reference, {
        'message': chatMessage.message,
        'time': chatMessage.time,
        'senderId': chatMessage.senderId,
      });
    });
  }

  Future<void> setChatRoomLastMessage(
      String title, ChatMessage chatMessage) async {
    var reference = _firestore.collection('chat_rooms').doc(title);

    return _firestore.runTransaction((transaction) async {
      transaction.update(reference, {
        'lastMessage': chatMessage.message,
        'lastModified': chatMessage.time,
      });
    });
  }
}

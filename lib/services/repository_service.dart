import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_match_app/models/chat_message.dart';
import 'package:tennis_match_app/models/chat_room_info.dart';
import 'package:tennis_match_app/models/user.dart';

class RepositoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserProfile> getUser(String id) async {
    var doc = await _firestore.collection('users').doc(id).get();

    if (doc.data != null) {
      return UserProfile(
        id: doc.data()['id'],
        name: doc.data()['name'],
        email: doc.data()['email'],
        imgUrl: doc.data()['imgUrl'],
      );
    }
    return null;
  }

  Future<void> registerUser(UserProfile user) async {
    _firestore.collection('users').doc(user.id).set({
      'id': user.id,
      'email': user.email,
      'name': user.name,
      'imgUrl': user.imgUrl
    });
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
      await transaction.set(reference, {
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
      await transaction.update(reference, {
        'lastMessage': chatMessage.message,
        'lastModified': chatMessage.time,
      });
    });
  }
}

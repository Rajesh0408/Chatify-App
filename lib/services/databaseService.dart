import 'package:cloud_firestore/cloud_firestore.dart';

//models
import '../models/chatMessage.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSAGES_COLLECTION = "messages";

class DatabaseService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  DatabaseService() {}

  Future<DocumentSnapshot> getUser(String uid) {
    return db.collection(USER_COLLECTION).doc(uid).get();
  }

  Stream<QuerySnapshot> getChatsForUser(String _uid) {
    return db
        .collection(CHAT_COLLECTION)
        .where('members', arrayContains: _uid)
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessageForChat(String _chatId) {
    return db
        .collection(CHAT_COLLECTION)
        .doc(_chatId)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: true)
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessagesForChat(String _chatId) {
    return db
        .collection(CHAT_COLLECTION)
        .doc(_chatId)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: false)
        .snapshots();
  }

  Future<void> addMessageToChat(String _chatId, ChatMessage _message) async {
    print(_message.toJson());
    try {
      await db
          .collection(CHAT_COLLECTION)
          .doc(_chatId)
          .collection(MESSAGES_COLLECTION)
          .add(
            _message.toJson(),
          );
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateChatData(
      String _chatId, Map<String, dynamic> _data) async {
    try {
      await db.collection(CHAT_COLLECTION).doc(_chatId).update(_data);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserLastSeenTime(String uid) async {
    try {
      await db.collection(USER_COLLECTION).doc(uid).update({
        "last_active": DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteChat(String _chatId) async {
    try {
      await db.collection(CHAT_COLLECTION).doc(_chatId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> createUser(
      String uid, String email, String name, String imageURL) async {
    try {
      await db.collection(USER_COLLECTION).doc(uid).set({
        "email": email,
        "image": imageURL,
        "name": name,
        "last_active": DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }
}

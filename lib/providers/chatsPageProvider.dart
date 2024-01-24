import 'dart:async';

//packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

//services
import '../services/databaseService.dart';

//providers
import '../providers/authenticationProvider.dart';

//Models
import '../models/chat.dart';
import '../models/chatMessage.dart';
import '../models/chatUser.dart';

class ChatsPageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;

  late DatabaseService _db;

  List<Chat>? chats;

  late StreamSubscription _chatsStream;


  ChatsPageProvider(this._auth) {
    _db = GetIt.instance.get<DatabaseService>();
    getChats();
  }

  @override
  void dispose() {
    _chatsStream.cancel();
    super.dispose();
  }

  void getChats() async {
    try {
      _chatsStream =
          _db.getChatsForUser(_auth.user!.uid).listen((_snapshot) async {
        chats = await Future.wait(
          _snapshot.docs.map((_d) async {
            Map<String, dynamic> _chatData = _d.data() as Map<String, dynamic>;
            //Get users in chat
            List<ChatUser> members = [];
            for (var uid in _chatData["members"]) {
              DocumentSnapshot _userSnapshot = await _db.getUser(uid);
              Map<String, dynamic> _userData =
                  _userSnapshot.data() as Map<String, dynamic>;
              _userData['uid'] = _userSnapshot.id;
              members.add(ChatUser.fromJSON(_userData));
            }

            //Get last message for chat
            List<ChatMessage> _messages = [];
            QuerySnapshot _chatMessage = await _db.getLastMessageForChat(_d.id);
            if (_chatMessage.docs.isNotEmpty) {
              Map<String, dynamic> _messageData =
                  _chatMessage.docs.first.data()! as Map<String, dynamic>;
              ChatMessage _message = ChatMessage.fromJSON(_messageData);
              _messages.add(_message);
            }
            //Return chat Instance
            return Chat(
                uid: _d.id,
                currentUserUid: _auth.user!.uid,
                activity: _chatData['is_activity'],
                group: _chatData['is_group'],
                members: members,
                messages: _messages);
          }).toList(),
        );
        notifyListeners();
      });
    } catch (e) {
      print("Error getting chats");
      print(e);
    }
  }
}

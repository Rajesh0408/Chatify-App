//packages

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

//services
import '../services/databaseService.dart';
import '../services/navigationService.dart';

//providers
import '../providers/authenticationProvider.dart';

//model
import '../models/chatUser.dart';
import '../models/chat.dart';

//page
import '../pages/chat_page.dart';

class UsersPageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;

  late DatabaseService _database;
  late NavigationService _navigation;

  List<ChatUser>? users;
  late List<ChatUser> _selectedUsers;

  List<ChatUser> get selectedUsers {
    return _selectedUsers;
  }

  UsersPageProvider(this._auth) {
    _selectedUsers = [];
    _database = GetIt.instance.get<DatabaseService>();
    _navigation = GetIt.instance.get<NavigationService>();
    getUsers();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void getUsers({String? name}) async {
    // _selectedUsers = [];
    try {
      _database.getUsers(name: name).then(
        (_snapshot) {
          users = _snapshot.docs.map((_doc) {
            Map<String, dynamic> _data = _doc.data() as Map<String, dynamic>;
            _data["uid"] = _doc.id;
            return ChatUser.fromJSON(_data);
          }).toList();
          notifyListeners();
        },
      );
    } catch (e) {
      print("Error getting Users");
      print(e);
    }
  }

  void updateSelectedUsers(ChatUser user) {
    if (_selectedUsers.contains(user)) {
      _selectedUsers.remove(user);
    } else {
      _selectedUsers.add(user);
    }
    notifyListeners();
  }

  void createChat() async {
    try {
      List<String> _membersIds =
          _selectedUsers.map((_user) => _user.uid).toList();
      _membersIds.add(_auth.user!.uid);
      bool _isGroup = _selectedUsers.length > 1;
      DocumentReference? _doc = await _database.createChat({
        "is_group": _isGroup,
        "is_activity": false,
        "members": _membersIds,
      });
      //Navigate to Chat Page
      List<ChatUser> _members = [];
      for (var _uid in _membersIds) {
        DocumentSnapshot _userSnapshot = await _database.getUser(_uid);
        Map<String, dynamic> _userData =
            _userSnapshot.data() as Map<String, dynamic>;
        _userData["uid"] = _userSnapshot.id;
        _members.add(ChatUser.fromJSON(_userData));
      }
      ChatPage _chatPage = ChatPage(
          chat: Chat(
              uid: _doc!.id,
              currentUserUid: _auth.user!.uid,
              activity: false,
              group: _isGroup,
              members: _members,
              messages: []));
      _selectedUsers =[];
      notifyListeners();
      _navigation.navigateToPage(_chatPage);
    } catch (e) {
      print("Error creating chat");
      print(e);
    }
  }
}

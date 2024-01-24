import 'dart:async';

import 'package:async/async.dart';

//packages
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

//services
import '../services/databaseService.dart';
import '../services/cloudStorageService.dart';
import '../services/mediaService.dart';
import '../services/navigationService.dart';

//providers
import '../providers/authenticationProvider.dart';

//models
import '../models/chatMessage.dart';

class ChatPageProvider extends ChangeNotifier {
  late DatabaseService _db;
  late CloudStorageService _storage;
  late MediaService _media;
  late NavigationService _navigation;

  AuthenticationProvider _auth;
  ScrollController _messagesListViewController;

  String _chatId;
  List<ChatMessage>? messages;

  late StreamSubscription _messagesStream;
  late StreamSubscription _keyboardVisibilityStream;
  late KeyboardVisibilityController _keyBoardVisibilityController;

  String? _message;

  String get message {
    return message;
  }

  void set message(String value) {
    _message = value;
  }

  ChatPageProvider(this._chatId, this._auth, this._messagesListViewController) {
    _db = GetIt.instance.get<DatabaseService>();
    _storage = GetIt.instance.get<CloudStorageService>();
    _media = GetIt.instance.get<MediaService>();
    _navigation = GetIt.instance.get<NavigationService>();
    _keyBoardVisibilityController = KeyboardVisibilityController();
    listenToMessages();
    listenToKeyboardChanges();
  }

  @override
  void dispose() {
    _messagesStream.cancel();
    super.dispose();
  }

  void listenToMessages() {
    try {
      _messagesStream = _db.streamMessagesForChat(_chatId).listen(
        (_snapshot) {
          List<ChatMessage> _messages = _snapshot.docs.map(
            (_m) {
              Map<String, dynamic> _messageData =
                  _m.data() as Map<String, dynamic>;
              return ChatMessage.fromJSON(_messageData);
            },
          ).toList();
          messages = _messages;
          notifyListeners();
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              if (_messagesListViewController.hasClients) {
                _messagesListViewController.jumpTo(
                    _messagesListViewController.position.maxScrollExtent);
              }
            },
          );
        },
      );
    } catch (e) {
      print("Error getting Messages");
      print(e);
    }
  }

  void listenToKeyboardChanges() {
    _keyboardVisibilityStream =
        _keyBoardVisibilityController.onChange.listen((_event) {
      _db.updateChatData(_chatId, {"is_activity": _event});
    });
  }

  void sendTextMessage() {
    if (_message != null) {
      ChatMessage messageToSend = ChatMessage(
        content: _message!,
        type: MessageType.TEXT,
        senderId: _auth.user!.uid,
        sentTime: DateTime.now(),
      );
      _db.addMessageToChat(_chatId, messageToSend);
    }
  }

  void sentImageMessage() async {
    try {
      PlatformFile? _file = await _media.pickImageFromLibrary();
      if (_file != null) {
        String? _downloadURL = await _storage.saveChatImageToStorage(
          _chatId,
          _auth.user!.uid,
          _file,
        );
        ChatMessage _messageToSend = ChatMessage(
          content: _downloadURL!,
          type: MessageType.IMAGE,
          senderId: _auth.user!.uid,
          sentTime: DateTime.now(),
        );
        _db.addMessageToChat(_chatId, _messageToSend);
      }
    } catch (e) {
      print("Error sending image message");
      print(e);
    }
  }

  void deleteChat() {
    goBack();
    _db.deleteChat(_chatId);
  }

  void goBack() {
    _navigation.goBack();
  }
}

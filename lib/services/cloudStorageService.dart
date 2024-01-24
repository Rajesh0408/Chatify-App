import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

const String USER_COLLECTION = "Users";

class CloudStorageService {
  final FirebaseStorage _storage =
      FirebaseStorage.instanceFor(bucket: 'chatify-app-udemy.appspot.com');

  CloudStorageService() {}

  Future<String?> saveUserImageToStorage(String uid, PlatformFile file) async {
    try {
      Reference ref =
          _storage.ref().child('images/users/$uid/profile.${file.extension}');
      UploadTask task = ref.putFile(File(file.path ?? ""));
      return await task.then((result) => result.ref.getDownloadURL());
    } catch (e) {
      print(e);
    }
  }

  Future<String?> saveChatImageToStorage(
      String chatId, String uid, PlatformFile file) async {
    try {
      Reference ref = _storage.ref().child(
          'images/chats/$chatId/${uid}_${Timestamp.now().millisecondsSinceEpoch}.${file.extension}');
      UploadTask task = ref.putFile(File(file.path ?? ""));
      return await task.then((result) => result.ref.getDownloadURL());

    } catch (e) {
      print(e);
    }
  }
}

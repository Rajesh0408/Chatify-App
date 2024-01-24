import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  final String uid;
  final String name;
  final String email;
  final String image;
  late DateTime lastActive;

  ChatUser(
      {required this.uid,
      required this.name,
      required this.email,
      required this.image,
      required this.lastActive});

  factory ChatUser.fromJSON(Map<String, dynamic> json) {
    return ChatUser(
        uid: json["uid"],
        name: json["name"],
        email: json["email"],
        image: json["image"],
        lastActive: json["last_active"] != null
            ? (json["last_active"] as Timestamp).toDate()
            : DateTime.now(),);
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "name": name,
      "image": image,
      "lastActive": lastActive
    };
  }

  String lastDayActive(){
    return "${lastActive.month}/${lastActive.day}/${lastActive.year}";
  }

  bool wasRecentlyActive(){
    return DateTime.now().difference(lastActive).inHours < 2;
  }
}

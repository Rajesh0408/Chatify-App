import '../models/chatUser.dart';
import '../models/chatMessage.dart';

class Chat {
  final String uid;
  final String currentUserUid;
  final bool activity;
  final bool group;
  final List<ChatUser> members;
  List<ChatMessage> messages;

  late final List<ChatUser> _recepients;

  Chat(
      {required this.uid,
      required this.currentUserUid,
      required this.activity,
      required this.group,
      required this.members,
      required this.messages}) {
    _recepients = members.where((i) => i.uid != currentUserUid).toList();
  }

  List<ChatUser> recepients() {
    return _recepients;
  }

  String title() {
    return !group
        ? _recepients.first.name
        : _recepients.map((_user) => _user.name).join(", ");
  }

  String imageURL(){
    return !group? _recepients.first.image : "https://cdn2.vectorstock.com/i/1000x1000/26/66/profile-icon-member-society-group-avatar-vector-18572666.jpg";
  }
}

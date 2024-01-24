import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { TEXT, IMAGE, UNKNOWN }

class ChatMessage {
  final String senderId;
  final MessageType type;
  final String content;
  final DateTime sentTime;

  ChatMessage(
      {required this.content,
      required this.type,
      required this.senderId,
      required this.sentTime});

  factory ChatMessage.fromJSON(Map<String, dynamic> json) {
    MessageType messageType;
    switch (json["type"]) {
      case "text":
        messageType = MessageType.TEXT;
        break;
      case "image":
        messageType = MessageType.IMAGE;
        break;
      default:
        messageType = MessageType.UNKNOWN;
    }
    return ChatMessage(
      content: json["content"],
      type: messageType,
      senderId: json["sender_id"],
      sentTime: json["sent_time"].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    String messageType;
    switch (type) {
      case MessageType.TEXT:
        messageType = "text";
        break;
      case MessageType.IMAGE:
        messageType = "image";
        break;
      default:
        messageType = "";
    }
    return {
      "content": content,
      "type": messageType,
      "sender_id": senderId,
      "sent_time": Timestamp.fromDate(sentTime),
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String? id;
  final DateTime? lastMessageTimeStamp;
  final DateTime? createdAt;
  final List<String>? users;
  final String? lastMessage;

  ChatModel({
    this.id,
    this.lastMessageTimeStamp,
    this.createdAt,
    this.users,
    this.lastMessage,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    id: json["id"],
    lastMessageTimeStamp: json["lastMessageTimeStamp"] is Timestamp
        ? (json["lastMessageTimeStamp"] as Timestamp).toDate()
        : null,
    createdAt: json["createdAt"] is Timestamp
        ? (json["createdAt"] as Timestamp).toDate()
        : null,
    users: json["users"] == null
        ? []
        : List<String>.from(json["users"].map((x) => x)),
    lastMessage: json["last_message"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "lastMessageTimeStamp": lastMessageTimeStamp,
    "createdAt": createdAt,
    "users": users ?? [],
    "last_message": lastMessage,
  };
}
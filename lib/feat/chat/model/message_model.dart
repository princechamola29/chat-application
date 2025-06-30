

// To parse this JSON data, do
//
//     final messageModel = messageModelFromJson(jsonString);

import 'dart:convert';

MessageModel messageModelFromJson(String str) => MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  final DateTime? createdAt;
  final String? msg;
  final String? recieverId;
  final String? senderId;

  MessageModel({
    this.createdAt,
    this.msg,
    this.recieverId,
    this.senderId,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    createdAt: DateTime.parse(json["createdAt"]),
    msg: json["msg"],
    recieverId: json["reciverId"],
    senderId: json["senderId"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt?.toIso8601String(),
    "msg": msg,
    "reciverId": recieverId,
    "senderId": senderId,
  };
}

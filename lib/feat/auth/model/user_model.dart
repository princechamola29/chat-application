// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final String? uuid;
  final String? email;
  final String? name;

  UserModel({
    this.uuid,
    this.email,
    this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uuid: json["Uuid"],
    email: json["email"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "Uuid": uuid,
    "email": email,
    "name": name,
  };
}

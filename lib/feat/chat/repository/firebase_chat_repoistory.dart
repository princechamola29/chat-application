import 'dart:convert';

import 'package:chatapplication/feat/auth/model/user_model.dart';
import 'package:chatapplication/feat/chat/model/chat_model.dart';
import 'package:chatapplication/feat/chat/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseChatRepositoryProvider = Provider(
      (ref) => FirebaseChatRepository(ref),
);

class FirebaseChatRepository {
  final Ref ref;

  FirebaseChatRepository(this.ref);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> fetchSearchQueryData({String? userName}) async {
    String searchName;
    try {
      if (userName == null || userName
          .trim()
          .isEmpty) {
        searchName = "";
      } else {
        searchName = userName;
      }
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance
          .collection("users")
          .where('name', isGreaterThanOrEqualTo: searchName)
          .where('name', isLessThan: searchName + 'z')
          .limit(10)
          .get();
      List<UserModel> data =
      querySnapshot.docs
          .where(
            (doc) => doc["Uuid"] != FirebaseAuth.instance.currentUser?.uid,
      )
          .map(
            (element) =>
            UserModel.fromJson(element.data() as Map<String, dynamic>),
      )
          .toList();
      return data;
    } catch (error) {
      rethrow;
    }
  }

  Future<String> createChat({required String otherUUid}) async {
    final myUuid = FirebaseAuth.instance.currentUser?.uid ?? '';
    List<String> users = [otherUUid, myUuid]..sort();
    final input = users.join(":");
    final chatId = generateUniqueUID(input);
    final snapshot = await _firestore.collection('chats').doc(chatId).get();
    if (snapshot.exists) {
      return chatId;
    } else {
      final ChatModel chatModel = ChatModel(
        createdAt: DateTime.now(),
        users: users,
        id: chatId,
      );
      await _firestore.collection('chats').doc(chatId).set(chatModel.toJson());
    }
    return chatId;
  }

  Future<void> sendMessages({
    required MessageModel messageModel,
    required String chatId,
  }) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection("messages")
          .doc()
          .set(messageModel.toJson());
      await _firestore.collection('chats').doc(chatId).update({
        "lastMessageTimeStamp": DateTime.now(),
        "last_message": messageModel.msg,
      });
    } catch (error) {}
  }

  Stream<List<ChatModel>?> streamChatList() async* {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> chatSnapshot;

      chatSnapshot = _firestore
          .collection('chats')
          .where(
        'users',
        arrayContains: FirebaseAuth.instance.currentUser?.uid,
      )
          .where('last_message', isGreaterThan: "")
          .snapshots();

      await for (var chat in chatSnapshot) {
        List<ChatModel> chats =
        chat.docs.map((e) => ChatModel.fromJson(e.data())).toList();
        chats.sort(
              (a, b) =>
              b.lastMessageTimeStamp!
                  .compareTo(a.lastMessageTimeStamp!),
        );
        yield chats;
      }
    } catch (error) {
      yield null; // ✅ This is correct
    }
  }

  Stream<List<MessageModel>> streamMessageList(String chatId) async* {
    Stream<QuerySnapshot<Map<String, dynamic>>> messageSnaphot;
    messageSnaphot =
        _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy("createdAt", descending: true)
            .snapshots();
    await for (var messageMap in messageSnaphot) {
      List<MessageModel> messageList = [];
      for (var document in messageMap.docs) {
        final message = MessageModel.fromJson(document.data());
        messageList.add(message);
      }
      yield messageList;
    }
  }


  Future<UserModel> getUserById({required String userID}) async {
    final value = await _firestore.collection('users').doc(userID).get();
    UserModel userModel = UserModel.fromJson(value.data() as Map<String, dynamic>);
    return userModel;
  }

  String generateUniqueUID(String input) {
    final bytes = utf8.encode(input);
    final hash = sha256.convert(bytes);
    final uniqueId = hash.toString();
    return uniqueId;
  }
}

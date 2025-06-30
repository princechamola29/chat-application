import 'package:chatapplication/feat/auth/model/user_model.dart';
import 'package:chatapplication/feat/auth/repository/firebase_auth_repository.dart';
import 'package:chatapplication/feat/chat/repository/firebase_chat_repoistory.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getUserByIdProvider = FutureProvider.family<UserModel, String>((
  ref,
  id,
) async {
  final value = await ref
      .read(firebaseChatRepositoryProvider)
      .getUserById(userID: id);
  return value;
});

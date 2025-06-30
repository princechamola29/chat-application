import 'package:chatapplication/feat/chat/repository/firebase_chat_repoistory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userSearchProvider = StateProvider.autoDispose<String?>((state) => null);

final searchControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
      (state) => TextEditingController(text: ""),
    );

final getAllSearchUserProvider = FutureProvider.autoDispose((ref) async {
  final userSearchValue = ref.watch(userSearchProvider);
  final value = await ref
      .watch(firebaseChatRepositoryProvider)
      .fetchSearchQueryData(userName: userSearchValue);
  return value;
});

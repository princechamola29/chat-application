import 'package:chatapplication/feat/chat/model/chat_model.dart';
import 'package:chatapplication/feat/chat/model/message_model.dart';
import 'package:chatapplication/feat/chat/repository/firebase_chat_repoistory.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fetchChatListProvider = StreamProvider.family<List<MessageModel>, String>(
  (ref, chatId) async* {
    final services = ref.read(firebaseChatRepositoryProvider);
    final data = services.streamMessageList(chatId);
    yield* data;
  },
);

final fetchChatHomeProvider = StreamProvider<List<ChatModel>?>((ref) async* {
  final services = ref.read(firebaseChatRepositoryProvider);
  final dataStream = services.streamChatList();

  await for (final data in dataStream) {
    if (data == null || data.isEmpty) {
      yield null; // Emit null when empty or null
    } else {
      yield data;
    }
  }
});
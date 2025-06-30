import 'package:chatapplication/feat/chat/model/chat_screen_model.dart';
import 'package:chatapplication/feat/chat/model/message_model.dart';
import 'package:chatapplication/feat/chat/provider/chat_provider.dart';
import 'package:chatapplication/feat/chat/repository/firebase_chat_repoistory.dart';
import 'package:chatapplication/feat/chat/widgets/chat_bubble_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerWidget {
  final ChatScreenModel chatScreenModel;

  ChatScreen({super.key, required this.chatScreenModel});

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchChatListProviderValue = ref.watch(
      fetchChatListProvider(chatScreenModel.chatId),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(chatScreenModel.userModel.name ?? ''),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                child: fetchChatListProviderValue.when(
                  data: (data) {
                    return ListView.builder(
                      padding: EdgeInsets.all(16),
                      reverse: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return ChatBubbleWidget(
                          isMe:
                          data[index].senderId ==
                              FirebaseAuth.instance.currentUser?.uid,
                          message: data[index].msg ?? "",
                        );
                      },
                    );
                  },
                  error: (_, str) {
                    return Text(str.toString());
                  },
                  loading: () => SizedBox.shrink(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                minLines: 1,
                maxLines: 4,
                controller: _messageController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: "Write Message",
                  suffixIcon: IconButton(
                    onPressed: () async {
                      if (_messageController.text.isNotEmpty) {
                        MessageModel messageModel = MessageModel(
                          createdAt: DateTime.now(),
                          msg: _messageController.text,
                          recieverId: chatScreenModel.userModel.uuid,
                          senderId:
                              FirebaseAuth.instance.currentUser?.uid ?? '',
                        );
                        _messageController.clear();
                        await ref
                            .read(firebaseChatRepositoryProvider)
                            .sendMessages(
                              messageModel: messageModel,
                              chatId: chatScreenModel.chatId,
                            );

                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Message Can't be empty")),
                        );
                      }
                    },
                    icon: Icon(Icons.send),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

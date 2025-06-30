import 'package:chatapplication/feat/auth/widgets/common_textfiled_widget.dart';
import 'package:chatapplication/feat/chat/chat_screen.dart';
import 'package:chatapplication/feat/chat/model/chat_screen_model.dart';
import 'package:chatapplication/feat/chat/provider/chat_provider.dart';
import 'package:chatapplication/feat/chat/provider/user_provider.dart';
import 'package:chatapplication/feat/chat/provider/user_search_provider.dart';
import 'package:chatapplication/feat/chat/repository/firebase_chat_repoistory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomeChatScreen extends ConsumerWidget {
  HomeChatScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getAllSearchUserProviderValue = ref.watch(getAllSearchUserProvider);
    final userSearchProviderValue = ref.watch(userSearchProvider);
    final fetchChatHomeProviderValue = ref.watch(fetchChatHomeProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: Text("HOME CHAT SCREEN"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              CommonTextfiledWidget(
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    ref
                        .read(userSearchProvider.notifier)
                        .update((state) => value);
                  } else {
                    _searchController.clear();
                    ref
                        .read(userSearchProvider.notifier)
                        .update((state) => null);
                  }
                },
                suffixIcon: Icon(Icons.search),
                hintText: "Search",
                controller: _searchController,
              ),
              Expanded(
                child: Stack(
                  children: [
                    SizedBox(height: 24),
                    fetchChatHomeProviderValue.when(
                      data: (data) {
                        if (data == null) {
                          return Center(child: Text("NO CHAT FOUND"));
                        } else {
                          if (data.isNotEmpty) {
                            return ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final otherUserUUid = getOtherUser(
                                  data[index].users ?? [],
                                  FirebaseAuth.instance.currentUser?.uid ?? '',
                                );
                                final getUserByData =
                                    ref
                                        .watch(
                                          getUserByIdProvider(otherUserUUid),
                                        )
                                        .value;
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => ChatScreen(
                                                chatScreenModel:
                                                    ChatScreenModel(
                                                      userModel: getUserByData!,
                                                      chatId: data[index].id ?? '',
                                                      chatModel: data[index]
                                                    ),
                                              ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blue,
                                          ),
                                          child: Text(
                                            getUserByData?.name
                                                    ?.substring(0, 1)
                                                    .toUpperCase() ??
                                                '',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getUserByData?.name ?? '',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(data[index].lastMessage ?? ''),
                                          ],
                                        ),
                                        Spacer(),
                                        Text(
                                          DateFormat.Hm().format(
                                            data[index].lastMessageTimeStamp ??
                                                DateTime.now(),
                                          ),
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(child: Text("NO CHAT FOUND"));
                          }
                        }
                      },
                      error: (_, str) => Text("Error"),
                      loading: () => SizedBox.shrink(),
                    ),
                    if (userSearchProviderValue != null &&
                        userSearchProviderValue.isNotEmpty)
                      getAllSearchUserProviderValue.when(
                        data: (data) {
                          return Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    final value = await ref
                                        .read(firebaseChatRepositoryProvider)
                                        .createChat(
                                          otherUUid: data[index].uuid ?? '',
                                        );
                                    ref
                                        .read(userSearchProvider.notifier)
                                        .update((state) => null);
                                    _searchController.clear();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ChatScreen(
                                              chatScreenModel: ChatScreenModel(
                                                userModel: data[index],
                                                chatId: value,
                                              ),
                                            ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data[index].name ?? '',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        data[index].email ?? '',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        error: (e, st) {
                          return Text(e.toString());
                        },
                        loading: () {
                          return SizedBox.shrink();
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String getOtherUser(List<String> users, String currentUser) {
  return users.firstWhere((user) => user != currentUser);
}

import 'package:chatapplication/feat/auth/model/user_model.dart';
import 'package:chatapplication/feat/chat/model/chat_model.dart';

class ChatScreenModel {
   UserModel userModel;
   String chatId;
   ChatModel? chatModel;

  ChatScreenModel({
    required this.userModel,
    required this.chatId,
     this.chatModel,
  });
}

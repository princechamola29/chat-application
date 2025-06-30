import 'package:flutter/material.dart';

class ChatBubbleWidget extends StatelessWidget {
  final bool isMe;
  final String message;

  const ChatBubbleWidget({
    super.key,
    required this.isMe,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isMe ?Colors.black12 : Colors.blue.withOpacity(0.1) ,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.4,
        ),
        child: Text(message),
      ),
    );
  }
}

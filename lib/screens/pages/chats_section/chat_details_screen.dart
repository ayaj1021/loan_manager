import 'package:flutter/material.dart';
import 'package:loan_manager/config/extension.dart';
import 'package:loan_manager/model/chat_user_model.dart';
import 'package:loan_manager/screens/pages/chats_section/chat_messages_screen.dart';
import 'package:loan_manager/screens/pages/chats_section/chat_text_field.dart';
import 'package:loan_manager/styles/app_text_style.dart';

class ChatDetailsScreen extends StatefulWidget {
  const ChatDetailsScreen({super.key, required this.chatUserModel});

  final ChatUserModel chatUserModel;

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    //  print(widget.chatUserModel.uid);
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ChatMessagesScreen(
              receiverId: widget.chatUserModel.uid,
            ),
            const ChatTextField(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      foregroundColor: Colors.black,
      backgroundColor: Colors.transparent,
      title: Row(children: [
        CircleAvatar(
          backgroundImage: NetworkImage(widget.chatUserModel.image),
          radius: 20,
        ),
        10.width(),
        Column(
          children: [
            Text(
              widget.chatUserModel.name,
              style: AppTextStyle.subTitleStyle(),
            ),
            Text(
              widget.chatUserModel.isOnline ? 'Online' : 'Offline',
              style: AppTextStyle.subTitleStyle(),
            )
          ],
        )
      ]),
    );
  }
}

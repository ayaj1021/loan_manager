import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_manager/model/chat_user_model.dart';
import 'package:loan_manager/styles/app_text_style.dart';
import 'package:loan_manager/styles/colors.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatUserItem extends StatefulWidget {
  const ChatUserItem({super.key, required this.chatUserModel});

  final ChatUserModel chatUserModel;

  @override
  State<ChatUserItem> createState() => _ChatUserItemState();
}

class _ChatUserItemState extends State<ChatUserItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/chat_details_screen');
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(widget.chatUserModel.image),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CircleAvatar(
                radius: 5,
                backgroundColor:
                    widget.chatUserModel.isOnline ? Colors.green : Colors.grey,
              ),
            )
          ],
        ),
        title: Text(
          widget.chatUserModel.name,
          style: AppTextStyle.headerStyle(),
        ),
        subtitle: Text(
          'Last Active: ${timeago.format(widget.chatUserModel.lastActive)}',
          maxLines: 2,
          style: AppTextStyle.subTitleStyle(color: primaryColor),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

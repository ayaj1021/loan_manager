import 'package:flutter/material.dart';
import 'package:loan_manager/config/extension.dart';
import 'package:loan_manager/model/chat_messages_model.dart';
import 'package:loan_manager/styles/app_text_style.dart';
import 'package:loan_manager/styles/colors.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {super.key,
      required this.chatMessagesModel,
      // required this.isMe,
      required this.id});

  final ChatMessagesModel chatMessagesModel;
  // final bool isMe;
  final String id;
  @override
  Widget build(BuildContext context) {
    return 
    // Align(
    //   //  alignment: isMe ? Alignment.topLeft : Alignment.topRight,
    //   alignment: id == "2" ? Alignment.centerLeft : Alignment.centerRight,
    //   child: 
      Container(
        margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          color: id == '2' ? primaryColor : greyColor,
          // color: isMe ? primaryColor : greyColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              chatMessagesModel.content,
              style: AppTextStyle.subTitleStyle(color: whiteColor),
            ),
            5.height(),
            Text(
              timeago.format(chatMessagesModel.sentTime),
              style: AppTextStyle.subTitleStyle(color: whiteColor)
                  .copyWith(fontSize: 10),
            )
          ],
        ),
     // ),
    );
  }
}

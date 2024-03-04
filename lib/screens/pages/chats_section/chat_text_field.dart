import 'package:flutter/material.dart';
import 'package:loan_manager/config/extension.dart';
import 'package:loan_manager/shared/widgets/text_field_widget.dart';
import 'package:loan_manager/styles/colors.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({super.key});

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final chatController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFieldWidget(
            controller: chatController,
            hintText: 'Add message...',
          ),
        ),
        5.width(),
        CircleAvatar(
          backgroundColor: primaryColor,
          radius: 20,
          child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.send,
                color: whiteColor,
              )),
        ),
        5.width(),
        CircleAvatar(
          backgroundColor: primaryColor,
          radius: 20,
          child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.camera_alt_outlined,
                color: whiteColor,
              )),
        )
      ],
    );
  }
}

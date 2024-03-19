import 'package:flutter/material.dart';
import 'package:loan_manager/model/chat_messages_model.dart';
import 'package:loan_manager/screens/pages/chats_section/message_bubble.dart';

class ChatMessagesScreen extends StatelessWidget {
  ChatMessagesScreen({super.key, required this.receiverId});

  final String receiverId;

  final messages = [
    ChatMessagesModel(
      senderId: '2',
      receiverId: 'gNfEHSQZ5ZUcY6JG5AarK8O0SVw1',
      content: 'Hello',
      sentTime: DateTime.now(),
      messageType: MessageType.text,
    ),
    ChatMessagesModel(
      senderId: '2',
      receiverId: 'P2up15h1duhrktCNtgn5o5xO5H53',
      content: 'How are you?',
      sentTime: DateTime.now(),
      messageType: MessageType.text,
    ),
    ChatMessagesModel(
      senderId: '2',
      receiverId: 'P2up15h1duhrktCNtgn5o5xO5H53',
      content: 'Fine',
      sentTime: DateTime.now(),
      messageType: MessageType.text,
    ),
    ChatMessagesModel(
      senderId: '2',
      receiverId: 'P2up15h1duhrktCNtgn5o5xO5H53',
      content: 'What are you doing?',
      sentTime: DateTime.now(),
      messageType: MessageType.text,
    ),
    ChatMessagesModel(
      senderId: '2',
      receiverId: 'P2up15h1duhrktCNtgn5o5xO5H53',
      content: 'Nothing',
      sentTime: DateTime.now(),
      messageType: MessageType.text,
    ),
    ChatMessagesModel(
      senderId: '2',
      receiverId: 'f7Tw4FGqBYkEmXWInpv6',
      content: 'Can you help me?',
      sentTime: DateTime.now(),
      messageType: MessageType.text,
    ),
    ChatMessagesModel(
      senderId: '2',
      receiverId: 'f7Tw4FGqBYkEmXWInpv6',
      content: 'Yes',
      sentTime: DateTime.now(),
      messageType: MessageType.text,
    ),
    ChatMessagesModel(
      senderId: '2',
      receiverId: 'f7Tw4FGqBYkEmXWInpv6',
      content: 'Thank you',
      sentTime: DateTime.now(),
      messageType: MessageType.text,
    ),
    ChatMessagesModel(
      senderId: '2',
      receiverId: 'f7Tw4FGqBYkEmXWInpv6',
      content: 'You are welcome',
      sentTime: DateTime.now(),
      messageType: MessageType.text,
    ),
    ChatMessagesModel(
      senderId: '2',
      receiverId: 'f7Tw4FGqBYkEmXWInpv6',
      content: 'Bye',
      sentTime: DateTime.now(),
      messageType: MessageType.text,
    ),
    ChatMessagesModel(
      senderId: '2',
      receiverId: 'f7Tw4FGqBYkEmXWInpv6',
      content: 'Bye',
      sentTime: DateTime.now(),
      messageType: MessageType.text,
    ),
    ChatMessagesModel(
      senderId: '2',
      receiverId: 'f7Tw4FGqBYkEmXWInpv6',
      content: 'See you later',
      sentTime: DateTime.now(),
      messageType: MessageType.text,
    ),
    ChatMessagesModel(
      senderId: "2",
      receiverId: 'f7Tw4FGqBYkEmXWInpv6',
      content: 'See you later',
      sentTime: DateTime.now(),
      messageType: MessageType.text,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    //  print(receiverId == senderId );
    return Expanded(
      child: ListView(
        children: List.generate(messages.length, (index) {
          return MessageBubble(
            id: messages[index].senderId,
            //  isMe: isMe,
            chatMessagesModel: messages[index],
          );
        }),
        //itemCount: messages.length,
        //  itemBuilder: (context, index) {
        //   final id = receiverId != messages[index].senderId;
        //  final isMe = receiverId != messages[index].senderId;
        //  print(isMe);
        // print(receiverId == messages[index].senderId);
        //   return MessageBubble(
        //     id: messages[index].senderId,
        //     //  isMe: isMe,
        //     chatMessagesModel: messages[index],
        //   );
        // },
      ),
    );
  }
}

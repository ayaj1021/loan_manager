import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loan_manager/model/chat_user_model.dart';
import 'package:loan_manager/provider/firebase_chat_provider/firebase_chat_provider.dart';
import 'package:loan_manager/screens/pages/chats_section/chat_user_item.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    Provider.of<FirebaseChatProvider>(context, listen: false).getAllChatUsers();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final userData = [
    ChatUserModel(
      uid: '1',
      name: 'Hazy',
      email: 'test@test.test',
      image: 'https://i.pravatar.cc/150?img=0',
      isOnline: true,
      lastActive: DateTime.now(),
    ),
    ChatUserModel(
      uid: '2',
      name: 'Charlotte',
      email: 'test@test.test',
      image: 'https://i.pravatar.cc/150?img=1',
      isOnline: false,
      lastActive: DateTime.now(),
    ),
    ChatUserModel(
      uid: '3',
      name: 'Ahmed',
      email: 'test@test.test',
      image: 'https://i.pravatar.cc/150?img=2',
      isOnline: true,
      lastActive: DateTime.now(),
    ),
    ChatUserModel(
      uid: '4',
      name: 'Preteek',
      email: 'test@test.test',
      image: 'https://i.pravatar.cc/150?img=4',
      isOnline: true,
      lastActive: DateTime.now(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Chats"),
          centerTitle: true,
        ),
        body: Consumer<FirebaseChatProvider>(
            builder: (context, firebaseChatProvider, _) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            itemCount: firebaseChatProvider.chatUsers.length,
            itemBuilder: (context, index) =>
                firebaseChatProvider.chatUsers[index].uid !=
                        FirebaseAuth.instance.currentUser?.uid
                    ? ChatUserItem(
                        chatUserModel: firebaseChatProvider.chatUsers[index],
                      )
                    : const SizedBox(),
          );
        }));
  }
}

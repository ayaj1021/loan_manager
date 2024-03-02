import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:loan_manager/model/chat_user_model.dart';

class FirebaseChatProvider extends ChangeNotifier {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  List<ChatUserModel> chatUsers = [];
  List<ChatUserModel> getAllChatUsers() {
    firebaseFirestore
        .collection('loans')
        .orderBy('lastActive', descending: true)
        .snapshots(includeMetadataChanges: true)
        .listen((chatUsers) {
      this.chatUsers = chatUsers.docs
          .map((doc) => ChatUserModel.fromJson(doc.data()))
          .toList();
      notifyListeners();
    });
    return chatUsers;
  }
}

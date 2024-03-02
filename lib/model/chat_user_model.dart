class ChatUserModel {
  final String uid;
  final String name;
  final String email;
  final String image;
  final DateTime lastActive;
  final bool isOnline;

  ChatUserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.image,
    required this.lastActive,
    this.isOnline = false,
  });

  factory ChatUserModel.fromJson(Map<String, dynamic> json) => ChatUserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      image: json['image'],
      lastActive: json['lastActive'].toDate(),
      isOnline: json['isOnline'] ?? false);
}

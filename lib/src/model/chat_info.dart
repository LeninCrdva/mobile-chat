import 'package:objectbox/objectbox.dart';

@Entity()
class ChatInfo {
  @Id(assignable: true)
  int id = 0;
  final String sender;
  final String receiver;
  final String receiverAvatar;

  ChatInfo({
    required this.sender,
    required this.receiver,
    required this.receiverAvatar,
  });

  factory ChatInfo.fromJson(Map<String, dynamic> json) {
    return ChatInfo(
      sender: json['sender'],
      receiver: json['receiver'],
      receiverAvatar: json['receiverAvatar'],
    );
  }
}
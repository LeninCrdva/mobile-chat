import 'package:objectbox/objectbox.dart';
import 'package:simple_chat/src/model/message.dart';

import 'chat_info.dart';

@Entity()
class Chat {
  @Id(assignable: true)
  int id;

  final info = ToOne<ChatInfo>();

  @Backlink('chat')
  final messages = ToMany<Message>();

  Chat({
    required this.id,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    final chat = Chat(
      id: json['id'],
    );

    if (json['lastMessage'] != null) {
      final lastMessage = Message.fromJson(json['lastMessage']);
      chat.messages.add(lastMessage);
    }

    if (json['chatInfo'] != null) {
      final chatInfo = ChatInfo.fromJson(json['chatInfo']);
      chat.info.target = chatInfo;
    }

    return chat;
  }
}
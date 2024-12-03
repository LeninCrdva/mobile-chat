import 'package:objectbox/objectbox.dart';
import 'package:simple_chat/src/model/chat.dart';

@Entity()
class Message {
  @Id(assignable: true)
  int id;
  String content;
  String type;
  String senderUsername;
  String receiver;
  @Property(type: PropertyType.dateNano)
  DateTime? seenAt;
  @Property(type: PropertyType.dateNano)
  DateTime sendAt;
  @Property(type: PropertyType.dateNano)
  DateTime? receivedAt;

  final chat = ToOne<Chat>();

  Message({
    required this.id,
    required this.content,
    required this.type,
    required this.senderUsername,
    required this.receiver,
    required this.sendAt,
    this.seenAt,
    this.receivedAt,
  });

  toJson() => {
    'id': id,
    'content': content,
    'type': type,
    'sender': senderUsername,
    'receiver': receiver,
    'sendAt': sendAt.toIso8601String(),
  };

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      type: json['type'],
      senderUsername: json['senderUsername'],
      receiver: json['receiver'],
      sendAt: DateTime.parse(json['sendAt']),
      seenAt: json['seenAt'] != null ? DateTime.parse(json['seenAt']) : null,
      receivedAt: json['receivedAt'] != null ? DateTime.parse(json['receivedAt']) : null,
    );
  }
}
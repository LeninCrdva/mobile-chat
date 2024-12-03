class MessageRequest {
  final String sender;
  final int chat;
  final String content;
  final String type;

  MessageRequest(this.content, this.sender, this.chat, this.type);

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'sender': sender,
      'chat': chat,
      'type': type,
    };
  }
}
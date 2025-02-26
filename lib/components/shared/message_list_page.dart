import 'package:flutter/material.dart';
import 'package:simple_chat/components/shared/message.dart';
import 'package:simple_chat/main.dart';
import 'package:simple_chat/src/model/message.dart';
import 'package:simple_chat/src/model/message_request.dart';
import 'package:simple_chat/src/service/message_service.dart';
import 'package:simple_chat/src/utils/token_claim.dart';
import 'package:simple_chat/utils/content_type.dart';

class MessageListPage extends StatefulWidget {
  final String avatarUrl;
  final String contactName;
  final int chatId;

  const MessageListPage(
      {super.key,
      required this.avatarUrl,
      required this.contactName,
      required this.chatId});

  @override
  State<MessageListPage> createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  MessageService msgService = MessageService(objectBox.store.box<Message>());
  final _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TokenClaims claims = TokenClaims();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      msgService.loadMessages(widget.chatId);
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: IconButton(
          icon: Row(
            children: [
              const Icon(Icons.arrow_back),
              CircleAvatar(
                backgroundImage: NetworkImage(widget.avatarUrl),
                radius: 20,
              ),
            ],
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.contactName),
      ),
      body: StreamBuilder<List<Message>>(
        stream: msgService.getDataByIdOrNotAsStream(widget.chatId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final chats = snapshot.data!;

          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            _scrollToBottom();
          });

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final message = chats[index];
                    final nextMessage =
                        index < chats.length - 1 ? chats[index + 1] : null;
                    final prevMessage = index > 0 ? chats[index - 1] : null;

                    final isConsecutive =
                        prevMessage?.senderUsername == message.senderUsername;
                    final isLastConsecutive =
                        nextMessage?.senderUsername != message.senderUsername;

                    return MessageComponent(
                      message: message.content,
                      sender: message.senderUsername!,
                      receiver: message.receiver!,
                      dateReceived: message.sendAt,
                      isSender: message.senderUsername != widget.contactName,
                      receiverAvatar: widget.avatarUrl,
                      isConsecutive: isConsecutive,
                      isLastConsecutive: isLastConsecutive,
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: 'Type a message',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        if (_textController.text.isEmpty) return;

                        final msg = MessageRequest(
                          _textController.text,
                          await claims.extractStringClaim("sub"),
                          widget.chatId,
                          ContentTypeMessage.text.name,
                        );

                        msgService.sendMessage(msg);

                        _textController.clear();
                        _scrollToBottom();
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
    }
  }
}

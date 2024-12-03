import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_chat/components/shared/message.dart';
import 'package:simple_chat/src/model/message.dart';
import 'package:simple_chat/src/model/message_request.dart';
import 'package:simple_chat/src/service/message_service.dart';
import 'package:simple_chat/src/service/toast_service.dart';
import 'package:simple_chat/src/utils/token_claim.dart';
import 'package:simple_chat/src/websocket/websocket_provider.dart';
import 'package:simple_chat/utils/content_type.dart';

class ChatPage extends StatefulWidget {
  final String avatarUrl;
  final String contactName;
  final int chatId;

  const ChatPage(
      {super.key,
      required this.avatarUrl,
      required this.contactName,
      required this.chatId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TokenClaims claims = TokenClaims();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MessageService>(context, listen: false)
          .loadChat(widget.chatId);
      context.read<WebSocketProvider>().initialize(); // Inicializa el WebSocket
      context.read<WebSocketProvider>().connect(); // Conecta el WebSocket
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    context.read<WebSocketProvider>().disconnect();
    super.dispose();
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
      body: Consumer<WebSocketProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Expanded(
                child: Consumer<MessageService>(
                  builder: (context, provider, child) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      _scrollToBottom();
                    });

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: provider.messages.length,
                      itemBuilder: (context, index) {
                        final message = provider.messages[index];
                        final nextMessage = index < provider.messages.length - 1
                            ? provider.messages[index + 1]
                            : null;
                        final prevMessage =
                            index > 0 ? provider.messages[index - 1] : null;

                        final isConsecutive = prevMessage?.senderUsername ==
                            message.senderUsername;
                        final isLastConsecutive = nextMessage?.senderUsername !=
                            message.senderUsername;

                        return MessageComponent(
                          message: message.content,
                          sender: message.senderUsername,
                          receiver: message.receiver,
                          dateReceived: message.sendAt,
                          isSender:
                              message.senderUsername != widget.contactName,
                          receiverAvatar: widget.avatarUrl,
                          isConsecutive: isConsecutive,
                          isLastConsecutive: isLastConsecutive,
                        );
                      },
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
                        provider.sendMessage(
                          MessageRequest(
                            _textController.text,
                            await claims.extractStringClaim("sub"),
                            widget.chatId,
                            ContentTypeMessage.text.name,
                          ),
                        );
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
